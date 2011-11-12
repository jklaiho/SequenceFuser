#import "PathChoiceController.h"
#import "NSArray+Filtering.h"

NSString * const SFPathChoiceErrors = @"SFPathChoiceErrors";

/*
 Category for SourceDirectoryController to provide it with "private" methods
 used by panel:validateURL:error:
 */
@interface SourceDirectoryController (private)
- (BOOL)validateSequenceFilesInArray:(NSArray *)array error:(NSError **)error;
- (NSDictionary *)createUserInfoDictionaryWithArray:(NSArray *)objArray;
@end


/*
 The logic for selecting a source directory and validating that the chosen
 directory actually contains an image sequence.
 */
@implementation SourceDirectoryController

/*
 NSOpenSavePanelDelegate method. Runs after the "Open" button is pressed
 to validate the choice before it is filled into a text field. Calls out to
 individual validation utility methods.
 */
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get a listing of all files in the source directory
    NSArray *files = [fileManager contentsOfDirectoryAtURL:url
                                includingPropertiesForKeys:[NSArray arrayWithObjects:
                                                            NSURLNameKey,
                                                            NSURLTypeIdentifierKey,
                                                            NSURLIsReadableKey, nil]
                                                   options:NSDirectoryEnumerationSkipsHiddenFiles
                                                     error:nil];
    
    if ([self validateSequenceFilesInArray:files error:outError]) {
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

@end


/*
 The logic for selecting a target file (a QuickTime .mov).
 */
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



@implementation SourceDirectoryController (private)

- (BOOL)validateSequenceFilesInArray:(NSArray *)array error:(NSError **)outError {
    // A set to hold sequence name prefixes found by the block below
    __block NSMutableSet *foundPrefixes = [NSMutableSet set];
    
    // This block does two things. First, it returns a new array containing only
    // those NSURL objects that point to files that, judging by their names, are
    // part of a sequence. Second, it captures the strings prefixing the
    // sequence numbers and places them in the foundPrefixes set.
    NSArray *sequenceFiles = [array filteredArrayUsingBlock:^(id obj) {
        NSURL *url = (NSURL *)obj;
        // Construct the sequence identification regex
        NSString *sequencePattern = @"^(\\D*?)"     // Zero or more non-decimal characters, captured
                                    "\\d+"          // One or more decimal characters
                                    "\\.\\w{3,4}$"; // 3-4 letter alphanumeric file extension including dot
                                                    // (enough for the supported file types)
        NSRegularExpression *sequenceRegex = [NSRegularExpression 
                                                 regularExpressionWithPattern:sequencePattern
                                                                      options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                        error:nil];
        // See if the filename matches
        NSString *item = [NSString stringWithFormat:@"%@", [url lastPathComponent]];
        NSTextCheckingResult *match = [sequenceRegex firstMatchInString:item
                                                  options:0
                                                    range:NSMakeRange(0, [item length])];
        // Match found. This item will be added to the result array. Also
        // extract the sequence prefix and assign it to the foundPrefixes set.
        if (match) {
            NSString *sequencePrefix = [item substringWithRange:[match rangeAtIndex:1]];
            [foundPrefixes addObject:sequencePrefix];
            return YES;
        }
        else {
            return NO;
        }
    }];
    
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
    
    // OK, we've got one or more sequences. Thing is, there can only be one
    // sequence in the source directory. Confirm that this is the case by
    // seeing if all the elements of sequenceFiles have the same string prefix
    // before the digits.
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
    
    // We verifiably have just one sequence. The UTI information has been cached
    // into the NSURLs of our filtered array, see that all the files have a
    // supported UTI.
    NSSet *supportedUTIs = [NSSet setWithObjects:@"public.png", @"public.jpeg", @"public.tiff", nil];
    // getResourceValue takes an (id *), so allocate one NSString to hold all
    // the values returned by the method in the for loop
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
