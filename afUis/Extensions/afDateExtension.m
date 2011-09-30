//
//  afDateExtension.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 15/09/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "afDateExtension.h"


@implementation afDateExtension

+ (NSDate *)stringToDate:(NSString *)theDate
withLocalIdentifier:(NSString *)li
andDateFormat:(NSString *)dformat{
	
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:li];
	
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setLocale:usLocale];
	[df setDateFormat:dformat];
	[usLocale release];
	
	NSDate *myDate = [df dateFromString: theDate];
	
	return myDate;
}

@end
