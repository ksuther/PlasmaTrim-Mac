//
//  PTStageView.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static const CGFloat PTStageViewWidth = 20;
static const CGFloat PTStageViewHeight = 20 * 10;

@class PTStage;

@interface PTStageView : NSView

@property(nonatomic, weak) PTStage *stage;

@end
