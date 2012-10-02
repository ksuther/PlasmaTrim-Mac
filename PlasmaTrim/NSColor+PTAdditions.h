//
//  NSColor+PTAdditions.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (PTAdditions)

//expects a 3-letter hex color
+ (instancetype)colorWithShortHexString:(NSString *)string;

//returns the nearest valid color usable by the PlasmaTrim
- (NSColor *)pt_nearestValidColor;

//return a 3-letter hex code representing the color (performs a lossy conversion if necessary)
- (NSString *)pt_hexString;

@end
