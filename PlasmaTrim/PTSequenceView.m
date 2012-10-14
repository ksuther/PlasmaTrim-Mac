//
//  PTSequenceView.m
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import "PTSequenceView.h"
#import "PTSequence.h"
#import "PTStage.h"
#import "PTStageView.h"

@interface PTSequenceView () {
    PTStageView *_stageViews[PTSequenceMaxStageCount];
    
    BOOL _didControlClick;
    
    BOOL _dragging;
    NSPoint _mouseDownPoint;
    NSPoint _mouseDraggedPoint;
}
- (NSRect)_draggedRect;
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
        
        [self reloadData];
    }
}

- (void)drawRect:(NSRect)rect
{
    if (_dragging) {
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.6] set];
        NSRectFillUsingOperation([self _draggedRect], NSCompositeSourceOver);
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    _mouseDownPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    _didControlClick = NO;
    
    if (([theEvent modifierFlags] & NSControlKeyMask) != 0) {
        _didControlClick = YES;
        
        //Figure out what stage was clicked on
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        NSRect checkRect = NSMakeRect(point.x, point.y, 1, 1);
        
        for (NSUInteger i = 0; i < PTSequenceMaxStageCount; i++) {
            PTStageView *stageView = [self stageViewAtIndex:i];
            NSRect stageRect = [self convertRect:checkRect toView:stageView];
            NSRange colorRange = [stageView colorRangeForRect:stageRect];
            
            if (colorRange.length > 0) {
                if ([[self delegate] respondsToSelector:@selector(sequenceView:willTakeColorAtIndex:inStageAtIndex:)]) {
                    [[self delegate] sequenceView:self willTakeColorAtIndex:colorRange.location inStageAtIndex:i];
                }
                
                break;
            }
        }
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (!_didControlClick) {
        _dragging = YES;
        _mouseDraggedPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (!_didControlClick) {
        NSRect checkRect;
        
        if (_dragging) {
            checkRect = [self _draggedRect];
        } else {
            NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
            
            checkRect = NSMakeRect(point.x, point.y, 1, 1);
        }
        
        for (NSUInteger i = 0; i < PTSequenceMaxStageCount; i++) {
            PTStageView *stageView = [self stageViewAtIndex:i];
            NSRect stageRect = [self convertRect:checkRect toView:stageView];
            NSRange colorRange = [stageView colorRangeForRect:stageRect];
            
            if (colorRange.length > 0) {
                [[self delegate] sequenceView:self didSelectColorRange:colorRange inStageAtIndex:i];
            }
            
            if (NSIntersectsRect(stageRect, [stageView rectForHoldTime])) {
                [[self delegate] sequenceView:self didSelectHoldTimeInStageAtIndex:i];
            }
            
            if (NSIntersectsRect(stageRect, [stageView rectForFadeTime])) {
                [[self delegate] sequenceView:self didSelectFadeTimeInStageAtIndex:i];
            }
        }
        
        _dragging = NO;
        
        [self setNeedsDisplay:YES];
    }
    
    _didControlClick = NO;
}

- (void)reloadData
{
    for (NSUInteger i = 0; i < PTSequenceMaxStageCount; i++) {
        [_stageViews[i] setActive:i < [[self sequence] lastSlotIndex]];
        [_stageViews[i] setStage:[[self sequence] stageAtIndex:i]];
        
        [_stageViews[i] reloadData];
    }
}

- (PTStageView *)stageViewAtIndex:(NSUInteger)index
{
    NSAssert1(index >= 0 && index < PTSequenceMaxStageCount, @"index out of required range", index);
    
    return _stageViews[index];
}

#pragma mark - Private

- (NSRect)_draggedRect
{
    NSRect draggedRect = NSMakeRect(_mouseDownPoint.x, _mouseDownPoint.y, _mouseDraggedPoint.x - _mouseDownPoint.x, _mouseDraggedPoint.y - _mouseDownPoint.y);
    
    if (NSWidth(draggedRect) < 0) {
        draggedRect.origin.x += NSWidth(draggedRect);
        draggedRect.size.width *= -1;
    }
    
    if (NSHeight(draggedRect) < 0) {
        draggedRect.origin.y += NSHeight(draggedRect);
        draggedRect.size.height *= -1;
    }
    
    return NSIntegralRect(draggedRect);
}

@end
