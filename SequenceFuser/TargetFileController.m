#import "TargetFileController.h"

@implementation TargetFileController

- (void)selectTargetFile:(NSWindow *)window callback:(PathBlock)pathCallback {
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // Should @"public.mpeg-4" for .mp4 files be added?
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"com.apple.quicktime-movie", nil]];
    [panel setCanCreateDirectories:YES];
    
    [panel beginSheetModalForWindow:window
                  completionHandler:^(NSInteger result) {
                      if (result == NSFileHandlingPanelOKButton) {
                          pathCallback([[panel URL] path]);
                      }
                  }];
}

@end
