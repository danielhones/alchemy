//
//  ETNoteChoiceView.m
//  EarTraining
//
//  Created by Daniel Hones on 3/10/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import "ETNoteChoiceView.h"

#define kBorderSize 0.5

@implementation ETNoteChoiceView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Draw black rectangle first that acts as border
    [[NSColor blackColor] set];
    NSRectFill([self bounds]);
    
    // Now draw a smaller white rectangle on top that acts as the background
    NSRect bgRect = {self.bounds.origin.x + kBorderSize, self.bounds.origin.y + kBorderSize,
                     self.bounds.size.width - (kBorderSize * 2), self.bounds.size.height - (kBorderSize * 2)};
    [[NSColor whiteColor] set];
    NSRectFill(bgRect);
}


@end
