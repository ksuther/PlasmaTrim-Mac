//
//  PTSequenceView.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum : NSInteger {
    PTStageViewSectionNone,
    PTStageViewSectionColor,
    PTStageViewSectionHoldTime,
    PTStageViewSectionFadeTime,
} PTStageViewSection;

@class PTSequence, PTStageView;
@protocol PTSequenceViewDelegate;

@interface PTSequenceView : NSView

@property(nonatomic, weak) IBOutlet id <PTSequenceViewDelegate> delegate;

@property(nonatomic, weak) PTSequence *sequence;

- (void)reloadData;

- (PTStageView *)stageViewAtIndex:(NSUInteger)index;

@end

@protocol PTSequenceViewDelegate <NSObject>
@required
- (void)sequenceView:(PTSequenceView *)sequenceView didSelectColorRange:(NSRange)colorRange inStageAtIndex:(NSUInteger)stageIndex;
- (void)sequenceView:(PTSequenceView *)sequenceView didSelectHoldTimeInStageAtIndex:(NSUInteger)stageIndex;
- (void)sequenceView:(PTSequenceView *)sequenceView didSelectFadeTimeInStageAtIndex:(NSUInteger)stageIndex;
@end
