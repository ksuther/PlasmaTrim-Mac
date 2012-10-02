//
//  PTDocument.h
//  PlasmaTrim
//
//  Created by Kent Sutherland on 9/28/12.
//  Copyright (c) 2012 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTSequence, PTSequenceView;

@interface PTDocument : NSDocument

@property(nonatomic, weak) IBOutlet PTSequenceView *sequenceView;
@property(nonatomic, weak) IBOutlet NSColorWell *colorWell;

@property(nonatomic, strong, readonly) PTSequence *sequence;

- (IBAction)colorChanged:(id)sender;

@end
