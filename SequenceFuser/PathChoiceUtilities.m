#import "PathChoiceUtilities.h"
#import "NSArray+Filtering.h"

@implementation PathChoiceUtilities

+ (NSArray *)getSequenceFileNamesAtURL:(NSURL *)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get a listing of all files in the source directory
    NSArray *files = [fileManager contentsOfDirectoryAtURL:url
                                includingPropertiesForKeys:[NSArray arrayWithObjects:
                                                            NSURLNameKey,
                                                            NSURLTypeIdentifierKey,
                                                            NSURLIsReadableKey, nil]
                                                   options:NSDirectoryEnumerationSkipsHiddenFiles
                                                     error:nil];
    
    // This block returns a new array containing only those NSURL objects that
    // point to files that, judging by their names, are part of a sequence.
    // TODO refactor to filteredArrayUsingRegex
    NSArray *sequenceFiles = [files filteredArrayUsingBlock:^(id obj) {
        NSURL *url = (NSURL *)obj;
        // Construct the sequence identification regex
        NSString *sequencePattern = @"^\\D*?"       // Zero or more non-decimal characters
                                    "\\d+"          // One or more decimal characters
                                    "\\.\\w{3,4}$"; // dot followed by 3-4 letter alphanumeric file extension
                                                    // (enough for the supported file types)
        NSRegularExpression *sequenceRegex = 
            [NSRegularExpression regularExpressionWithPattern:sequencePattern 
                                                      options:NSRegularExpressionAllowCommentsAndWhitespace
                                                        error:nil];
        // See if the filename matches
        NSString *filename = [url lastPathComponent];
        NSTextCheckingResult *match = [sequenceRegex firstMatchInString:filename
                                                                options:0
                                                                  range:NSMakeRange(0, [filename length])];
        
        // Match found. This item will be added to the result array.
        if (match) return YES;
        
        return NO;
    }];
    
    return sequenceFiles;
}

@end