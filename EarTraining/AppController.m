/*
 Remember to set it up so that closing the main window quits the program.
 And change the Note and Cadence classes so they point to where the sound files will be
 within the application package.
 */

#import "AppController.h"
#import "ETTextField.h"

#define kSolfege TRUE
#define kScaleDegrees FALSE
#define kTwoOctaves TRUE
#define kOneOctave FALSE
#define kWindowHeight 430.0
#define kWindowIncrementWidth 88
#define kInitialWindowWidth 175.0


@implementation AppController {
    BOOL playCadenceThisTime;
    int totalQuestions, numberRight, numberOfTimesChecked;
    float score;
    NSColor *myGreen, *myRed, *myYellow, *myOrange, *myTransparentBlue, *hoverBlue;
}

@synthesize solfegeOrScaleDegrees, numberOfNotes, randomKey;
@synthesize currentNotes, currentNoteGuesses;


+ (void)initialize {
    // Register NSUserDefaults
    NSArray *defaultAvailableNotes = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11];
    NSDictionary *preferenceDefaults = @{@"NumberOfNotes" : @1,
                                         @"NoteNameType" : @kSolfege,
                                         @"KeyPreference" : @KEY_OF_C,
                                         @"OctaveRange" : @kTwoOctaves,
                                         @"MajorKeyAvailableNotes" : defaultAvailableNotes,
                                         @"MinorKeyAvailableNotes" : defaultAvailableNotes,
                                         @"Tonality" : @kMajor,
                                         @"RandomKey" : @FALSE,
                                         @"CadenceEveryTime" : @TRUE,
                                         @"MainWindowPositionX" : @618,
                                         @"MainWindowPositionY" : @434,
                                         @"OptionsPanelPositionX" : @393,
                                         @"OptionsPanelPositionY" : @537};
    [[NSUserDefaults standardUserDefaults] registerDefaults:preferenceDefaults];
}

- (void)awakeFromNib {
    // Set up arrays of main window IBOutlets
    noteButtonsViewOutlets = @[_buttonsView1, _buttonsView2, _buttonsView3, _buttonsView4,
                               _buttonsView5, _buttonsView6, _buttonsView7, _buttonsView8];
    textFieldOutlets = @[_textField1, _textField2, _textField3, _textField4,
                         _textField5, _textField6, _textField7, _textField8];
    
    // Set up RGB colors for the text field backgrounds:
    myRed = [NSColor colorWithCalibratedRed:0.9 green:0.0 blue:0 alpha:0.7f];
    myGreen = [NSColor colorWithCalibratedRed:0.0 green:0.74 blue:0.22 alpha:0.6f];
    //myYellow = [NSColor colorWithCalibratedRed:0.969 green:0.929 blue:0.231 alpha:0.7f];
    myOrange = [NSColor colorWithCalibratedRed:1.0 green:0.62 blue:0.0 alpha:0.8f];
    myTransparentBlue = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:0.5f];
    hoverBlue = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:0.7f];
    
    
    // Initialize instance variables
    currentNoteGuesses = [NSMutableArray arrayWithCapacity:8];
    currentNotes = [NSMutableArray arrayWithCapacity:8];
    currentCadence = [[Cadence alloc] init];
    // This array is for transposing:
    for (int i = 0; i < 24; i++) {
        keyOfC[i] = i;
    }
    // This array is just used for debugging:
    solfegeArray = @[@"Do", @"Ra", @"Re", @"Me", @"Mi", @"Fa",
                     @"Se", @"Sol", @"Le", @"La", @"Te", @"Ti"];
    
    /* Load preferences and resume last setup */
    
    // Number of notes:
    numberOfNotes = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NumberOfNotes"] intValue];
    [_numberOfNotesStepper setDoubleValue:numberOfNotes];
    [_numberOfNotesTextField setIntValue:numberOfNotes];
    [self setWindowForNumberOfNotes];
    
    // Note name type:
    solfegeOrScaleDegrees = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NoteNameType"] boolValue];
    if (solfegeOrScaleDegrees == kSolfege) {
        [_noteNameChoice selectCellAtRow:0 column:0];
    } else {
        [_noteNameChoice selectCellAtRow:1 column:0];
    }
    
    // Key:
    int storedKey = [[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyPreference"] intValue];
    [currentCadence setKey:storedKey];
    
    // Random key option:
    randomKey = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RandomKey"] boolValue];
    [_randomKeyCheckbox setState:randomKey];
    
    // Cadence every time:
    cadenceEveryTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CadenceEveryTime"] boolValue];
    [_cadenceEveryTimeCheckbox setState:cadenceEveryTime];

    // For sanity.  If the key is random every time, we should play the cadence every time:
    if (randomKey) {
        cadenceEveryTime = TRUE;
        [_cadenceEveryTimeCheckbox setState:TRUE];
    }
    
    // Octave range:
    octaveRange = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OctaveRange"] boolValue];
    
    // Tonality:
    tonality = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Tonality"] boolValue];
    if (tonality == kMajor) {
        [_tonalityChoice selectCellAtRow:0 column:0];
    } else {
        [_tonalityChoice selectCellAtRow:0 column:1];
    }
    
    // Array of available notes:
    if (tonality == kMajor) {
        availableNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MajorKeyAvailableNotes"];
    } else {
        availableNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MinorKeyAvailableNotes"];
    }
    
    // Set up main window location
    CGFloat x = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MainWindowPositionX"] floatValue];
    CGFloat y = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MainWindowPositionY"] floatValue];
    NSPoint windowOrigin = {x, y};
    [_mainWindow setFrameOrigin: windowOrigin];
    // and options panel location
    windowOrigin.x = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OptionsPanelPositionX"] floatValue];
    windowOrigin.y = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OptionsPanelPositionY"] floatValue];
    [_optionsPanel setFrameOrigin: windowOrigin];
    
    // Register for notification of changes to the preferences
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePreferences)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    // Work with the other arrays:
    for (int i = 0; i < 8; i++) {
        Guess *newGuess = [[Guess alloc] init];
        Note *newNote = [[Note alloc] init];
        [currentNoteGuesses addObject:newGuess];
        [currentNotes addObject:newNote];
        
        // Set up the guesses and sliders to observe the TickView currentSelectedNote
        [[noteButtonsViewOutlets objectAtIndex:i] addObserver:[currentNoteGuesses objectAtIndex:i]
                                                   forKeyPath:@"currentSelectedNote"
                                                      options:NSKeyValueObservingOptionNew
                                                      context:NULL];
        /*
        [[noteButtonsViewOutlets objectAtIndex:i] addObserver:[noteSelectionSliderOutlets objectAtIndex:i]
                                                   forKeyPath:@"currentSelectedNote"
                                                      options:NSKeyValueObservingOptionNew
                                                      context:NULL];*/
        
        // Set up the text fields as observers for each guess and when user clicks a new button
        [[currentNoteGuesses objectAtIndex:i] addObserver:[textFieldOutlets objectAtIndex:i]
                                               forKeyPath:@"guess"
                                                  options:NSKeyValueObservingOptionNew
                                                  context:NULL];
        
        // Set up the rest of window
        [[textFieldOutlets objectAtIndex:i] setNoteNames:solfegeOrScaleDegrees];
        [[textFieldOutlets objectAtIndex:i] setDrawsBackground:YES];
        [[textFieldOutlets objectAtIndex:i] setBackgroundColor:myTransparentBlue];
        [[textFieldOutlets objectAtIndex:i] setFont:[NSFont boldSystemFontOfSize:12]];
        [[textFieldOutlets objectAtIndex:i] setTextColor:[NSColor whiteColor]];
        
        [[noteButtonsViewOutlets objectAtIndex:i] setNoteNames:solfegeOrScaleDegrees];
        
        //[[noteSelectionSliderOutlets objectAtIndex:i] setTickMarkPosition:NSTickMarkLeft];
        //[[noteSelectionSliderOutlets objectAtIndex:i] setDoubleValue:0];
    }
    
    // Set up the key pop up menu in the options panel:
    [currentCadence setTonality:tonality];
    [self setKeyMenu:tonality];
    [_keyPopUpMenu selectItemAtIndex:[currentCadence key]];
    
    // So the options panel doesn't float over everything:
    [_optionsPanel setCanHide:TRUE];
    
    // Set the other buttons disabled to start with:
    [_repeatQuestionButton setEnabled:NO];
    [_repeatNotesButton setEnabled:NO];
    [_skipQuestionButton setEnabled:NO];
    [_checkAnswerButton setEnabled:NO];
    
    // Initialize the score and score labels:
    totalQuestions = 1;  // Starts as 1 because it is immediately decremented when 'Start' is pressed
    numberRight = 0;
    score = 0;
    [_totalQuestionsLabel setStringValue:@""];
    [_numberRightLabel setStringValue:@""];
    [_scoreLabel setStringValue:@""];
    
    // So the NoteButtonViews can get mouse events:
    [_mainWindow setAcceptsMouseMovedEvents:true];
    
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    NSNumber *x = [NSNumber numberWithDouble:[_mainWindow frame].origin.x];
    NSNumber *y = [NSNumber numberWithDouble:[_mainWindow frame].origin.y];
    [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"MainWindowPositionX"];
    [[NSUserDefaults standardUserDefaults] setObject:y forKey:@"MainWindowPositionY"];
    x = [NSNumber numberWithDouble:[_optionsPanel frame].origin.x];
    y = [NSNumber numberWithDouble:[_optionsPanel frame].origin.y];
    [[NSUserDefaults standardUserDefaults] setObject:x forKey:@"OptionsPanelPositionX"];
    [[NSUserDefaults standardUserDefaults] setObject:y forKey:@"OptionsPanelPositionY"];
    
}

- (IBAction)startButtonClick:(id)sender {
    [_startButton setEnabled:NO];
    [_startButton setHidden:YES];
    [_repeatQuestionButton setEnabled:YES];
    [_repeatNotesButton setEnabled:YES];
    [_skipQuestionButton setEnabled:YES];
    [_checkAnswerButton setEnabled:YES];
    playCadenceThisTime = TRUE;
    
    // Decrements so that the score stays right when the start button is shown again.
    totalQuestions--;
    
    [self playNewRandomNotes];
}

- (void)showStartButtonAndDisableOthers {
    [self stopNotes];
    [self setTextFieldsColor:myTransparentBlue];
    [_repeatQuestionButton setEnabled:NO];
    [_repeatNotesButton setEnabled:NO];
    [_skipQuestionButton setEnabled:NO];
    [_checkAnswerButton setEnabled:NO];
    [_startButton setHidden:NO];
    [_startButton setEnabled:YES];
}

- (void)playNewRandomNotes {
    // This is just a sanity check here, there shouldn't be any notes playing at this point:
    [self stopNotes];
    
    totalQuestions++;
    numberOfTimesChecked = 0;
    
    if (randomKey) {
        int randomNumber = arc4random_uniform(12);
        [currentCadence setKey:randomNumber];
        [_keyPopUpMenu selectItemAtIndex:randomNumber];
    }
    
    // This array prevents duplicating notes, they are removed when chosen
    NSMutableArray *workingNotesArray = [NSMutableArray arrayWithArray:availableNotes];
    
    for (int i = 0; i < numberOfNotes; i++) {
        int randomNumber = arc4random_uniform((int)[workingNotesArray count]);
        int noteCode = [[workingNotesArray objectAtIndex:randomNumber] intValue];
        
        int noteNumber = [self noteNumberForCode:noteCode andKey:[currentCadence key]];
        // Makes the higher octave the default octave (for one octave range)
        noteNumber += 12;

        if (octaveRange == kTwoOctaves) {
            int octaveMultiplier = arc4random_uniform(2);
            noteNumber = noteNumber - (12 * octaveMultiplier);
        }
        
        [[currentNotes objectAtIndex:i] setSelectedNote:noteNumber];
        [workingNotesArray removeObjectAtIndex:randomNumber];
    }
    
    if (cadenceEveryTime || playCadenceThisTime) {
        [currentCadence playCadence];
        SEL play = NSSelectorFromString(@"playNotes");
        [self performSelector:play withObject:nil afterDelay:4.2];
    } else {
        [self playNotes];
    }
    
    if (!cadenceEveryTime) {
        playCadenceThisTime = false;
    }
    
    // Change text fields back to blue
    SEL changeColor = NSSelectorFromString(@"setTextFieldsColor:");
    [self performSelector:changeColor withObject:myTransparentBlue afterDelay:3.0];
}

- (void)playNotes {
    for (int i = 0; i < numberOfNotes; i++) {
        [[currentNotes objectAtIndex:i] playNote];
    }
}

- (void)stopNotes {
    for (int i = 0; i < numberOfNotes; i++) {
        [[currentNotes objectAtIndex:i] stopPlaying];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [currentCadence stopPlaying];
}

- (BOOL)checkAnswer {
    if ([currentCadence isPlaying]) {
        return false;
    }
    
    [self stopNotes];
    
    BOOL results[numberOfNotes];
    BOOL result = TRUE;
    // Set up this array to hold the current notes so we can remove them when we find a right answer:
    NSMutableArray *tempNotesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numberOfNotes; i++) {
        [tempNotesArray addObject:[currentNotes objectAtIndex:i]];
    }
    
    for (int i = 0; i < numberOfNotes; i++) {
        results[i] = false;
        int guess = [[currentNoteGuesses objectAtIndex:i] guess];
        
        for (int j = 0; j < [tempNotesArray count]; j++) {
            int note = [[tempNotesArray objectAtIndex:j] selectedNote];
            int code = [self codeForNoteNumber:note andKey:[currentCadence key]];
            if (guess == code) {
                results[i] = true;
                [tempNotesArray removeObjectAtIndex:j];
                break;
            }
        }
        
        if (results[i]) {
            // Answers were right
            [[textFieldOutlets objectAtIndex:i] setBackgroundColor:myGreen];
            [[noteButtonsViewOutlets objectAtIndex:i] changeSelectedColor:myGreen];
        } else {
            // Answers were wrong
            [[textFieldOutlets objectAtIndex:i] setBackgroundColor:myRed];
            [[noteButtonsViewOutlets objectAtIndex:i] changeSelectedColor:myRed];
        }
        
        result = result && results[i];
    }

    if (result && (numberOfTimesChecked == 0)) {
        numberRight++;
        for (int i = 0; i < numberOfNotes; i++) {
            // Change colors back if all the answers were right
            SEL changeButtonColor = NSSelectorFromString(@"changeSelectedColor:");
            [[noteButtonsViewOutlets objectAtIndex:i] performSelector:changeButtonColor
                                                           withObject:hoverBlue
                                                           afterDelay:3.0];
        }
    }

    score = 100 * ((float)numberRight / (float)totalQuestions);
    NSString *str = [NSString stringWithFormat:@"%3.0f%%", score];
    [_scoreLabel setStringValue:str];
    [_totalQuestionsLabel setIntValue:totalQuestions];
    [_numberRightLabel setIntValue:numberRight];

    numberOfTimesChecked++;
    return result;
}

- (void)checkAnswerAndContinueIfRight {
    if ([self checkAnswer]) {
        [self playNewRandomNotes];
    }
}

- (IBAction)checkAnswerClick:(id)sender {
    [self checkAnswerAndContinueIfRight];
}

- (IBAction)skipQuestionClick:(id)sender {
    if ([currentCadence isPlaying]) {
        return;
    }
    [self stopNotes];
    [self showRightAnswer];
    [self playNewRandomNotes];
}

- (void)showRightAnswer {
    for (int i = 0; i < numberOfNotes; i++) {
        int note = [[currentNotes objectAtIndex:i] selectedNote];
        int code = [self codeForNoteNumber:note andKey:[currentCadence key]];
        //[[noteSelectionSliderOutlets objectAtIndex:i] setDoubleValue:code];
        [[noteButtonsViewOutlets objectAtIndex:i] setSelectedRectangle:code withColor:myOrange];
        [[currentNoteGuesses objectAtIndex:i] setGuess:code];
        [[textFieldOutlets objectAtIndex:i] setBackgroundColor:myOrange];
        SEL changeButtonColor = NSSelectorFromString(@"changeSelectedColor:");
        [[noteButtonsViewOutlets objectAtIndex:i] performSelector:changeButtonColor withObject:hoverBlue afterDelay:3.0];
    }
    SEL changeColor = NSSelectorFromString(@"setTextFieldsColor:");
    [self performSelector:changeColor withObject:myTransparentBlue afterDelay:3.0];
    
}

- (IBAction)repeatQuestionClick:(id)sender {
    if (![currentCadence isPlaying] && ![[currentNotes objectAtIndex:0] isPlaying]) {
        // Sanity check:
        [self stopNotes];
        [currentCadence playCadence];
        SEL play = NSSelectorFromString(@"playNotes");
        [self performSelector:play withObject:nil afterDelay:4.1];
    }
}

- (IBAction)repeatNotesClick:(id)sender {
    if (![currentCadence isPlaying]) {
        // Sanity check:
        [self stopNotes];
        [self playNotes];
    }
}

- (int)noteNumberForCode:(int)code andKey:(int)key {
    int note = keyOfC[code] + key;
    return note;
}

- (int)codeForNoteNumber:(int)note andKey:(int)key {
    int code = (note - key) % 12;
    return code;
}

- (IBAction)numberOfNotesChange:(id)sender {
    if (numberOfNotes > [availableNotes count]) {
        numberOfNotes = (int)[availableNotes count];
        [_numberOfNotesTextField setIntValue:numberOfNotes];
        [_numberOfNotesStepper setIntValue:numberOfNotes];
    }
    [self setWindowForNumberOfNotes];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:numberOfNotes] forKey:@"NumberOfNotes"];
    [self showStartButtonAndDisableOthers];
}

- (void)setWindowForNumberOfNotes {
    NSSize newSize = {kInitialWindowWidth + kWindowIncrementWidth * numberOfNotes, kWindowHeight};
    [_mainWindow setContentSize:newSize];
}

- (IBAction)noteNameChange:(id)sender {
    if ([_noteNameChoice selectedRow] == 0) {
        solfegeOrScaleDegrees = kSolfege;
        [[NSUserDefaults standardUserDefaults] setObject:@kSolfege forKey:@"NoteNameType"];
    } else {
        solfegeOrScaleDegrees = kScaleDegrees;
        [[NSUserDefaults standardUserDefaults] setObject:@kScaleDegrees forKey:@"NoteNameType"];
    }
    for (int i = 0; i < 8; i++) {
        [[noteButtonsViewOutlets objectAtIndex:i] setNoteNames:solfegeOrScaleDegrees];
        [[textFieldOutlets objectAtIndex:i] setNoteNames:solfegeOrScaleDegrees];
    }
}

- (IBAction)keyMenuChange:(id)sender {
    // Turn off random key if the user manually selects a key
    randomKey = false;
    [_randomKeyCheckbox setState:0];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:randomKey] forKey:@"RandomKey"];
    
    int newKey = (int)[_keyPopUpMenu indexOfSelectedItem];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newKey] forKey:@"KeyPreference"];
    
    [currentCadence setKey:newKey];
    /*
    int oldKey = [currentCadence key];
    [currentCadence setKey:(int)[_keyPopUpMenu indexOfSelectedItem]];
    // Need to transpose the notes too:
    for (int i = 0; i < numberOfNotes; i++) {
        int note = [[currentNotes objectAtIndex:i] selectedNote];
        int code = [self codeForNoteNumber:note andKey:oldKey];
        note = [self noteNumberForCode:code andKey:[currentCadence key]];
        [[currentNotes objectAtIndex:i] setSelectedNote:note];
    } */
    [self showStartButtonAndDisableOthers];
}

- (IBAction)tonalityChange:(id)sender {
    if ([_tonalityChoice selectedColumn] == 0) {
        // Major is selected
        tonality = kMajor;
        [currentCadence stopPlaying];
        [currentCadence setTonality:kMajor];
        [[NSUserDefaults standardUserDefaults] setObject:@kMajor forKey:@"Tonality"];
        availableNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MajorKeyAvailableNotes"];
    } else {
        // Minor is selected
        tonality = kMinor;
        [currentCadence stopPlaying];
        [currentCadence setTonality:kMinor];
        [[NSUserDefaults standardUserDefaults] setObject:@kMinor forKey:@"Tonality"];
        availableNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MinorKeyAvailableNotes"];
    }
    
    [self setKeyMenu:[currentCadence tonality]];
    [self showStartButtonAndDisableOthers];
}

- (IBAction)randomKeyCheckboxChange:(id)sender {
    randomKey = [_randomKeyCheckbox state];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:randomKey] forKey:@"RandomKey"];
    if (randomKey) {
        [_cadenceEveryTimeCheckbox setState:TRUE];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cadenceEveryTime]
                                                  forKey:@"CadenceEveryTime"];
        // Only need to show start button if they changed TO playing random keys:
        [self showStartButtonAndDisableOthers];
    }
}

- (IBAction)cadenceEveryTimeClick:(id)sender {
    cadenceEveryTime = [_cadenceEveryTimeCheckbox state];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cadenceEveryTime]
                                              forKey:@"CadenceEveryTime"];
    if (!cadenceEveryTime) {
        playCadenceThisTime = false;
    }
}

- (IBAction)viewOptionsPanel:(id)sender {
    [_optionsPanel makeKeyAndOrderFront:self];
}

- (IBAction)openPreferences:(id)sender {
    if (!preferences) {
        preferences = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
    }
    [preferences showWindow:self];
}

- (void)setKeyMenu:(BOOL)choice {
    long currentChoice = [_keyPopUpMenu indexOfSelectedItem];
    NSArray *majorKeys = [NSArray arrayWithObjects:
                          @"C major", @"D\u266D major", @"D major",
                          @"E\u266D major", @"E major", @"F major",
                          @"G\u266D major", @"G major", @"A\u266D major",
                          @"A major", @"B\u266D major", @"B major", nil];
    NSArray *minorKeys = [NSArray arrayWithObjects:
                          @"C minor", @"C\u266F minor", @"D minor",
                          @"E\u266D minor", @"E minor", @"F minor",
                          @"F\u266F minor", @"G minor", @"G\u266F minor",
                          @"A minor", @"B\u266D minor", @"B minor", nil];
    
    if (choice == kMajor) {
        [_keyPopUpMenu removeAllItems];
        [_keyPopUpMenu addItemsWithTitles:majorKeys];
    } else {
        [_keyPopUpMenu removeAllItems];
        [_keyPopUpMenu addItemsWithTitles:minorKeys];
    }
    
    [_keyPopUpMenu selectItemAtIndex:currentChoice];
}

- (void)updatePreferences {
    if (tonality == kMajor) {
        availableNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MajorKeyAvailableNotes"];
    } else {
        availableNotes = [[NSUserDefaults standardUserDefaults] objectForKey:@"MinorKeyAvailableNotes"];
    }
    
    octaveRange = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OctaveRange"] boolValue];
    if ([availableNotes count] < numberOfNotes) {
        [self numberOfNotesChange:Nil];
    }
}

- (void)setTextFieldsColor:(NSColor *)color {
    for (int i = 0; i < 8; i++) {
        [[textFieldOutlets objectAtIndex:i] setBackgroundColor:color];
    }
}

@end
