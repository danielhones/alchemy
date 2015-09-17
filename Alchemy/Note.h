//
//  Note.h
//  Auxiliary ET Program
//
//  Created by Daniel Hones on 2/2/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject {
    int selectedNote;
    BOOL isPlaying;
}

@property int selectedNote;
@property BOOL isPlaying;

- (void)playNote;
- (void)stopPlaying;

@end
