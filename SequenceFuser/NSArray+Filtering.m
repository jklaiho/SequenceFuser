#import "NSArray+Filtering.h"

@implementation NSArray (Filtering)

- (NSArray *)filteredArrayUsingRegex:(NSRegularExpression *)regex {
    NSMutableArray *matches = [NSMutableArray array];
    for (id obj in self) {
        NSString *item = [NSString stringWithFormat:@"%@", obj];
        if ([regex numberOfMatchesInString:item options:0 range:NSMakeRange(0, [item length])] > 0) {
            [matches addObject:item];
        }
    }
    // NSCopying docs for copyWithZone: state that a copy of a mutable object
    // will be immutable, so this is valid. Suggested for NSMutableArray to
    // NSArray conversions at Stack Overflow.
    NSArray *result = [[matches copy] autorelease];
    return result;
}

- (NSArray *)filteredArrayUsingBlock:(BOOL (^)(id obj))block {
    NSMutableArray *matches = [NSMutableArray array];
    for (id obj in self) {
        if (block(obj)) [matches addObject:obj];
    }
    NSArray *result = [[matches copy] autorelease];
    return result;
}
@end