//
//  CustomMaths.m
//  Disque
//
//  Created by adrien ferré on 22/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afMaths.h"


@implementation afMaths

#pragma mark -
#pragma mark === Maths ===
#pragma mark -

+ (CGFloat) DegreesToRadians:(CGFloat) degrees {
	return degrees * M_PI / 180;
}

+ (CGFloat) RadiansToDegrees:(CGFloat) radians {
	return radians * 180 / M_PI;
}

+ (CGFloat) angleBetween:(CGPoint)firstPoint and:(CGPoint)secondPoint andOrigin:(CGPoint)origin {
	CGFloat a1, b1, a2, b2, a, b, t, cosinus ;
	
	a1 = firstPoint.x - origin.x ;
	a2 = firstPoint.y - origin.y ;
	
	b1 = secondPoint.x - origin.x ;
	b2 = secondPoint.y - origin.y ;
	
	a = sqrt ( (a1*a1) + (a2*a2) );
	b = sqrt ( (b1*b1) + (b2*b2) );
	
	if ( (a == 0.0) || (b == 0.0) )
		return (0.0) ;
	
	cosinus = (a1*b1+a2*b2) / (a*b) ;
	
	t = acos ( cosinus );
	
	if (firstPoint.x < secondPoint.x) t = -t;
	if (-M_PI <= t && t <=M_PI) {
		//NSLog(@"return value is %f",t);
		return t;
	}
	return 0.0;
}
@end
