//
//  afListView.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "afStackedView.h"
#define Image_Width 95
#define Image_Height Image_Width
#define Margin 3

#define QList_Margin_Y 5
#define Not_Selected_Opacity 0.25
#define QList_Transition_Time 0.3
@protocol afListViewSelectionDelegate;
@protocol afListViewDataSource;

@interface afListView : UIView {

	id<afListViewSelectionDelegate> selectionDelegate;
	
	id<afListViewDataSource> dataSource;
	
	afStackedView *listViews;
	
	CGPoint touchPoint;
	
	BOOL isTouchingImage;
	
	int lastSelectedViewTag;
	
	BOOL hasMoved;
	
	BOOL hasNavArrows;
	
	UIButton *previousArrow;
	
	UIButton *nextArrow;
}

@property (assign) BOOL hasMoved;
@property (assign) BOOL hasNavArrow;
@property (nonatomic,retain) UIButton *previousArrow;
@property (nonatomic,retain) UIButton *nextArrow;
@property (nonatomic,retain) afStackedView *listViews;
@property (assign) CGPoint touchPoint;
@property (assign) int lastSelectedViewTag;
@property (assign) BOOL isTouchingImage;
@property (assign) id<afListViewSelectionDelegate> selectionDelegate;
@property (assign) id<afListViewDataSource> dataSource;

- (id)initWithFrame:(CGRect)theFrame
	  andDataSource:(id)theDataSource
	   hasNavArrows:(BOOL)hasArrows;

- (void) setSelectedAndAnimate:(int)theSelected;

- (void) setSelected:(int)theSelected;

- (void) configArrowsForSelection;

- (void) reloadData;

- (int) selectedViewTag;

- (void) selectNext;

- (void) selectPrevious;

@end

@protocol afListViewSelectionDelegate <NSObject>

@optional
- (void) isUnderSelection:(int)index;
- (void) selectedIndex:(int)theQuizzIndex;
- (void) hasBeenSelectedByUser:(NSString *)theID;
- (void) clicked;

@end

@protocol afListViewDataSource <NSObject>

- (int) numberOfItems:(afListView *)listView;
- (UIView *) listView:(afListView *)listView viewForIndex:(int)theIndex;

@end