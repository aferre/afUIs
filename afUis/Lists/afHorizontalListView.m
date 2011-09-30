//
//  viewListView.m
//  Letudiant
//
//  Created by adrien ferré on 22/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afHorizontalListView.h"
#import <QuartzCore/QuartzCore.h>
#import "afHorizontalStackedView.h"

@implementation afHorizontalListView

- (id) initWithFrame:(CGRect)theFrame
	  andDataSource:(id)theDataSource
	   hasNavArrows:(BOOL)hasArrows{
	
	if (self = [super initWithFrame:theFrame
					  andDataSource:theDataSource
					   hasNavArrows:hasArrows]) {
		
		listViews = [[afHorizontalStackedView alloc] initWithFrame:CGRectMake(0, 0, theFrame.size.width,theFrame.size.height)
												 andWidthMargin:5
												andHeightMargin:5];
		
		//listViews = [[afHorizontalListView alloc] initWithFrame:CGRectMake(0, 5, theFrame.size.width,Image_Height)];
		listViews.backgroundColor = [UIColor clearColor];
		listViews.layer.masksToBounds = YES;
		listViews.opaque = NO;
		
		[self reloadData];
	/*	UIImage *maskImage = [UIImage imageNamed:@"FusedMaskDDD.png"];
		CALayer *maskLayer = [[CALayer alloc] init];
		maskLayer.frame = CGRectMake(5, 0,	maskImage.size.width, maskImage.size.height);	
		maskLayer.contents = (id)maskImage.CGImage;
		listViews.layer.mask = maskLayer;
	*/	
		[self addSubview:listViews];
	
		[self setHasNavArrow: hasArrows];
		
	}
	
	return self;
}

- (void) animateToSelected{
	CGFloat xSelection = self.frame.size.width/2;
	
	CGFloat currentSelectionCenterX = ((UIView *)[listViews viewWithTag:lastSelectedViewTag]).center.x;
	
	CGFloat xDelta = currentSelectionCenterX - xSelection; 
	
	for (UIView *v in listViews.subviews) {
		CGPoint initialCenter= v.center;
		initialCenter.x -= xDelta;
		[UIView beginAnimations:nil context:NULL]; 
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:QList_Transition_Time];
		v.center = initialCenter;
		[UIView commitAnimations];
	}
	
}

- (void) setHasNavArrow:(BOOL)nav{
	
	UIImage *leftArrowImg = [UIImage imageNamed:@"arrowL_new.png"];
	
	if (!previousArrow) {
		
		previousArrow = [[UIButton alloc] initWithFrame:CGRectMake(45, 35, 
															   leftArrowImg.size.width, leftArrowImg.size.height)];
		previousArrow.center = CGPointMake(self.listViews.frame.size.height/2,self.listViews.frame.size.height/2);
		[previousArrow setBackgroundImage:leftArrowImg forState:UIControlStateNormal];
		[previousArrow addTarget:self action:@selector(selectPrevious) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:previousArrow];
	}
	else {
		
	}
	
	if (!nextArrow) {
		
		UIImage *rightArrowImg = [UIImage imageNamed:@"arrowR_new.png"];
		nextArrow = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 65, 35,
																rightArrowImg.size.width, rightArrowImg.size.height)];
		nextArrow.center = CGPointMake(self.listViews.frame.size.width - self.listViews.frame.size.height/2, self.listViews.frame.size.height/2);
		[nextArrow setBackgroundImage:rightArrowImg forState:UIControlStateNormal];
		[nextArrow addTarget:self action:@selector(selectNext) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:nextArrow];
		
	}
	else {
		
	}
	
}

#pragma mark -
#pragma mark == Touch Handling ==
#pragma mark -

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self]; 
	
	touchPoint = point;
	
	isTouchingImage = NO;
	
	hasMoved = NO;
	//touching an image
	if ([self hitTest:touchPoint withEvent:event].tag !=0) isTouchingImage = YES;
	[super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self]; 
	hasMoved = YES;
	CGFloat xDelta = touchPoint.x - point.x; 
	
	//touching an image
	if (isTouchingImage){
		
		for (UIView *v in listViews.subviews) {
			CGRect initialFrame = v.frame;
			initialFrame.origin.x -=xDelta;
			v.frame = initialFrame;
		}
		int selectedViewTag = [self selectedViewTag];
		if (selectedViewTag != 0) 
			[self setSelected:selectedViewTag];
		
		if (self.selectionDelegate != NULL && selectedViewTag != 0) {
			[selectionDelegate selectedIndex:selectedViewTag-1];
			//[self updateForQuizz:selectedViewTag-1];
			//thePageControl.currentPage = selectedViewTag-1;
		}    
	}
	touchPoint = point;
	[super touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self]; 
	
	int stag = [self selectedViewTag];
	
	if (hasMoved) 
		[self animateToSelected];
	
	else if (stag == lastSelectedViewTag && [self hitTest:point withEvent:event].tag == lastSelectedViewTag ){
		
		if (self.selectionDelegate != NULL && 
			[self.selectionDelegate respondsToSelector:@selector(clicked)]) {
			[selectionDelegate clicked];
		}    
		
	}
	
	[super touchesEnded:touches withEvent:event];
}

@end
