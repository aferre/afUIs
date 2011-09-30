//
//  afListView.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afListView.h"
#import "afHorizontalListView.h"
#import <QuartzCore/QuartzCore.h>

@implementation afListView

@synthesize touchPoint,isTouchingImage,selectionDelegate,lastSelectedViewTag,listViews;

@synthesize hasMoved, previousArrow, nextArrow, dataSource, hasNavArrow;

#pragma mark -
#pragma mark == Init == 
#pragma mark -

- (id) initWithFrame:(CGRect)theFrame
	   andDataSource:(id)theDataSource
		hasNavArrows:(BOOL)hasArrows{
	
	dataSource = theDataSource;
	
	if (self = [super initWithFrame:theFrame]) {
		
		self.opaque = YES;
		self.layer.masksToBounds = YES;
		
		self.layer.name = @"listView";
		[self performSelector:@selector(selectionInit) withObject:nil afterDelay:0.01];
		hasNavArrows = hasArrows;
	}
	
	return self;
}

- (void) selectionInit{
	if ([listViews.subviews count]>=2) [self setSelectedAndAnimate:2];
	else if ([listViews.subviews count]==1) [self setSelectedAndAnimate:1];
}

- (void) reloadData{
	
	for (UIView *v in [listViews subviews]) 
		[v removeFromSuperview];
	
	int numberOfViews = [dataSource numberOfItems:self];
	
	int count = 0;
	
	for (int i = 0 ; i < numberOfViews ; i ++){
		UIView *theV = [dataSource listView:self viewForIndex:i];
		
		count = i + 1;
		
		theV.tag = count;
		
		[listViews addSubview:theV];
	}
	if (hasNavArrows) {
		[self bringSubviewToFront:nextArrow];
		[self bringSubviewToFront:previousArrow];
	}
}

#pragma mark -
#pragma mark == Selection handling and animation== 
#pragma mark -

- (int) selectedViewTag{
	CGFloat xSelection = self.frame.size.width/2;
	CGFloat ySelection = self.frame.size.height/2;
	CGPoint point = CGPointMake(xSelection, ySelection);
	
	int viewTag = [self hitTest:point withEvent:nil].tag;
	return viewTag;
}

- (void) setSelected:(int)theSelected{
	lastSelectedViewTag = theSelected;
	
	//thePageControl.currentPage = theSelected - 1;
	//[self updateForQuizz:theSelected-1];	
	/*for (UIView *theView in imgContainer.subviews) {
	 
	 if (theView.tag != 999)
	 theView.layer.opacity = Not_Selected_Opacity;
	 
	 if (theView.tag == theSelected)
	 theView.layer.opacity = 1;
	 }*/
	
	if (hasNavArrows) [self configArrowsForSelection];
	
	if (selectionDelegate != NULL && [selectionDelegate respondsToSelector:@selector(isUnderSelection:)]) {
		[selectionDelegate isUnderSelection:lastSelectedViewTag - 1];
	}
}

- (void) setSelectedAndAnimate:(int)theSelected{
	
	if (theSelected != lastSelectedViewTag) {
		[self setSelected:theSelected];
		[self animateToSelected];
	}
	
}

- (void) configArrowsForSelection{
	
	if (lastSelectedViewTag >= [listViews.subviews count]) {
		nextArrow.hidden = YES;
	}
	else {
		nextArrow.hidden = NO;
	}
	
	if (lastSelectedViewTag == 1) {
		previousArrow.hidden = YES;
	}
	else {
		previousArrow.hidden = NO;
	}
}

- (void) selectNext{
	
	if (lastSelectedViewTag >= [listViews.subviews count]) {
		
	}
	else {
		[self setSelectedAndAnimate:lastSelectedViewTag+1];
		
	}
}

- (void) selectPrevious{
	if (lastSelectedViewTag == 1) {
		
	}
	else {
		
		[self setSelectedAndAnimate:lastSelectedViewTag-1];
	}
}

- (void) dealloc {
	selectionDelegate = nil;
	[listViews release];
	
	[super dealloc];
}

@end
