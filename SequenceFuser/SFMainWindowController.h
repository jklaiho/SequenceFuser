#import <Cocoa/Cocoa.h>
#import "SourceDirectoryController.h"
#import "TargetFileController.h"
#import "ProgressBarController.h"

@interface SFMainWindowController : NSWindowController
 
@property (nonatomic, assign) IBOutlet NSTextField *sourceDirectoryField;
@property (nonatomic, assign) IBOutlet NSTextField *targetFileField;
@property (nonatomic, assign) IBOutlet NSButton *startProcessingButton;

@property (retain) SourceDirectoryController *sourceDirectoryController;
@property (retain) TargetFileController *targetFileController;
@property (retain) ProgressBarController *progressBarController;

@property BOOL processingButtonEnabled;

- (IBAction)chooseSourceDir:(NSButton *)sender;
- (IBAction)chooseTargetFile:(NSButton *)sender;
- (IBAction)startProcessing:(NSButton *)sender;

@end
