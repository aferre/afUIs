//
//  CustomMaths.h
//  Disque
//
//  Created by adrien ferré on 22/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface afMaths : NSObject {

}
#pragma mark -
#pragma mark === Maths ===
#pragma mark -

+ (CGFloat) DegreesToRadians:(CGFloat) degrees;

+ (CGFloat) RadiansToDegrees:(CGFloat) radians ;

+ (CGFloat) angleBetween:(CGPoint)firstPoint 
and:(CGPoint)secondPoint 
andOrigin:(CGPoint)origin;

@end
