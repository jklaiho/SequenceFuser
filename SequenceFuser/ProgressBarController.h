#import <Cocoa/Cocoa.h>

@interface ProgressBarController : NSWindowController

@property (assign) IBOutlet NSProgressIndicator *progressBar;
@property BOOL revealInFinderWhenFinished;

- (IBAction)cancelProcessing:(NSButton *)sender;

- (void)beginProcessingSourceDirectory:(NSURL *)sourceDirectory;
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

@end
