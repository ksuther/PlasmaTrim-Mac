//
//  PTSequence.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger PTSequenceMaxStageCount = 76;

@class PTStage;

@interface PTSequence : NSObject

@property(nonatomic, assign) NSUInteger lastSlotIndex;
@property(nonatomic, strong, readonly) NSArray *stages;

- (id)initWithString:(NSString *)string;

- (PTStage *)stageAtIndex:(NSUInteger)index;
- (void)setStage:(PTStage *)stage atIndex:(NSUInteger)index;

- (NSString *)documentString;

@end
