//
//  SourceDirPanelDelegate.m
//  SequenceFuser
//
//  Created by Jarkko Laiho on 27.10.2011.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "SourceDirPanelDelegate.h"

@implementation SourceDirPanelDelegate
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    return YES;
}
@end
