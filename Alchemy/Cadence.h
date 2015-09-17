//
//  Cadence.h
//  Auxiliary ET Program
//
//  Created by Daniel Hones on 2/2/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cadence : NSObject {
    int key;
    BOOL tonality, isPlaying;
}

@property int key;
@property BOOL tonality, isPlaying;

- (void)setKey: (int)keyIndex;
- (void)playCadence;
- (void)stopPlaying;

@end
