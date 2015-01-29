//
//  ETNoteButtonsView.m
//  EarTraining
//
//  Created by Daniel Hones on 3/2/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import "ETNoteButtonsView.h"

#define kSolfege true
#define kScaleDegrees false

#define kButtonBorderWidth 0.5
#define kLabelRectHeight 15.5

#define kBorderSize 4.0
#define kSeparatorSize 4.0



@implementation ETNoteButtonsView {
    NSMutableArray *buttonRectangles;
    NSArray *solfege, *scaleDegrees, *diatonicBOOLarray;
    NSColor *rectColor;
}

@synthesize currentSelectedNote;


- (BOOL)acceptsFirstResponder {
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        buttonRectangles = [[NSMutableArray alloc] init];
        noteNames = kSolfege;
        
        solfege = @[@"Do", @"Ra", @"Re", @"Me", @"Mi", @"Fa",
                    @"Se", @"Sol", @"Le", @"La", @"Te", @"Ti"];
        scaleDegrees = @[@"1", @"\u266D2", @"2", @"\u266D3", @"3",
                         @"4", @"\u266D5", @"5", @"\u266D6", @"6",
                         @"\u266D7", @"7"];
        diatonicBOOLarray = @[@true, @false, @true, @false, @true, @true,
                              @false, @true, @false, @true, @false, @true];
        
        // Set up array of all rectangles so they can act as buttons:
        float buttonWidth = _bounds.size.width - (2 * kBorderSize);
        float buttonHeight = (_bounds.size.height - (2 * kBorderSize) - (11 * kSeparatorSize)) / 12;
        float xOrigin = kBorderSize;
        float yOrigin;
        
        for (int i = 0; i < 12; i++) {
            yOrigin = kBorderSize + (buttonHeight * i) + (kSeparatorSize * i);
            NSRect newRect = { {xOrigin, yOrigin}, {buttonWidth, buttonHeight} };
            NSTrackingArea *trackArea = [[NSTrackingArea alloc] initWithRect:newRect
                                                                     options:(NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited)
                                                                       owner:self
                                                                    userInfo:nil];
            [buttonRectangles addObject:NSStringFromRect(newRect)];
            [self addTrackingArea:trackArea];
        }

        currentSelectedNote = 0;
        selectedRectangle = -1;
        hoveredRectangle = -1;
        hoverBlue = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:0.7f];
        rectColor = hoverBlue;
    }
    return self;
}

- (void)resetCursorRects {
    for (int i = 0; i < 12; i++) {
        NSRect rectToAdd = NSRectFromString([buttonRectangles objectAtIndex:i]);
        [self addCursorRect:rectToAdd cursor:[NSCursor pointingHandCursor]];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    // Needs revising:
    if (noteNames == kSolfege) {
        for (int i = 0; i < 12; i++) {
            NSString *str = [solfege objectAtIndex:i];
            [self drawButtonsAndLabels:str withIndex:i forDiatonic:[diatonicBOOLarray[i] boolValue]];
        }
    } else {
        for (int i = 0; i < 12; i++) {
            NSString *str = [scaleDegrees objectAtIndex:i];
            [self drawButtonsAndLabels:str withIndex:i forDiatonic:[diatonicBOOLarray[i] boolValue]];
        }
    }
    
    if (selectedRectangle >= 0) {
        NSRect r = NSRectFromString(buttonRectangles[selectedRectangle]);
        BOOL diatonic = [diatonicBOOLarray[selectedRectangle] boolValue];
        
        if (!diatonic) {
            if (noteNames == kSolfege) {
                [self drawButtonsAndLabels:solfege[selectedRectangle]
                                 withIndex:(int)selectedRectangle
                               forDiatonic:TRUE];
                
            } else {
                [self drawButtonsAndLabels:scaleDegrees[selectedRectangle]
                                 withIndex:(int)selectedRectangle
                               forDiatonic:TRUE];
            }
        }
        
        [self drawSelectedRect:r withColor:rectColor];
        
        if (!diatonic) {
            if (noteNames == kSolfege) {
                [self redrawString:solfege[selectedRectangle]
                         withIndex:(int)selectedRectangle
                          andColor:[NSColor whiteColor]];
            } else {
                [self redrawString:scaleDegrees[selectedRectangle]
                         withIndex:(int)selectedRectangle
                          andColor:[NSColor whiteColor]];
            }
        }
    }
    
    if (hoveredRectangle >= 0) {
        NSRect r = NSRectFromString(buttonRectangles[hoveredRectangle]);
        [self drawSelectedRect:r withColor:hoverBlue];
    }
}

- (void)setSelectedRectangle:(int)index withColor:(NSColor *)color {
    selectedRectangle = index;
    rectColor = color;
    [self setNeedsDisplay:YES];
}

- (void)changeSelectedColor:(NSColor *)color {
    rectColor = color;
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    NSRect tempRect;
    NSPoint mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL itemHit = NO;
    
    for (int i = 0; i < 12; i++) {
        tempRect = NSRectFromString([buttonRectangles objectAtIndex:i]);
        itemHit = NSPointInRect(mouseLocation, tempRect);
        if (itemHit) {
            hoveredRectangle = i;
            //rectColor = hoverBlue;
            [self setNeedsDisplay:YES];
            break;
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    hoveredRectangle = -1;
    [self setNeedsDisplay:YES];
}

- (void)drawSelectedRect:(NSRect)rect withColor:(NSColor *)color {
    [color set];
    NSRectFillUsingOperation(rect, NSCompositeSourceOver);
}

- (void)mouseDown:(NSEvent *)theEvent {
    // convert mouse-down location into view coordinates:
    NSPoint clickLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // Go through the rectangles, see if any were hit:
    NSRect tempRect;
    BOOL itemHit = NO;
    
    for (int i = 0; i < 12; i++) {
        tempRect = NSRectFromString([buttonRectangles objectAtIndex:i]);
        itemHit = NSPointInRect(clickLocation, tempRect);
        if (itemHit) {
            [self setCurrentSelectedNote:[NSNumber numberWithInt:i]];
            selectedRectangle = i;
            rectColor = hoverBlue;
            [self setNeedsDisplay:YES];
            break;
        }
    }
}

- (void)drawButtonsAndLabels:(NSString *)string withIndex:(int)i forDiatonic:(BOOL)diatonic {
    // Set up attributes for drawing the labels:
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSCenterTextAlignment];
    NSFont *labelFont = [NSFont fontWithName:@"Helvetica" size:14];
    NSMutableDictionary *attributes = [@{ NSFontAttributeName : labelFont,
                                          NSParagraphStyleAttributeName : style,
                                          NSForegroundColorAttributeName : [NSColor blackColor]} mutableCopy];
    
    NSRect strRect = NSRectFromString([buttonRectangles objectAtIndex:i]);
    
    // Draw the background rectangles to hold the strings:
    [self drawBGRectangle:strRect forDiatonic:diatonic];
    
    if (!diatonic) {
        [attributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    // Move the string down just a little in the rectangle
    // (Need to find a way to make it scale depending on window height and separator size
    strRect.origin.y -= 4;
    [string drawInRect:strRect withAttributes:attributes];
}

- (void)redrawString:(NSString *)str withIndex:(int)i andColor:(NSColor *)color {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSCenterTextAlignment];
    NSFont *labelFont = [NSFont fontWithName:@"Helvetica" size:14];
    NSDictionary *attributes = @{ NSFontAttributeName : labelFont,
                                  NSParagraphStyleAttributeName : style,
                                  NSForegroundColorAttributeName : color};
    
    NSRect strRect = NSRectFromString([buttonRectangles objectAtIndex:i]);
    strRect.origin.y -= 4;
    [str drawInRect:strRect withAttributes:attributes];
}

- (void)drawBGRectangle:(NSRect)rectToDraw forDiatonic:(BOOL)diatonic {
    NSRect bgRect = {rectToDraw.origin.x + kButtonBorderWidth, rectToDraw.origin.y + kButtonBorderWidth,
        rectToDraw.size.width - (kButtonBorderWidth * 2), rectToDraw.size.height - (kButtonBorderWidth * 2)};
    
    if (diatonic) {
        // black border, white background
        [[NSColor blackColor] set];
        NSRectFill(rectToDraw);
        [[NSColor whiteColor] set];
        NSRectFill(bgRect);
    } else {
        // no border
        [[NSColor blackColor] set];
        NSRectFill(bgRect);
    }
}

- (void)setNoteNames:(BOOL)choice {
    noteNames = choice;
    [self setNeedsDisplay:YES];
}

@end