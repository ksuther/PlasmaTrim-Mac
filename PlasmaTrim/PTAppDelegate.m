//
//  PTAppDelegate.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTAppDelegate.h"
#import "PTDeviceManager.h"
#import "PTDeviceWindowController.h"

@interface PTAppDelegate ()
@property(nonatomic, strong) PTDeviceWindowController *deviceWindowController;
@end

@implementation PTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[PTDeviceManager sharedManager] startManager];

    [self showDevices:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[PTDeviceManager sharedManager] stopManager];
}

- (IBAction)showDevices:(id)sender
{
    if (![self deviceWindowController]) {
        [self setDeviceWindowController:[[PTDeviceWindowController alloc] init]];
    }
    
    [[self deviceWindowController] showWindow:nil];
}

@end
