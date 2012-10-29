//
//  PTDevice.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/16/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTDevice.h"
#import "PTDeviceManager.h"
#import "PTSequence.h"
#import "hidapi.h"
#import "ptrim-lib.h"

static const NSInteger kPTDeviceNumberOfLines = 1024;
static const NSInteger kPTDeviceLineSize = 100;

@interface PTDevice () {
    hid_device *_device;
    
    size_t _reportSize;
    uint8_t *_reportBuffer;
}
- (void)_requestNameAndSerial;
@end

@implementation PTDevice

- (id)initWithDevicePath:(NSString *)devicePath
{
    if ( (self = [super init]) ) {
        _devicePath = devicePath;
    }
    return self;
}

- (void)dealloc
{
    [self close];
}

- (BOOL)open
{
    if (![self isOpen]) {
        _device = hid_open_path([[self devicePath] UTF8String]);
        _deviceName = NSLocalizedString(@"Unidentified PlasmaTrim", @"Unidentified PlasmaTrim");
        
        if (_device) {
            [self _requestNameAndSerial];
            
            _open = YES;
        }
    }
    
    return _open;
}

- (BOOL)close
{
    if ([self isOpen]) {
        hid_close(_device);
        _device = nil;
        
        _open = NO;
    }
    
    return YES;
}

- (void)startSequence
{
    [self open];
    
    start(_device);
}

- (void)stopSequence
{
    stop(_device);
}

- (PTSequence *)downloadSequence
{
    char *fileData[kPTDeviceNumberOfLines];
    
    for (NSUInteger i = 0; i < kPTDeviceNumberOfLines; i++) {
        fileData[i] = malloc(sizeof(char) * kPTDeviceLineSize);
    }
    
    download(_device, fileData, (int)kPTDeviceLineSize, (int)kPTDeviceNumberOfLines, true);
    
    NSMutableString *sequenceString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < kPTDeviceNumberOfLines; i++) {
        NSString *nextLine = [NSString stringWithUTF8String:fileData[i]];
        
        if ([nextLine length]) {
            [sequenceString appendString:nextLine];
        }
        
        free(fileData[i]);
    }
    
    return [[PTSequence alloc] initWithString:sequenceString];
}

- (BOOL)uploadSequence:(PTSequence *)sequence
{
    NSString *sequenceString = [sequence documentString];
    NSArray *lines = [sequenceString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    char *fileData[kPTDeviceNumberOfLines] = {};
    NSInteger lineIndex = 0;
    
    for (NSUInteger i = 0; lineIndex < kPTDeviceNumberOfLines && i < [lines count]; i++) {
        NSString *lineString = [lines objectAtIndex:i];
        
        if ([lineString length] > 0) {
            lineString = [lineString stringByAppendingString:@"\r\n"];
            
            fileData[lineIndex] = calloc(1, sizeof(char) * kPTDeviceLineSize);
            
            strncpy(fileData[lineIndex], [lineString UTF8String], [lineString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
            
            lineIndex++;
        }
    }
    
    for (NSUInteger i = lineIndex; i < kPTDeviceNumberOfLines; i++) {
        fileData[i] = "\r\n";
    }
    
    NSInteger status = upload(_device, fileData, true, 0, 1, YES);
    
    for (NSUInteger i = 0; i < lineIndex; i++) {
        free(fileData[i]);
    }
    
    return status == 0;
}

#pragma mark - Private

- (void)_requestNameAndSerial
{
    const char *serial = getSerial(_device);
    const char *name = getName(_device);
    
    _serialNumber = [NSString stringWithUTF8String:serial];
    _deviceName = [NSString stringWithUTF8String:name];
}

@end
