//
//  PTDevice.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/16/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDManager.h>

@class PTSequence;

@interface PTDevice : NSObject

@property(nonatomic, strong, readonly) NSString *devicePath;
@property(nonatomic, strong, readonly) NSString *deviceName; //returns nil if the name hasn't been read yet
@property(nonatomic, strong, readonly) NSString *serialNumber; //returns nil if the serial hasn't been read yet
@property(nonatomic, assign, getter=isOpen, readonly) BOOL open;

- (id)initWithDevicePath:(NSString *)devicePath;

- (BOOL)open;
- (BOOL)close;

- (void)startSequence;
- (void)stopSequence;

- (PTSequence *)downloadSequence;
- (BOOL)uploadSequence:(PTSequence *)sequence;

@end
