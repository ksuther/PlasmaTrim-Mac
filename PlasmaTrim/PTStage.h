//
//  PTStage.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger PTStageColorCount = 8;

typedef enum : NSUInteger {
    PTStageTimeNone = '0',
    PTStageTimeTenthSecond = '1',
    PTStageTimeQuarterSecond = '2',
    PTStageTimeHalfSecond = '3',
    PTStageTimeOneSecond = '4',
    PTStageTimeTwoAndAHalfSeconds = '5',
    PTStageTimeFiveSeconds = '6',
    PTStageTimeTenSeconds = '7',
    PTStageTimeFifteenSeconds = '8',
    PTStageTimeThirtySeconds = '9',
    PTStageTimeOneMinute = 'A',
    PTStageTimeTwoAndAHalfMinutes = 'B',
    PTStageTimeFiveMinutes = 'C',
    PTStageTimeTenMinutes = 'D',
    PTStageTimeFifteenMinutes = 'E',
    PTStageTimeThirtyMinutes = 'F',
} PTStageTime;

@interface PTStage : NSObject

@property(nonatomic, assign) PTStageTime fadeTime;
@property(nonatomic, assign) PTStageTime holdTime;

+ (instancetype)emptyStage;

- (id)initWithString:(NSString *)string;

- (NSString *)documentString;

- (NSColor *)colorAtIndex:(NSUInteger)index;
- (void)setColor:(NSColor *)color atIndex:(NSUInteger)index;

@end
