//
//  afDateExtension.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 15/09/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (afDateExtensions) 

+ (NSDate *)stringToDate:(NSString *)theDate
     withLocalIdentifier:(NSString *)li
           andDateFormat:(NSString *)df;

@end
