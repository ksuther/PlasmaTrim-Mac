//
//  PTStageView.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTStageView.h"
#import "PTStage.h"

static const CGFloat BlockHeight = 16;

@interface PTStageView ()
@property(nonatomic, strong) NSTextField *holdTextField;
@property(nonatomic, strong) NSTextField *fadeTextField;
@end

@implementation PTStageView

- (id)initWithFrame:(NSRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        _holdTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, BlockHeight * PTStageColorCount, PTStageViewWidth, BlockHeight)];
        _fadeTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, BlockHeight * (PTStageColorCount + 1), PTStageViewWidth, BlockHeight)];
        
        for (NSTextField *nextTextField in @[_holdTextField, _fadeTextField]) {
            [nextTextField setFont:[NSFont systemFontOfSize:12]];
            [nextTextField setAlignment:NSCenterTextAlignment];
            [nextTextField setEditable:NO];
            [nextTextField setSelectable:NO];
            [nextTextField setBordered:NO];
            [nextTextField setDrawsBackground:NO];
            
            [self addSubview:nextTextField];
        }
    }
    
    return self;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    for (NSInteger i = 0; i < PTStageColorCount; i++) {
        [[[self stage] colorAtIndex:i] set];
        NSRectFill(NSMakeRect(1, i * BlockHeight, PTStageViewWidth - 2, BlockHeight - 2));
    }
    
    if (![self isActive]) {
        [[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] set];
        
        NSRectFillUsingOperation([[self holdTextField] frame], NSCompositeSourceOver);
        NSRectFillUsingOperation([[self fadeTextField] frame], NSCompositeSourceOver);
    }
}

- (void)setStage:(PTStage *)stage
{
    if (_stage != stage) {
        _stage = stage;
        
        [self reloadData];
    }
}

- (void)setActive:(BOOL)active
{
    _active = active;
    
    [self setNeedsDisplay:YES];
}

- (void)reloadData
{
    NSString *holdString = [NSString stringWithFormat:@"%c", (char)[[self stage] holdTime]];
    NSString *fadeString = [NSString stringWithFormat:@"%c", (char)[[self stage] fadeTime]];
    
    [[self holdTextField] setStringValue:holdString];
    [[self fadeTextField] setStringValue:fadeString];
    
    [self setNeedsDisplay:YES];
}

- (NSRange)colorRangeForRect:(NSRect)rect
{
    NSRange range = NSMakeRange(0, 0);
    
    //Make sure the rect is in the view
    if (NSMaxX(rect) < 0 || NSMinX(rect) > NSWidth([self bounds])) {
        return range;
    }
    
    if (NSMaxY(rect) < 0 || NSMinY(rect) > NSHeight([self bounds])) {
        return range;
    }
    
    BOOL foundOverlap = NO;
    
    for (NSInteger i = 0; i < PTStageColorCount; i++) {
        NSRect colorRect = NSMakeRect(1, BlockHeight * i, PTStageViewWidth - 2, BlockHeight - 2);
        
        if (NSIntersectsRect(rect, colorRect)) {
            if (foundOverlap) {
                range.length++;
            } else {
                foundOverlap = YES;
                
                range.location = i;
                range.length = 1;
            }
        }
    }
    
    return range;
}

- (NSRect)rectForHoldTime
{
    return [[self holdTextField] frame];
}

- (NSRect)rectForFadeTime
{
    return [[self fadeTextField] frame];
}

@end
