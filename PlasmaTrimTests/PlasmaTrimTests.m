//
//  PlasmaTrimTests.m
//  PlasmaTrimTests
//
//  Created by Kent Sutherland on 11/5/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PlasmaTrimTests.h"
#import "NSColor+PTAdditions.h"

@implementation PlasmaTrimTests

- (void)setUp
{
    // Set-up code here.
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testColorRoundTrip
{
    NSString *initialHexString = @"F00";
    NSColor *color = [NSColor colorWithShortHexString:initialHexString];
    
    STAssertEqualObjects(initialHexString, [color pt_hexString], @"Hex string didn't go round trip through NSColor correctly");
}

@end
