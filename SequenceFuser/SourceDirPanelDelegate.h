//
//  SourceDirPanelDelegate.h
//  SequenceFuser
//
//  Created by Jarkko Laiho on 27.10.2011.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceDirPanelDelegate : NSObject <NSOpenSavePanelDelegate>
- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError *__autoreleasing *)outError;
@end
