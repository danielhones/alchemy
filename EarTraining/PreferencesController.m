//
//  PreferencesController.m
//  EarTraining
//
//  Created by Daniel Hones on 3/10/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import "PreferencesController.h"
#import "KeysAndNotes.h"

#define kSolfege TRUE
#define kScaleDegrees FALSE
#define kTwoOctaves TRUE
#define kOneOctave FALSE
#define ON 1
#define OFF 0

@interface PreferencesController () {
    NSArray *solfegeArray, *scaleDegreeArray, *majorNoteChoiceOutlets, *minorNoteChoiceOutlets;
    BOOL noteNames;
}

@end

@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        solfegeArray = @[@"Do", @"Ra", @"Re", @"Me", @"Mi", @"Fa",
                         @"Se", @"Sol", @"Le", @"La", @"Te", @"Ti"];
        scaleDegreeArray = @[@"1", @"\u266D2", @"2", @"\u266D3", @"3", @"4",
                             @"\u266D5", @"5", @"\u266D6", @"6", @"\u266D7", @"7"];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    majorNoteChoiceOutlets = @[_majorDo, _majorRa, _majorRe, _majorMe, _majorMi, _majorFa,
                               _majorSe, _majorSol, _majorLe, _majorLa, _majorTe, _majorTi];
    minorNoteChoiceOutlets = @[_minorDo, _minorRa, _minorRe, _minorMe, _minorMi, _minorFa,
                               _minorSe, _minorSol, _minorLe, _minorLa, _minorTe, _minorTi];
    
    [self loadPreferences];
}

- (void)showWindow:(id)sender {
    [super showWindow:self];
    
    [self loadPreferences];
}

- (void)loadPreferences {
    [_savedLabel setHidden:YES];
    [_cancelButton setTitle:@"Cancel"];
    noteNames = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NoteNameType"] boolValue];
    
    // Set the window according to the current preferences
    NSNumber *octaves =[[NSUserDefaults standardUserDefaults] objectForKey:@"OctaveRange"];
    if ([octaves boolValue] == kTwoOctaves) {
        [_octaveRangeRadio selectCellAtRow:0 column:1];
    } else {
        [_octaveRangeRadio selectCellAtRow:0 column:0];
    }
    
    if (noteNames == kSolfege) {
        for (int i = 0; i < 12; i++) {
            NSString *str = [solfegeArray objectAtIndex:i];
            [[majorNoteChoiceOutlets objectAtIndex:i] setTitle:str];
            [[minorNoteChoiceOutlets objectAtIndex:i] setTitle:str];
        }
    } else {
        for (int i = 0; i < 12; i++) {
            NSString *str = [scaleDegreeArray objectAtIndex:i];
            [[majorNoteChoiceOutlets objectAtIndex:i] setTitle:str];
            [[minorNoteChoiceOutlets objectAtIndex:i] setTitle:str];
        }
    }
    
    // Turn off all note buttons to start
    for (int i = 0; i < 12; i++) {
        [[majorNoteChoiceOutlets objectAtIndex:i] setState:OFF];
        [[minorNoteChoiceOutlets objectAtIndex:i] setState:OFF];
    }
    NSArray *majorNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MajorKeyAvailableNotes"];
    // Now turn on the appropriate buttons, major first:
    for (int i = 0; i < [majorNotes count]; i++) {
        int j = [[majorNotes objectAtIndex:i] intValue];
        [[majorNoteChoiceOutlets objectAtIndex:j] setState:ON];
    }
    // Then minor:
    NSArray *minorNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MinorKeyAvailableNotes"];
    for (int i = 0; i < [minorNotes count]; i++) {
        int j = [[minorNotes objectAtIndex:i] intValue];
        [[minorNoteChoiceOutlets objectAtIndex:j] setState:ON];
    }
}


- (IBAction)cancelButton:(id)sender {
    [self close];
}

- (IBAction)saveButton:(id)sender {
    // Save all the preferences
    // First, the available notes:
    NSMutableArray *majorNotes = [[NSMutableArray alloc] init];
    NSMutableArray *minorNotes = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i++) {
        if ([[majorNoteChoiceOutlets objectAtIndex:i] state] == ON) {
            [majorNotes addObject:[NSNumber numberWithInt:i]];
        }
        if ([[minorNoteChoiceOutlets objectAtIndex:i] state] == ON) {
            [minorNotes addObject:[NSNumber numberWithInt:i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:majorNotes forKey:@"MajorKeyAvailableNotes"];
    [[NSUserDefaults standardUserDefaults] setObject:minorNotes forKey:@"MinorKeyAvailableNotes"];
    
    // Now the octave range
    if ([_octaveRangeRadio selectedColumn] == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@kOneOctave forKey:@"OctaveRange"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@kTwoOctaves forKey:@"OctaveRange"];
    }
    
    [_savedLabel setHidden:NO];
    [_cancelButton setTitle:@"Close"];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    // Just hides the "Saved" if the user clicks in the window after saving
    [_savedLabel setHidden:YES];
    [_cancelButton setTitle:@"Cancel"];
}

- (IBAction)buttonClick:(id)sender {
    [_savedLabel setHidden:YES];
    [_cancelButton setTitle:@"Cancel"];
}

@end
