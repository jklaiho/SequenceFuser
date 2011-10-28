//
//  AppDelegate.h
//  SequenceFuser
//
//  Created by Jarkko Laiho on 25.10.2011.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *sourceDirectoryField;
@property (weak) IBOutlet NSTextField *targetFileField;

- (IBAction)chooseSourceDir:(NSButton *)sender;

@end
