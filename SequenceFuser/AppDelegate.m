//
//  AppDelegate.m
//  SequenceFuser
//
//  Created by Jarkko Laiho on 25.10.2011.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "AppDelegate.h"
#import "SourceDirPanelDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize sourceDirectoryField = _sourceDirectoryField;
@synthesize targetFileField = _targetFileField;

- (IBAction)chooseSourceDir:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    SourceDirPanelDelegate *panelDelegate = [[SourceDirPanelDelegate alloc] init];
    [panel setDelegate:panelDelegate];
    
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        NSLog(@"%ld", result);
//        if (result == NSFileHandlingPanelOKButton) {
//            // TODO validate dir selection through delegate
//            NSArray* urls = [panel URLs];
//            NSLog(@"%@", urls);
//        }
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

@end
