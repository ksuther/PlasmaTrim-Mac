//
//  PTStage.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTStage.h"
#import "NSColor+PTAdditions.h"

@interface PTStage () {
    NSColor *_colors[PTStageColorCount];
}
@end

@implementation PTStage

+ (instancetype)emptyStage
{
    PTStage *stage = [[self alloc] init];
    
    [stage setFadeTime:PTStageTimeNone];
    [stage setHoldTime:PTStageTimeNone];
    
    for (NSUInteger i = 0; i < PTStageColorCount; i++) {
        [stage setColor:[NSColor blackColor] atIndex:i];
    }
    
    return stage;
}

- (id)initWithString:(NSString *)string
{
    if ( (self = [super init]) ) {
        //Assume the incoming string is valid for now
        
        //These may be swapped
        [self setFadeTime:(PTStageTime)[string characterAtIndex:8]];
        [self setHoldTime:(PTStageTime)[string characterAtIndex:10]];
        
        for (NSUInteger i = 0; i < PTStageColorCount; i++) {
            NSString *colorString = [string substringWithRange:NSMakeRange(14 + i * 3, 3)];
            
            _colors[i] = [NSColor colorWithShortHexString:colorString];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self documentString]];
}

- (NSString *)documentString
{
    NSMutableString *colorString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < PTStageColorCount; i++) {
        NSColor *color = [self colorAtIndex:i];
        
        if (!color) {
            return nil;
        }
        
        [colorString appendString:[color pt_hexString]];
    }
    
    return [NSString stringWithFormat:@"%c %c - %@", (char)[self fadeTime], (char)[self holdTime], colorString];
}

- (NSColor *)colorAtIndex:(NSUInteger)index
{
    if (index > sizeof(_colors)) {
        @throw [[NSException alloc] initWithName:@"PTOutOfBoundsException"
                                          reason:[NSString stringWithFormat:@"Index %lu out of allowed range: [0, %lu]", index, sizeof(_colors)]
                                        userInfo:nil];
    }
    
    return _colors[index];
}

- (void)setColor:(NSColor *)color atIndex:(NSUInteger)index
{
    if (index > sizeof(_colors)) {
        @throw [[NSException alloc] initWithName:@"PTOutOfBoundsException"
                                          reason:[NSString stringWithFormat:@"Index %lu out of allowed range: [0, %lu]", index, sizeof(_colors)]
                                        userInfo:nil];
    }
    
    _colors[index] = color;
}

@end
