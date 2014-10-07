/*
 This class just has three instance variables: an integer 0-11 representing a guess and
 an NSString for the Solfege name and scale degree name
 */

#import "Guess.h"

@implementation Guess {
    NSArray *solfegeArray, *scaleDegreeArray;
}

- (id)init {
    if (self = [super init]) {
        solfegeArray = @[@"Do", @"Ra", @"Re", @"Me", @"Mi", @"Fa",
                                  @"Se", @"Sol", @"Le", @"La", @"Te", @"Ti"];
        scaleDegreeArray = [NSArray arrayWithObjects:
                            @"1", @"\u266D2", @"2", @"\u266D3", @"3",
                            @"4", @"\u266D5", @"5", @"\u266D6", @"6",
                            @"\u266D7", @"7", nil];
        guess = 0;
        solfegeName = [solfegeArray objectAtIndex:guess];
        scaleDegreeName = [scaleDegreeArray objectAtIndex:guess];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentSelectedNote"]) {
        [self setGuess:[[change objectForKey:NSKeyValueChangeNewKey] intValue]];
    }
}

- (void)setGuess:(int)newGuess {
    guess = newGuess;
    solfegeName = [solfegeArray objectAtIndex:guess];
    scaleDegreeName = [scaleDegreeArray objectAtIndex:guess];
}

- (int)guess {
    return guess;
}

- (NSString *)solfegeName {
    return solfegeName;
}

- (NSString *)scaleDegreeName {
    return scaleDegreeName;
}

@end
