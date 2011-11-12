#import <Cocoa/Cocoa.h>
#import "PathChoiceController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *sourceDirectoryField;
@property (assign) IBOutlet NSTextField *targetFileField;
@property (assign) IBOutlet NSButton *startProcessingButton;

@property (assign) BOOL processingButtonEnabled;

- (IBAction)chooseSourceDir:(NSButton *)sender;
- (IBAction)chooseTargetFile:(NSButton *)sender;
- (IBAction)startProcessing:(NSButton *)sender;

- (void)determineProcessingButtonState;
@end
