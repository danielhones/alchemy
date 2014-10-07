//
//  PreferencesController.h
//  EarTraining
//
//  Created by Daniel Hones on 3/10/14.
//  Copyright (c) 2014 Daniel Hones. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController

@property (weak) IBOutlet NSButton *majorDo;
@property (weak) IBOutlet NSButton *majorRa;
@property (weak) IBOutlet NSButton *majorRe;
@property (weak) IBOutlet NSButton *majorMe;
@property (weak) IBOutlet NSButton *majorMi;
@property (weak) IBOutlet NSButton *majorFa;
@property (weak) IBOutlet NSButton *majorSe;
@property (weak) IBOutlet NSButton *majorSol;
@property (weak) IBOutlet NSButton *majorLe;
@property (weak) IBOutlet NSButton *majorLa;
@property (weak) IBOutlet NSButton *majorTe;
@property (weak) IBOutlet NSButton *majorTi;
@property (weak) IBOutlet NSButton *minorDo;
@property (weak) IBOutlet NSButton *minorRa;
@property (weak) IBOutlet NSButton *minorRe;
@property (weak) IBOutlet NSButton *minorMe;
@property (weak) IBOutlet NSButton *minorMi;
@property (weak) IBOutlet NSButton *minorFa;
@property (weak) IBOutlet NSButton *minorSe;
@property (weak) IBOutlet NSButton *minorSol;
@property (weak) IBOutlet NSButton *minorLe;
@property (weak) IBOutlet NSButton *minorLa;
@property (weak) IBOutlet NSButton *minorTe;
@property (weak) IBOutlet NSButton *minorTi;
@property (weak) IBOutlet NSMatrix *octaveRangeRadio;
@property (weak) IBOutlet NSTextField *savedLabel;
@property (weak) IBOutlet NSButton *cancelButton;

// IBAction so I can hide the saved label.  Probably there's a better way:
- (IBAction)buttonClick:(id)sender;


- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (void)loadPreferences;



@end
