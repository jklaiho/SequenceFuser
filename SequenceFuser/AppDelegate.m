#import "AppDelegate.h"

@implementation AppDelegate

@synthesize mainWindowController = _mainWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    // Initialize and show the main window
    SFMainWindowController *windowController = [[SFMainWindowController alloc] initWithWindowNibName:@"SFMainWindowController"];
    [windowController showWindow:nil];
    [self setMainWindowController:windowController];
    [windowController release];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
