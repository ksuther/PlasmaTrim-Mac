//
//  PTDocument.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTDocument.h"
#import "PTSequence.h"
#import "PTSequenceView.h"
#import "PTStageView.h"
#import "NSColor+PTAdditions.h"

@interface PTDocument ()
@property(nonatomic, strong) PTSequence *sequence;
@property(nonatomic, strong) NSColor *currentColor;
@end

@implementation PTDocument

- (id)init
{
    if ( (self = [super init]) ) {
        [self setSequence:[[PTSequence alloc] init]];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"PTDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [[[self sequence] documentString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    PTSequence *sequence = [[PTSequence alloc] initWithString:string];
    
    if (sequence) {
        [self setSequence:sequence];
    } else if (outError) {
        *outError = [NSError errorWithDomain:@"com.ksuther.PlasmaTrim" code:1 userInfo:nil];
    }
    
    return sequence != nil;
}

- (void)setSequence:(PTSequence *)sequence
{
    if (_sequence != sequence) {
        _sequence = sequence;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sequenceView] setSequence:sequence];
        });
    }
}

- (IBAction)colorChanged:(id)sender
{
    NSColor *color = [[sender color] pt_nearestValidColor];
    
    [self setCurrentColor:color];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender setColor:color];
        [[NSColorPanel sharedColorPanel] setColor:color];
    });
}

@end
