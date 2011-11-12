#import <Foundation/Foundation.h>

// Error domain for source directory and target file operations
extern NSString * const SFPathChoiceErrors;

// Error codes for this domain
enum SFPathChoiceErrorCodes {
    kSFNoSequenceFound          = 1,
    kSFMultipleSequencesFound   = 2,
    kSFNotAnImageSequence       = 3
};

// Use (PathBlock)someBlock instead of (void (^)(NSString *))someBlock
typedef void (^PathBlock)(NSString *);

@interface SourceDirectoryController : NSObject <NSOpenSavePanelDelegate>
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError;
- (void)selectSourcePath:(NSWindow *)window callback:(PathBlock)pathCallback;
@end

@interface TargetFileController : NSObject
- (void)selectTargetFile:(NSWindow *)window callback:(PathBlock)pathCallback;
@end