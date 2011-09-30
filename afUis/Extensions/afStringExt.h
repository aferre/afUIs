//
//  afStringExt.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 14/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (afStringExt) 

- (BOOL) isEmpty;

+ (NSString *)stringFromDate:(NSDate *)theDate
         withLocalIdentifier:(NSString *)li
               andDateFormat:(NSString *)df;

- (NSString *) reducedString;

#pragma -
#pragma Encoding

+(NSString *)base64EncodeData:(NSData *)data;

-(NSString *)base64;

@end
