#import "AppDelegate.h"
#import "PathChoiceController.h"

@implementation AppDelegate {
    // Could be synthesized retained properties, but define by hand for the sake of practice
    SourceDirectoryController *_sourceDirectoryController;
    TargetFileController *_targetFileController;
}

#pragma mark Properties

@synthesize window = _window;
@synthesize sourceDirectoryField = _sourceDirectoryField;
@synthesize targetFileField = _targetFileField;
@synthesize startProcessingButton = _startProcessingButton;
@synthesize processingButtonEnabled = _processingButtonEnabled;

#pragma mark Getters

- (SourceDirectoryController*) sourceDirectoryController {
    return _sourceDirectoryController;
}

- (TargetFileController*) targetFileController {
    return _targetFileController;
}

#pragma mark Setters

- (void)setSourceDirectoryController:(SourceDirectoryController *) sourceDirectoryController {
    if (_sourceDirectoryController != sourceDirectoryController) {
        [_sourceDirectoryController release];
        _sourceDirectoryController = [sourceDirectoryController retain];
    }
}

- (void)setTargetFileController:(TargetFileController *) targetFileController {
    if (_targetFileController != targetFileController) {
        [_targetFileController release];
        _targetFileController = [targetFileController retain];
    }
}

#pragma mark Button actions

/* 
 Utility method for the source/target IBActions
 */
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

- (IBAction)chooseSourceDir:(NSButton *)sender {
    [[self sourceDirectoryController] selectSourcePath:[self window]
                                              callback: ^(NSString* path) {
        [[self sourceDirectoryField] setStringValue:path];
        [self determineProcessingButtonState];
    }];
}

- (IBAction)chooseTargetFile:(NSButton *)sender {
    [[self targetFileController] selectTargetFile:[self window]
                                         callback: ^(NSString *path) {
        [[self targetFileField] setStringValue:path];
        [self determineProcessingButtonState];
    }];
}

- (IBAction)startProcessing:(NSButton *)sender {
    
}

#pragma mark Protocol implementation

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


#pragma mark init and dealloc

- (id)init {
    if ((self = [super init])) {
        [self setSourceDirectoryController:[[[SourceDirectoryController alloc] init] autorelease]];
        [self setTargetFileController:[[[TargetFileController alloc] init] autorelease]];
        [self setProcessingButtonEnabled:NO];
    }
    return self;
}

- (void)dealloc {
    [self setSourceDirectoryController:nil];
    [self setTargetFileController:nil];
    [super dealloc];
}
@end
