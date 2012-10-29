//
//  PTDeviceWindowController.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 10/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PTDeviceWindowController : NSWindowController

- (IBAction)changeActiveDevice:(id)sender;
- (IBAction)downloadSequence:(id)sender;
- (IBAction)startSequence:(id)sender;
- (IBAction)stopSequence:(id)sender;

@end
