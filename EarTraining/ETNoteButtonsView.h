//
//  ETNoteButtonsView.h
//  EarTraining
//
//  Created by Daniel Hones on 3/2/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ETNoteButtonsView : NSView {
    BOOL noteNames;
    long selectedRectangle, hoveredRectangle;
    NSNumber *currentSelectedNote;
    NSColor *hoverBlue;
}

// For Cocoa binding:
@property (nonatomic) NSNumber *currentSelectedNote;

- (void)setNoteNames:(BOOL)choice;
- (void)drawBGRectangle:(NSRect)rectToDraw forDiatonic:(BOOL)diatonic;
- (void)drawButtonsAndLabels:(NSString *)string withIndex:(int)i forDiatonic:(BOOL)diatonic;
- (void)drawSelectedRect:(NSRect)rect withColor:(NSColor *)color;
- (void)redrawString:(NSString *)str withIndex:(int)i andColor:(NSColor *)color;
- (void)setSelectedRectangle:(int)index withColor:(NSColor *)color;
- (void)changeSelectedColor:(NSColor *)color;
//- (void)setCurrentSelectedNote:(NSNumber *)newNote;

@end
