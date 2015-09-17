//
//  Guess.h
//  EarTraining
//
//  Created by Daniel Hones on 3/9/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guess : NSObject {
    int guess;
    NSString *solfegeName;
    NSString *scaleDegreeName;
}

- (void)setGuess:(int)newGuess;
- (NSString *)solfegeName;
- (NSString *)scaleDegreeName;
- (int)guess;

@end
