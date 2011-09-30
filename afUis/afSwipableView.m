//
//  afSwipableView.m
//  Etudiant
//
//  Created by Adrien Ferré on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afSwipableView.h"


@implementation afSwipableView

@synthesize theDelegate, touchBeganX, touchBeganY, touchMovedX, touchMovedY,hasMoved;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	hasMoved = NO;
	
	CGPoint pt;
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 1){
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		
		if ([touch tapCount] == 1) {
			pt = [touch locationInView:self];
			touchBeganX = pt.x;
			touchBeganY = pt.y;
		}
	}	
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	hasMoved = YES;
	
	CGPoint pt;
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 1){
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if ([touch tapCount] == 1){
			pt = [touch locationInView:self];
			touchMovedX = pt.x;
			touchMovedY = pt.y;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	
	CGFloat diff = 60;
	
	if ([allTouches count] == 1 && hasMoved){
		
		CGFloat diffX = touchMovedX - touchBeganX;
		CGFloat diffY = touchMovedY - touchBeganY;
		
		//NSLog(@"diffX = %f, diffY = %f, diff is %f",diffX,diffY,diff);
		
		if (diffY >= -diff && diffY <= diff){
			if (diffX > diff){
				//		NSLog(@"swipe right");
				if (theDelegate !=NULL && 
					[theDelegate respondsToSelector:@selector(hasSwipedRight)]) 
					[theDelegate hasSwipedRight];
			}
			else if (diffX < -diff){
				//		NSLog(@"swipe left");
				if (theDelegate !=NULL && 
					[theDelegate respondsToSelector:@selector(hasSwipedLeft)]) 
					[theDelegate hasSwipedLeft];
			}
		}
	}
}


@end
