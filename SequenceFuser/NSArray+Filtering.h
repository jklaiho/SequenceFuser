#import <Foundation/Foundation.h>

// Add some useful filtered array-returning methods to NSArray
@interface NSArray (Filtering)
- (NSArray *)filteredArrayUsingRegex:(NSRegularExpression *)regex;
- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id obj))block;
@end
