#import <Foundation/Foundation.h>
#import "PathChoiceUtilities.h"

/*
 The logic for selecting a target file (a QuickTime .mov).
 */
@interface TargetFileController : NSObject
- (void)selectTargetFile:(NSWindow *)window callback:(PathBlock)pathCallback;
@end
