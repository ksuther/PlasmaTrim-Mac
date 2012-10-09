//
//  NSColor+PTAdditions.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "NSColor+PTAdditions.h"

@implementation NSColor (PTAdditions)

+ (instancetype)colorWithShortHexString:(NSString *)string
{
    NSAssert([string length] == 3, @"Hex string must be of length 3");
    
    unsigned int red, green, blue;
    
    [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(0, 1)]] scanHexInt:&red];
    [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(1, 1)]] scanHexInt:&green];
    [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(2, 1)]] scanHexInt:&blue];
    
    return [self colorWithCalibratedRed:(CGFloat)red / 15 green:(CGFloat)green / 15 blue:(CGFloat)blue / 15 alpha:1.0];
}

- (NSColor *)pt_nearestValidColor
{
    unsigned int red = (unsigned int)round([self redComponent] * 15);
    unsigned int green = (unsigned int)round([self greenComponent] * 15);
    unsigned int blue = (unsigned int)round([self blueComponent] * 15);
    
    return [NSColor colorWithCalibratedRed:(CGFloat)red / 15 green:(CGFloat)green / 15 blue:(CGFloat)blue / 15 alpha:1.0];
}

- (NSString *)pt_hexString
{
    NSColor *color = [self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    
    unsigned int red = (unsigned int)round([color redComponent] * 15);
    unsigned int green = (unsigned int)round([color greenComponent] * 15);
    unsigned int blue = (unsigned int)round([color blueComponent] * 15);
    
    return [[NSString stringWithFormat:@"%01x%01x%01x", red, green, blue] uppercaseString];
}

@end
