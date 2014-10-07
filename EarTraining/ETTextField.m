//
//  ETTextField.m
//  EarTraining
//
//  Created by Daniel Hones on 3/9/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import "ETTextField.h"

#define kSolfege TRUE
#define kScaleDegrees FALSE

@implementation ETTextField {
    int currentGuessAsInt;
    BOOL noteNames;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"guess"]) {
        currentGuessAsInt = (int)[[change objectForKey:NSKeyValueChangeNewKey] longValue];
        [self updateString];
        NSColor *myTransparentBlue = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:0.5f];
        [self setBackgroundColor:myTransparentBlue];
    }
}

- (void)updateString {
    NSArray *solfegeArray = @[@"Do", @"Ra", @"Re", @"Me", @"Mi", @"Fa",
                              @"Se", @"Sol", @"Le", @"La", @"Te", @"Ti"];
    NSArray *scaleDegreeArray = @[@"1", @"\u266D2", @"2", @"\u266D3", @"3",
                                  @"4", @"\u266D5", @"5", @"\u266D6", @"6",
                                  @"\u266D7", @"7"];
    
    NSString *str;
    
    if (noteNames == kSolfege) {
        str = [solfegeArray objectAtIndex:currentGuessAsInt];
    } else {
        str = [scaleDegreeArray objectAtIndex:currentGuessAsInt];
    }
    [self setStringValue:str];
}

- (void)setNoteNames:(BOOL)newChoice {
    noteNames = newChoice;
    [self updateString];
}



@end
