//
//  afSwipableView.h
//  Etudiant
//
//  Created by Adrien Ferré on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol afSwipableViewDelegate;

@interface afSwipableView : UIView {

	id<afSwipableViewDelegate> theDelegate;
	
	// touch handling
	
	CGFloat touchBeganX;
	
	CGFloat touchBeganY;
	
	CGFloat touchMovedX;
	
	CGFloat touchMovedY;
	
	BOOL hasMoved;
}
@property (assign) id<afSwipableViewDelegate> theDelegate;
@property (assign) CGFloat touchBeganX;
@property (assign) CGFloat touchBeganY;
@property (assign) CGFloat touchMovedX;
@property (assign) CGFloat touchMovedY;
@property BOOL hasMoved;

@end

@protocol afSwipableViewDelegate <NSObject>

@optional 

-(void) hasSwipedRight;
-(void) hasSwipedLeft;

@end