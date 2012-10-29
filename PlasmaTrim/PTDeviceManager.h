//
//  PTDeviceManager.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/9/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PTDeviceManagerDidUpdateDevicesNotification;

@class PTDevice;

@interface PTDeviceManager : NSObject

@property(nonatomic, strong, readonly) NSArray *devices;
@property(nonatomic, strong) PTDevice *selectedDevice;

+ (instancetype)sharedManager;

- (void)startManager;
- (void)stopManager;

- (void)rescanForDevices;

@end
