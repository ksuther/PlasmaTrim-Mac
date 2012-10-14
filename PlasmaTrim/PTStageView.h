//
//  PTStageView.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static const CGFloat PTStageViewWidth = 16;
static const CGFloat PTStageViewHeight = 16 * 10;

@class PTStage;

@interface PTStageView : NSView

@property(nonatomic, weak) PTStage *stage;
@property(nonatomic, assign, getter=isActive) BOOL active;

- (void)reloadData;

- (NSRange)colorRangeForRect:(NSRect)rect; //return the range of colors enclosed by rect

- (NSRect)rectForHoldTime;
- (NSRect)rectForFadeTime;

@end
