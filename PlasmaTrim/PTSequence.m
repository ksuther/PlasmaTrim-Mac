//
//  PTSequence.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTSequence.h"
#import "PTStage.h"

@interface PTSequence () {
    NSMutableArray *_stages;
}
@end

@implementation PTSequence

- (id)initWithString:(NSString *)string
{
    if ( (self = [super init]) ) {
        _stages = [NSMutableArray array];
        
        NSScanner *scanner = [NSScanner scannerWithString:string];
        
        //Add error checking someday and return nil if an error is encountered
        //It'd probably also be sensible to add something that validates the document format and returns descriptive errors
        BOOL scanned;
        
        scanned = [scanner scanString:@"PlasmaTrim RGB-8 Sequence" intoString:NULL];
        scanned = [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        scanned = [scanner scanString:@"Version: Simple Sequence Format" intoString:NULL];
        scanned = [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        scanned = [scanner scanString:@"Active Slots: " intoString:NULL];
        scanned = [scanner scanInteger:(NSInteger *)&_lastSlotIndex];
        scanned = [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        
        NSString *nextLine;
        
        while ( (scanned = [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&nextLine]) ) {
            PTStage *nextStage = [[PTStage alloc] initWithString:nextLine];
            
            [_stages addObject:nextStage];
            
            scanned = [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        }
    }
    return self;
}

- (id)init
{
    if ( (self = [super init]) ) {
        _stages = [NSMutableArray array];
        _lastSlotIndex = PTSequenceMaxStageCount;
        
        for (NSUInteger i = 0; i < PTSequenceMaxStageCount; i++) {
            [_stages addObject:[PTStage emptyStage]];
        }
    }
    return self;
}

- (NSString *)documentString
{
    NSMutableString *documentString = [NSMutableString string];
    
    [documentString appendString:@"PlasmaTrim RGB-8 Sequence\r\n"];
    [documentString appendString:@"Version: Simple Sequence Format\r\n"];
    [documentString appendFormat:@"Active Slots: %lu\r\n", _lastSlotIndex];
    
    NSUInteger row = 0;
    
    for (PTStage *nextStage in _stages) {
        [documentString appendFormat:@"slot %02lu %@\r\n", row, [nextStage documentString]];
        
        row++;
    }
    
    [documentString appendString:@"\r\n"];
    
    return documentString;
}

- (PTStage *)stageAtIndex:(NSUInteger)index
{
    return [_stages objectAtIndex:index];
}

- (void)setStage:(PTStage *)stage atIndex:(NSUInteger)index
{
    [_stages replaceObjectAtIndex:index withObject:stage];
}

@end
