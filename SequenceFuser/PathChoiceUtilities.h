#import <Foundation/Foundation.h>

// Use (PathBlock)someBlock instead of (void (^)(NSString *))someBlock
typedef void (^PathBlock)(NSString *);


@interface PathChoiceUtilities : NSObject

+ (NSArray *)getSequenceFileNamesAtURL:(NSURL *)url;

@end
