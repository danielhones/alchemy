//
//  Cadence.m
//  Auxiliary ET Program
//
//  Created by Daniel Hones on 2/2/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import "Cadence.h"
#import "KeysAndNotes.h"

//#define kCadenceFilesDirectory @"/Users/daniel/Developer/ETAudioFiles/Cadences/"


@interface Cadence ()

@property (nonatomic, retain) NSMutableArray *majorCadenceArray;
@property (nonatomic, retain) NSMutableArray *minorCadenceArray;

@end

@implementation Cadence

@synthesize key, tonality, isPlaying;

- (id)init {
    if (self = [super init]) {
        NSArray *majorCadenceFileNames = [[NSArray alloc] initWithObjects:
                                          @"Cmajor.m4a", @"Dbmajor.m4a", @"Dmajor.m4a", @"Ebmajor.m4a",
                                          @"Emajor.m4a", @"Fmajor.m4a", @"Gbmajor.m4a", @"Gmajor.m4a",
                                          @"Abmajor.m4a", @"Amajor.m4a", @"Bbmajor.m4a", @"Bmajor.m4a", nil];
        NSArray *minorCadenceFileNames = [[NSArray alloc] initWithObjects:
                                          @"Cminor.m4a", @"C#minor.m4a", @"Dminor.m4a", @"Ebminor.m4a",
                                          @"Eminor.m4a", @"Fminor.m4a", @"F#minor.m4a", @"Gminor.m4a",
                                          @"G#minor.m4a", @"Aminor.m4a", @"Bbminor.m4a", @"Bminor.m4a", nil];
        self.majorCadenceArray = [NSMutableArray arrayWithCapacity:12];
        self.minorCadenceArray = [NSMutableArray arrayWithCapacity:12];
        NSString *cadenceFilesDirectory = [[NSString alloc] initWithFormat:@"%@/%@%@", [[NSBundle mainBundle] resourcePath], @"Sound Files/", @"Cadences/" ];
        
        // For the following block of code to work, ALL the sound files need to exist at the proper path
        // or else the NSSound instance gets set to nil and NSMutableArray throws an error:
        for (int i = 0; i < 12; i++) {
            NSString *majorFileName = [majorCadenceFileNames objectAtIndex:i];
            NSString *minorFileName = [minorCadenceFileNames objectAtIndex:i];
            NSString *majorFilePath = [[NSString alloc] initWithFormat:@"%@%@", cadenceFilesDirectory, majorFileName];
            NSString *minorFilePath = [[NSString alloc] initWithFormat:@"%@%@", cadenceFilesDirectory, minorFileName];
            
            /*
            NSString *majorFilePath = [[NSString alloc] initWithFormat:@"%@%@",
                                  kCadenceFilesDirectory,
                                  [majorCadenceFileNames objectAtIndex:i]];
            NSString *minorFilePath = [[NSString alloc] initWithFormat:@"%@%@",
                                       kCadenceFilesDirectory,
                                       [minorCadenceFileNames objectAtIndex:i]];
             */

            NSSound *majorCadence = [[NSSound alloc] initWithContentsOfFile:majorFilePath byReference:NO];
            NSSound *minorCadence = [[NSSound alloc] initWithContentsOfFile:minorFilePath byReference:NO];

            [_majorCadenceArray addObject:majorCadence];
            [_minorCadenceArray addObject:minorCadence];
        }
        
        [self setTonality:kMajor];
        [self setKey:KEY_OF_C];
        isPlaying = false;
    }
    return self;
}

- (void)playCadence {
    if (!isPlaying) {
        if (tonality == kMajor) {
            [[_majorCadenceArray objectAtIndex:key] isPlaying];
            isPlaying = [[_majorCadenceArray objectAtIndex:key] play];
        } else {
            isPlaying = [[_minorCadenceArray objectAtIndex:key] play];
        }
    }
    
    SEL donePlaying = NSSelectorFromString(@"setIsPlaying:");
    [self performSelector:donePlaying withObject:false afterDelay:4.2];
}

- (void)stopPlaying {
    if (tonality == kMajor) {
        [(NSSound *)[_majorCadenceArray objectAtIndex:key] stop];
    } else {
        [(NSSound *)[_minorCadenceArray objectAtIndex:key] stop];
    }
    
    isPlaying = false;
}


@end
