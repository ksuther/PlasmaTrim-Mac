//
//  PTSequenceView.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTSequence;

@interface PTSequenceView : NSView

@property(nonatomic, weak) PTSequence *sequence;

@end
