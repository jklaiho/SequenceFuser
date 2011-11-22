#import "SourceDirectoryController.h"
#import "NSArray+Filtering.h"

// Error domain for source directory and target file operations
NSString * const SFPathChoiceErrors = @"SFPathChoiceErrors";

// Error codes for this domain
enum SFPathChoiceErrorCodes {
    kSFNoSequenceFound          = 1,
    kSFMultipleSequencesFound   = 2,
    kSFNotAnImageSequence       = 3
};

/*
 Category for SourceDirectoryController to provide it with "private" methods
 used by panel:validateURL:error:
 */
@interface SourceDirectoryController (private)

- (BOOL)validateSequenceFilesInArray:(NSArray *)array error:(NSError **)error;
- (NSDictionary *)createUserInfoDictionaryWithArray:(NSArray *)objArray;

@end



@implementation SourceDirectoryController

/*
 NSOpenSavePanelDelegate method. Runs after the "Open" button is pressed
 to validate the choice before it is filled into a text field. Calls out to
 individual validation utility methods.
 */
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError {
    
    NSArray *sequenceFiles = [PathChoiceUtilities getSequenceFileNamesAtURL:url];
    
    if ([self validateSequenceFilesInArray:sequenceFiles error:outError]) {
        return YES;
    }
    return NO;
}

- (void)selectSourcePath:(NSWindow *)window callback:(PathBlock)pathCallback {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setDelegate:self];
    
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginSheetModalForWindow:window 
                  completionHandler:^(NSInteger result) {
                      if (result == NSFileHandlingPanelOKButton) {
                          NSArray* urls = [panel URLs];
                          pathCallback([[urls objectAtIndex:0] path]);
                      }
                  }];
}

#pragma mark Private methods

- (BOOL)validateSequenceFilesInArray:(NSArray *)sequenceFiles error:(NSError **)outError {
    
    // --------------------------------
    // Validation step one: File counts
    // --------------------------------
    
    // Two is technically a sequence, after all...
    if ([sequenceFiles count] < 2) {
        if (outError != NULL) {
            NSDictionary *errorDict = [self createUserInfoDictionaryWithArray:
                [NSArray arrayWithObjects:
                    @"The chosen directory does not contain an image sequence.",
                    @"Please select a directory that contains sequentially named image files.",
                    nil]];
            *outError = [NSError errorWithDomain:SFPathChoiceErrors code:kSFNoSequenceFound userInfo:errorDict];
        }
        return NO;
    }
    
    // -----------------------------------------
    // Validation step two: single sequence only
    // -----------------------------------------
    
    // OK, we've got one or more sequences. Thing is, there can only be one
    // sequence in the source directory. Confirm that this is the case by
    // seeing if all the elements of sequenceFiles have the same string prefix
    // before the digits (or no prefix, just the numbers).
    __block NSMutableSet *foundPrefixes = [NSMutableSet set];
    
    NSString *prefixPattern = @"^(\\D*)?"; // Zero or more non-decimal characters, captured
    NSRegularExpression *prefixRegex = 
        [NSRegularExpression regularExpressionWithPattern:prefixPattern 
                                                  options:NSRegularExpressionAllowCommentsAndWhitespace
                                                    error:nil];
    
    // Capture the strings prefixing the sequence numbers and place them in the
    // foundPrefixes set.
    for (NSURL *url in sequenceFiles) {
        // See if the filename matches
        NSString *filename = [url lastPathComponent];
        NSTextCheckingResult *match = [prefixRegex firstMatchInString:filename
                                                              options:0
                                                                range:NSMakeRange(0, [filename length])];
        if (match) {
            NSString *sequencePrefix = [filename substringWithRange:[match rangeAtIndex:1]];
            [foundPrefixes addObject:sequencePrefix];
        }
    }
    
    if ([foundPrefixes count] > 1) {
        if (outError != NULL) {
            NSDictionary *errorDict = [self createUserInfoDictionaryWithArray:
                [NSArray arrayWithObjects:
                    @"Multiple sets of sequentially named files found.",
                    @"The source directory must contain only one set of sequentially named files.",
                    nil]];
            *outError = [NSError errorWithDomain:SFPathChoiceErrors code:kSFMultipleSequencesFound userInfo:errorDict];
        }
        return NO;
    }
    
    // --------------------------------------
    // Validation step three: file type check
    // --------------------------------------
    
    // We verifiably have just one sequence. The UTI information has been cached
    // into the NSURLs of our filtered array, see that all the files have a
    // supported UTI.
    NSSet *supportedUTIs = [NSSet setWithObjects:@"public.png", @"public.jpeg", @"public.tiff", nil];
    // getResourceValue takes an (id *), so allocate one NSMutableString to hold
    // all the values returned by the method in the for loop temporarily
    NSMutableString *UTI = [[NSMutableString alloc] init];
    for (NSURL *file in sequenceFiles) {
        // Ignore the returned BOOL, run for the UTI-populating side effect
        [file getResourceValue:&UTI forKey:NSURLTypeIdentifierKey error:nil];
        
        if (![supportedUTIs containsObject:UTI]) {
            if (outError != NULL) {
                NSDictionary *errorDict = [self createUserInfoDictionaryWithArray:
                    [NSArray arrayWithObjects:
                        @"The sequence contains files that are not images.",
                        @"A sequentially named set of files was found, but it contains files that are not recognized as images.",
                        nil]];
                *outError = [NSError errorWithDomain:SFPathChoiceErrors code:kSFNotAnImageSequence userInfo:errorDict];
            }
            return NO;
        }
    }
    [UTI release];
    
    // All OK! The source directory is fine for processing.
    return YES;
}

/*
 Utility method for creating user info dictionaries for NSError objects
 */
- (NSDictionary *)createUserInfoDictionaryWithArray:(NSArray *)objArray {
    NSArray *keyArray = [NSArray arrayWithObjects:
                         NSLocalizedDescriptionKey,
                         NSLocalizedRecoverySuggestionErrorKey,
                         nil];
    return [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
}

@end
