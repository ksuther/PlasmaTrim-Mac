//
//  PTDeviceWindowController.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTDeviceWindowController.h"
#import "PTDeviceManager.h"
#import "PTDevice.h"

@interface PTDeviceWindowController ()
@property(nonatomic, weak) IBOutlet NSPopUpButton *devicesPopUpButton;
@property(nonatomic, weak) IBOutlet NSSlider *brightnessSlider;

- (void)_reloadUI;
@end

@implementation PTDeviceWindowController

- (id)init
{
    if ( (self = [super initWithWindowNibName:@"Devices"]) ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateDevices:) name:PTDeviceManagerDidUpdateDevicesNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [[self window] setExcludedFromWindowsMenu:YES];
    
    [self _reloadUI];
}

- (void)didUpdateDevices:(NSNotification *)notification
{
    [self _reloadUI];
}

#pragma mark - IBActions

- (IBAction)changeActiveDevice:(id)sender
{
    [[PTDeviceManager sharedManager] setSelectedDevice:[[sender selectedItem] representedObject]];
}

- (IBAction)startSequence:(id)sender
{
    [[[PTDeviceManager sharedManager] selectedDevice] startSequence];
}

- (IBAction)stopSequence:(id)sender
{
    [[[PTDeviceManager sharedManager] selectedDevice] stopSequence];
}

#pragma mark - Private

- (void)_reloadUI
{
    NSArray *devices = [[PTDeviceManager sharedManager] devices];
    
    [[self devicesPopUpButton] setEnabled:[devices count] > 0];
    [[self devicesPopUpButton] removeAllItems];
    
    if ([devices count] == 0) {
        [[self devicesPopUpButton] addItemWithTitle:NSLocalizedString(@"No PlasmaTrims found", @"No PlasmaTrims found")];
    }
    
    for (PTDevice *nextDevice in devices) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] init];
        
        [menuItem setTitle:[nextDevice deviceName]];
        [menuItem setRepresentedObject:nextDevice];
        
        [[[self devicesPopUpButton] menu] addItem:menuItem];
        
        if (nextDevice == [[PTDeviceManager sharedManager] selectedDevice]) {
            [[self devicesPopUpButton] selectItem:menuItem];
        }
    }
}

@end
