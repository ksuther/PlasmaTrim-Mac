//
//  PTDocument.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTDocument.h"
#import "PTSequence.h"
#import "PTStage.h"
#import "PTSequenceView.h"
#import "PTStageView.h"
#import "PTDeviceManager.h"
#import "NSColor+PTAdditions.h"

@interface PTDocument () <PTSequenceViewDelegate> {
    BOOL _settingLastStage;
}
@property(nonatomic, strong) PTSequence *sequence;
@property(nonatomic, strong) NSColor *currentColor;
@end

@implementation PTDocument

- (id)init
{
    if ( (self = [super init]) ) {
        [self setSequence:[[PTSequence alloc] init]];
        
        [self setCurrentColor:[NSColor whiteColor]];
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
    
    [[self colorWell] setColor:[self currentColor]];
    
    //Set the fade/hold identifier based on the first character of the menu item
    //This assumes that the first character of all the titles is 0-F
    for (NSInteger i = 0; i < [[self timePopUpButton] numberOfItems]; i++) {
        NSMenuItem *item = [[[self timePopUpButton] menu] itemAtIndex:i];
        
        [item setTag:[[item title] characterAtIndex:0]];
    }
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

- (IBAction)changeLastStage:(id)sender
{
    NSString *title;
    
    if (_settingLastStage) {
        _settingLastStage = NO;
        
        title = NSLocalizedString(@"Set Last Stage", nil);
    } else {
        _settingLastStage = YES;
        
        title = NSLocalizedString(@"Click Last Stage", nil);
    }
    
    [sender setTitle:title];
}

- (IBAction)colorChanged:(id)sender
{
    NSColor *color = [[sender color] pt_nearestValidColor];
    
    [self setCurrentColor:color];
}

- (IBAction)uploadSequence:(id)sender
{
    
}

#pragma mark -

- (void)setCurrentColor:(NSColor *)currentColor
{
    if (_currentColor != currentColor) {
        _currentColor = currentColor;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self colorWell] setColor:currentColor];
            [[NSColorPanel sharedColorPanel] setColor:currentColor];
        });
    }
}

#pragma mark - PTSequenceView Delegate

- (void)sequenceView:(PTSequenceView *)sequenceView didSelectColorRange:(NSRange)colorRange inStageAtIndex:(NSUInteger)stageIndex
{
    if (_settingLastStage) {
        //Set the last stage in the sequence
        [[self sequence] setLastSlotIndex:stageIndex + 1];
        [self changeLastStage:[self lastStageButton]];
    } else {
        PTStage *stage = [[self sequence] stageAtIndex:stageIndex];
        
        for (NSUInteger j = colorRange.location; j < NSMaxRange(colorRange); j++) {
            [stage setColor:[self currentColor] atIndex:j];
        }
    }
    
    [sequenceView reloadData];
    
    [self updateChangeCount:NSChangeDone]; //need to change this to newer methods to handle autosave and undo
}

- (void)sequenceView:(PTSequenceView *)sequenceView didSelectHoldTimeInStageAtIndex:(NSUInteger)stageIndex
{
    [[[self sequence] stageAtIndex:stageIndex] setHoldTime:[[[[self timePopUpButton] selectedItem] title] characterAtIndex:0]];
    
    [sequenceView reloadData];
}

- (void)sequenceView:(PTSequenceView *)sequenceView didSelectFadeTimeInStageAtIndex:(NSUInteger)stageIndex
{
    [[[self sequence] stageAtIndex:stageIndex] setFadeTime:[[[[self timePopUpButton] selectedItem] title] characterAtIndex:0]];
    
    [sequenceView reloadData];
}

- (void)sequenceView:(PTSequenceView *)sequenceView willTakeColorAtIndex:(NSUInteger)colorIndex inStageAtIndex:(NSUInteger)stageIndex
{
    PTStage *stage = [[self sequence] stageAtIndex:stageIndex];
    
    [self setCurrentColor:[stage colorAtIndex:colorIndex]];
}

@end
