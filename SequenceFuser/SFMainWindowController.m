#import "SFMainWindowController.h"

@interface SFMainWindowController (private)

- (void)determineProcessingButtonState;

@end


@implementation SFMainWindowController

@synthesize sourceDirectoryController = _sourceDirectoryController;
@synthesize sourceDirectoryField = _sourceDirectoryField;
@synthesize targetFileController = _targetFileController;
@synthesize targetFileField = _targetFileField;
@synthesize progressBarController = _progressBarController;
@synthesize startProcessingButton = _startProcessingButton;
@synthesize processingButtonEnabled = _processingButtonEnabled;


#pragma mark Utility methods

- (void)determineProcessingButtonState {
    // Since the text fields are not editable and will only ever contain
    // (syntactically) valid path strings, checking for the length of the
    // contained text is a reasonable way of determining the value of the
    // bound property.
    NSUInteger sourceLength = [[[self sourceDirectoryField] stringValue] length];
    NSUInteger targetLength = [[[self targetFileField] stringValue] length];
    
    if (sourceLength > 0 && targetLength > 0) {
        [self setProcessingButtonEnabled:YES];
    }
    else {
        [self setProcessingButtonEnabled:NO];
    }
}

#pragma mark Button actions

- (IBAction)chooseSourceDir:(NSButton *)sender {
    [[self sourceDirectoryController] selectSourcePath:[self window]
                                              callback: 
        ^(NSString* path) {
            [[self sourceDirectoryField] setStringValue:path];
            [self determineProcessingButtonState];
        }
    ];
}

- (IBAction)chooseTargetFile:(NSButton *)sender {
    [[self targetFileController] selectTargetFile:[self window]
                                         callback: 
        ^(NSString *path) {
            [[self targetFileField] setStringValue:path];
            [self determineProcessingButtonState];
        }
    ];
}

- (IBAction)startProcessing:(NSButton *)sender {
    // Instantiate ProgressBarController, open its window as a modal sheet
    // and pass control over to its beginProcessing method.
    ProgressBarController *progressBarController = [[ProgressBarController alloc] initWithWindowNibName:@"ProgressBarController"];
    [self setProgressBarController:progressBarController];
    [progressBarController release];
    
    [NSApp beginSheet:[[self progressBarController] window]
       modalForWindow:[self window]
        modalDelegate:[self progressBarController] // contains the sheet ending method...
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) // ...referenced by this selector
          contextInfo:nil];
    
    NSURL *sourceDirectoryURL = [NSURL fileURLWithPath:[[self sourceDirectoryField] stringValue]
                                           isDirectory:YES];
    [[self progressBarController] beginProcessingSourceDirectory:sourceDirectoryURL];
}

#pragma mark Boilerplate

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self setSourceDirectoryController:[[[SourceDirectoryController alloc] init] autorelease]];
    [self setTargetFileController:[[[TargetFileController alloc] init] autorelease]];
    [self setProcessingButtonEnabled:NO];
}

- (void)dealloc {
    [self setSourceDirectoryController:nil];
    [self setTargetFileController:nil];
    [self setProgressBarController:nil];
    [super dealloc];
}
@end
