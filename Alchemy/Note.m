//
//  Note.m
//  Auxiliary ET Program
//
//  Created by Daniel Hones on 2/2/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import "Note.h"
#import "KeysAndNotes.h"

//#define kNoteFilesDirectory @"/Users/daniel/Developer/ETAudioFiles/Notes/"

@interface Note ()
@property (nonatomic, retain) NSMutableArray *notesArray;
@end

@implementation Note

@synthesize selectedNote, isPlaying;

- (id)init {
    if (self = [super init]) {
        NSArray *noteFileNames = [[NSArray alloc] initWithObjects:
                                  @"C3.m4a", @"Db3.m4a", @"D3.m4a", @"Eb3.m4a",
                                  @"E3.m4a", @"F3.m4a", @"Gb3.m4a", @"G3.m4a",
                                  @"Ab3.m4a", @"A3.m4a", @"Bb3.m4a", @"B3.m4a",
                                  @"C4.m4a", @"Db4.m4a", @"D4.m4a", @"Eb4.m4a",
                                  @"E4.m4a", @"F4.m4a", @"Gb4.m4a", @"G4.m4a",
                                  @"Ab4.m4a", @"A4.m4a", @"Bb4.m4a", @"B4.m4a",
                                  @"C5.m4a", @"Db5.m4a", @"D5.m4a", @"Eb5.m4a",
                                  @"E5.m4a", @"F5.m4a", @"Gb5.m4a", @"G5.m4a",
                                  @"Ab5.m4a", @"A5.m4a", @"Bb5.m4a", nil];
                                  
        self.notesArray = [NSMutableArray arrayWithCapacity:35];
        NSString *noteFilesDirectory = [[NSString alloc] initWithFormat:@"%@/%@%@", [[NSBundle mainBundle] resourcePath], @"Sound Files/", @"Notes/" ];
        
        // Sets up array of NSSound for each note
        for (int i = 0; i < 35; i++) {
            NSString *fileName = [noteFileNames objectAtIndex:i];
            NSString *noteFilePath = [[NSString alloc] initWithFormat:@"%@%@", noteFilesDirectory, fileName];
            
            NSSound *noteSound = [[NSSound alloc] initWithContentsOfFile:noteFilePath byReference:NO];
            [noteSound setVolume:0.70];
            [_notesArray addObject:noteSound];
            [self setSelectedNote:kC3];
            isPlaying = false;
        }
    }
    return self;
}

- (void)playNote {
    if (!isPlaying) {
        [[_notesArray objectAtIndex:selectedNote] play];
        isPlaying = true;
        
        SEL donePlaying = NSSelectorFromString(@"setIsPlaying:");
        [self performSelector:donePlaying withObject:false afterDelay:2];
    }
}

- (void)stopPlaying {
    [(NSSound *)[_notesArray objectAtIndex:selectedNote] stop];
    isPlaying = false;
}


@end
