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
    CGFloat yOrigin = 0;
    
    for (NSInteger i = 0; i < PTStageColorCount; i++) {
        [[[self stage] colorAtIndex:i] set];
        NSRectFill(NSMakeRect(1, yOrigin, PTStageViewWidth - 2, BlockHeight - 2));
        
        yOrigin += BlockHeight;
    }
}

- (void)setStage:(PTStage *)stage
{
    if (_stage != stage) {
        _stage = stage;
        
        NSString *holdString = [NSString stringWithFormat:@"%c", (char)[[self stage] holdTime]];
        NSString *fadeString = [NSString stringWithFormat:@"%c", (char)[[self stage] fadeTime]];
        
        [[self holdTextField] setStringValue:holdString];
        [[self fadeTextField] setStringValue:fadeString];
        
        [self setNeedsDisplay:YES];
    }
}

@end
