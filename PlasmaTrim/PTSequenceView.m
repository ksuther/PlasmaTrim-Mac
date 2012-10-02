//
//  PTSequenceView.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTSequenceView.h"
#import "PTSequence.h"
#import "PTStageView.h"

@interface PTSequenceView () {
    PTStageView *_stageViews[PTSequenceMaxStageCount];
}
@end

@implementation PTSequenceView

- (void)_commonInit
{
    for (NSUInteger i = 0; i < PTSequenceMaxStageCount; i++) {
        _stageViews[i] = [[PTStageView alloc] initWithFrame:NSMakeRect(PTStageViewWidth * i, 0, PTStageViewWidth, NSHeight([self bounds]))];
        
        [self addSubview:_stageViews[i]];
    }
}

- (id)initWithFrame:(NSRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        [self _commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( (self = [super initWithCoder:aDecoder]) ) {
        [self _commonInit];
    }
    return self;
}

- (void)setSequence:(PTSequence *)sequence
{
    if (_sequence != sequence) {
        _sequence = sequence;
        
        for (NSUInteger i = 0; i < PTSequenceMaxStageCount; i++) {
            [_stageViews[i] setStage:[sequence stageAtIndex:i]];
        }
    }
}

@end
