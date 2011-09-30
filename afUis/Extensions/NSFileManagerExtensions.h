//
//  afFileManagerExt.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSFileManager(NSFileManagerExtensions)

+ (NSString *) documentDirectory;
+ (BOOL) removeFileAtPath:(NSString *)filePath;

@end
