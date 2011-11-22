#import "ProgressBarController.h"
#import "PathChoiceUtilities.h"

@implementation ProgressBarController

@synthesize progressBar = _progressBar;
@synthesize revealInFinderWhenFinished = _revealInFinderWhenFinished;

- (void)beginProcessingSourceDirectory:(NSURL *)sourceDirectory {
    // Start the thing, then call endSheet
    NSArray *sequenceFiles = [PathChoiceUtilities getSequenceFileNamesAtURL:sourceDirectory];
}

- (IBAction)cancelProcessing:(NSButton *)sender {
    [NSApp endSheet:[self window]];
}

// Delegate method that gets called by [NSApp endSheet:]
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    // Remove the sheet from the screen.
    [sheet orderOut:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self setRevealInFinderWhenFinished:YES];
}

@end
