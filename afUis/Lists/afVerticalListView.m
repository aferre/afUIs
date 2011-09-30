//
//  afVerticalListView.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afVerticalListView.h"

@implementation afVerticalListView

- (id)initWithFrame:(CGRect)theFrame
	  andDataSource:(id)theDataSource
	   hasNavArrows:(BOOL)hasArrows{
	
	if (self = [super initWithFrame:theFrame
					  andDataSource:theDataSource
					   hasNavArrows:hasArrows]) {
		
		listViews = [[afVerticalStackedView alloc] initWithFrame:CGRectMake(0, 0, theFrame.size.width,theFrame.size.height)
													andWidthMargin:5
												   andHeightMargin:5];
		
		listViews.backgroundColor = [UIColor clearColor];
		listViews.layer.masksToBounds = YES;
		listViews.opaque = NO;
		
		[self reloadData];
		[self addSubview:listViews];
		[self setHasNavArrow: hasArrows];
	}
	return self;
}

- (void) animateToSelected{
	CGFloat ySelection = self.frame.size.height/2;
	
	CGFloat currentSelectionCenterY = ((UIView *)[listViews viewWithTag:lastSelectedViewTag]).center.y;
	
	CGFloat yDelta = currentSelectionCenterY - ySelection; 
	
	for (UIView *v in listViews.subviews) {
		CGPoint initialCenter = v.center;
		initialCenter.y -= yDelta;
		[UIView beginAnimations:nil context:NULL]; 
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:QList_Transition_Time];
		v.center = initialCenter;
		[UIView commitAnimations];
	}
	
    [super animateToSelected];
}

- (void) setHasNavArrow:(BOOL)nav{
	
	UIImage *leftArrowImg = [UIImage imageNamed:@"arrowL_new.png"];
	
	if (!previousArrow) {
		
		previousArrow = [[UIButton alloc] initWithFrame:CGRectMake(45, 35, 
															   leftArrowImg.size.width, leftArrowImg.size.height)];
		
		previousArrow.center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
		
		previousArrow.transform = CGAffineTransformRotate(previousArrow.transform, M_PI/2);
		
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
		
		nextArrow.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.frame.size.width/2);
		
		nextArrow.transform = CGAffineTransformRotate(nextArrow.transform, M_PI/2);
		
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
	CGFloat yDelta = touchPoint.y - point.y; 
	
	//touching an image
	if (isTouchingImage){
		
		for (UIView *v in listViews.subviews) {
			CGRect initialFrame = v.frame;
			initialFrame.origin.y -= yDelta;
			v.frame = initialFrame;
		}
		
		int selectedViewTag = [self selectedViewTag];
		NSLog(@"selectedViewTag %d",selectedViewTag);
		
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
	NSLog(@"selectedViewTag %d",stag);
	
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


-(void) dealloc{
    [super dealloc];
}
@end
