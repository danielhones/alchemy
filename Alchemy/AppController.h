/*
 
 */

#import <Foundation/Foundation.h>
#import "ETNoteButtonsView.h"
#import "Note.h"
#import "Cadence.h"
#import "Guess.h"
#import "KeysAndNotes.h"
#import "PreferencesController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface AppController : NSObject <NSApplicationDelegate> {
    NSArray *solfegeArray;
    NSArray *noteButtonsViewOutlets, *textFieldOutlets;
    NSMutableArray *availableNotes;
    NSMutableArray *currentNotes, *currentNoteGuesses;
    Cadence *currentCadence;
    BOOL solfegeOrScaleDegrees, octaveRange, randomKey, cadenceEveryTime, tonality;
    int numberOfNotes;
    PreferencesController *preferences;
    int keyOfC[24];
}

// Properties for bindings
@property BOOL solfegeOrScaleDegrees, randomKey;
@property int numberOfNotes;
@property NSMutableArray *currentNotes, *currentNoteGuesses;


// Main window IBOutlet properties
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *repeatQuestionButton;
@property (weak) IBOutlet NSButton *repeatNotesButton;
@property (weak) IBOutlet NSButton *skipQuestionButton;
@property (weak) IBOutlet NSButton *checkAnswerButton;
@property (weak) IBOutlet NSStepper *numberOfNotesStepper;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView1;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView2;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView3;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView4;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView5;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView6;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView7;
@property (weak) IBOutlet ETNoteButtonsView *buttonsView8;
@property (weak) IBOutlet NSTextField *textField1;
@property (weak) IBOutlet NSTextField *textField2;
@property (weak) IBOutlet NSTextField *textField3;
@property (weak) IBOutlet NSTextField *textField4;
@property (weak) IBOutlet NSTextField *textField5;
@property (weak) IBOutlet NSTextField *textField6;
@property (weak) IBOutlet NSTextField *textField7;
@property (weak) IBOutlet NSTextField *textField8;
@property (unsafe_unretained) IBOutlet NSWindow *mainWindow;
@property (weak) IBOutlet NSTextField *totalQuestionsLabel;
@property (weak) IBOutlet NSTextField *numberRightLabel;
@property (weak) IBOutlet NSTextField *scoreLabel;


/*
 Main window IBActions
 */
- (IBAction)startButtonClick:(id)sender;
- (IBAction)repeatQuestionClick:(id)sender;
- (IBAction)repeatNotesClick:(id)sender;
- (IBAction)checkAnswerClick:(id)sender;
- (IBAction)skipQuestionClick:(id)sender;

/*
 Options panel IBOoutlet properties
 */
@property (weak) IBOutlet NSMatrix *tonalityChoice;
@property (weak) IBOutlet NSMatrix *noteNameChoice;
@property (weak) IBOutlet NSTextField *numberOfNotesTextField;
@property (weak) IBOutlet NSPopUpButton *keyPopUpMenu;
@property (unsafe_unretained) IBOutlet NSPanel *optionsPanel;
@property (weak) IBOutlet NSButton *randomKeyCheckbox;
@property (weak) IBOutlet NSButton *cadenceEveryTimeCheckbox;


/*
 Options panel IBActions
 */
- (IBAction)numberOfNotesChange:(id)sender;
- (IBAction)noteNameChange:(id)sender;
- (IBAction)keyMenuChange:(id)sender;
- (IBAction)tonalityChange:(id)sender;
- (IBAction)randomKeyCheckboxChange:(id)sender;
- (IBAction)cadenceEveryTimeClick:(id)sender;



/*
 Menu bar IBActions
 */
- (IBAction)viewOptionsPanel:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)viewHelp:(id)sender;


/*
 Other methods
 */
- (void)playNewRandomNotes;  // Might need a parameter?
- (void)playNotes;
- (void)setWindowForNumberOfNotes;
- (void)setKeyMenu:(BOOL)choice;
- (void)updatePreferences;
- (BOOL)checkAnswer;
- (void)checkAnswerAndContinueIfRight;
- (void)setTextFieldsColor:(NSColor *)color;
- (void)showRightAnswer;
- (void)showStartButtonAndDisableOthers;
- (void)stopNotes;
- (BOOL)isNetworkConnected;

// Key definition methods:
- (int)noteNumberForCode:(int)code andKey:(int)key;
- (int)codeForNoteNumber:(int)note andKey:(int)key;


@end
