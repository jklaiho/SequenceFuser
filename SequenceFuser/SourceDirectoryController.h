#import <Foundation/Foundation.h>
#import "PathChoiceUtilities.h"

/*
 The logic for selecting a source directory and validating that the chosen
 directory actually contains an image sequence.
 */
@interface SourceDirectoryController : NSObject <NSOpenSavePanelDelegate>

- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError;
- (void)selectSourcePath:(NSWindow *)window callback:(PathBlock)pathCallback;

@end
