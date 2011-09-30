//
//  afFileManagerExt.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSFileManagerExtensions.h"

@implementation NSFileManager(NSFileManagerExtensions)

+ (NSString *) documentDirectory{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	
	return documentDirectory;
}

+ (BOOL) removeFileAtPath:(NSString *)filePath{
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *err = nil;
	
	BOOL success = [fm removeItemAtPath:filePath error:&err];
	if (!success || err) {
		NSLog(@"%@ deletion failed",filePath);
		NSLog(@"err: %@",err);
	} 
	return success;
}

@end
