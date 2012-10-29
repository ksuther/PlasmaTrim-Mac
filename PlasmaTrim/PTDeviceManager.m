//
//  PTDeviceManager.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/9/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTDeviceManager.h"
#import "PTDevice.h"
#import "ptrim-lib.h"
#import "hidapi.h"
#import <IOKit/hid/IOHIDManager.h>
#import <IOKit/hid/IOHIDKeys.h>

NSString * const PTDeviceManagerDidUpdateDevicesNotification = @"PTDeviceManagerDidUpdateDevicesNotification";

const NSInteger kPhotonFactoryVendorID = 0x26f3;
const NSInteger kPlasmaTrimProductID = 0x1000;

static void deviceMatchedCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device)
{
    [(__bridge PTDeviceManager *)context rescanForDevices];
}

static void deviceRemovedCallback(void *context, IOReturn result, void *sender, IOHIDDeviceRef device)
{
    [(__bridge PTDeviceManager *)context rescanForDevices];
}

@interface PTDeviceManager () {
    IOHIDManagerRef _manager;
    
    NSMutableSet *_openDevices;
}
@end

@implementation PTDeviceManager

+ (instancetype)sharedManager
{
    static PTDeviceManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    if ( (self = [super init]) ) {
        _openDevices = [NSMutableSet set];
        
    }
    return self;
}

- (void)setSelectedDevice:(PTDevice *)selectedDevice
{
    if (_selectedDevice != selectedDevice) {
        [_selectedDevice close];
        _selectedDevice = selectedDevice;
        [selectedDevice open];
    }
}

- (void)startManager
{
    [self stopManager];
    
    hid_init();
    
    NSDictionary *matchingDictionary = @{
        @(kIOHIDVendorIDKey): @(kPhotonFactoryVendorID),
        @(kIOHIDProductIDKey): @(kPlasmaTrimProductID)
    };
    
    _manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    
    IOHIDManagerSetDeviceMatching(_manager, (__bridge CFDictionaryRef)matchingDictionary);
    IOHIDManagerRegisterDeviceMatchingCallback(_manager, deviceMatchedCallback, (__bridge void *)self);
    IOHIDManagerRegisterDeviceRemovalCallback(_manager, deviceRemovedCallback, (__bridge void *)self);
    
    IOHIDManagerScheduleWithRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    
    IOReturn status = IOHIDManagerOpen(_manager, kIOHIDOptionsTypeNone);
    
    if (status != kIOReturnSuccess) {
        NSLog(@"error %x", status);
    }
}

- (void)stopManager
{
    if (_manager) {
        IOHIDManagerUnscheduleFromRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        
        IOHIDManagerClose(_manager, kIOHIDOptionsTypeNone);
        CFRelease(_manager);
        _manager = NULL;
        
        hid_exit();
    }
}

- (void)rescanForDevices
{
    NSMutableArray *devices = [NSMutableArray array];
    NSString *selectedDevicePath = [[self selectedDevice] devicePath];
    
    struct hid_device_info *hidDevices = hid_enumerate(kPhotonFactoryVendorID, kPlasmaTrimProductID);
    struct hid_device_info *nextHIDDevice = hidDevices;
    
    while (nextHIDDevice) {
        NSString *devicePath = [NSString stringWithUTF8String:nextHIDDevice->path];
        PTDevice *device = [[PTDevice alloc] initWithDevicePath:devicePath];
        
        //Open the device just to get the name and serial
        if ([device open]) {
            [device close];
        }
        
        [devices addObject:device];
        
        nextHIDDevice = nextHIDDevice->next;
        
        if ([devicePath isEqualToString:selectedDevicePath]) {
            [self setSelectedDevice:device];
        }
    }
    
    hid_free_enumeration(hidDevices);
    
    _devices = [NSArray arrayWithArray:devices];
    
    if (![self selectedDevice] && [devices count] > 0) {
        //Select the first device by default
        [self setSelectedDevice:[devices objectAtIndex:0]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PTDeviceManagerDidUpdateDevicesNotification object:nil];
}

@end
