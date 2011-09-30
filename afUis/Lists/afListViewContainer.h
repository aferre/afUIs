//
//  afListViewContainer.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afListView.h"

typedef enum afListViewStyle {
	PageControl=0,
	Title,
	PageControl_Title,
	PageControl_Title_Subtitle,
	Title_Subtitle,
	None
} afListViewStyle;

@protocol afListViewContainerDelegate;

@interface afListViewContainer : UIView <afListViewDataSource, afListViewSelectionDelegate>{
	
	id<afListViewContainerDelegate> delegate;
	
	afListView *theListView;
	
	UILabel *theTitle;
	UILabel *theSubtitle;
	UIPageControl *thePageControl;
	
	BOOL hasTitle;
	BOOL hasSubtitle;
	BOOL hasPageControl;
	
	afListViewStyle style;
}

@property (assign) id<afListViewContainerDelegate> delegate;
@property (assign) afListViewStyle style;
@property (assign) BOOL hasTitle;
@property (assign) BOOL hasSubtitle;
@property (assign) BOOL hasPageControl;
@property (nonatomic,retain) afListView *theListView;
@property (nonatomic,retain) UILabel *theTitle;
@property (nonatomic,retain) UILabel *theSubtitle;
@property (nonatomic,retain) UIPageControl *thePageControl;
@property (nonatomic,retain) NSMutableArray *pageControls;

- (id)initWithFrame:(CGRect)frame
	andListViewSize:(CGSize)listViewSize;

- (id) initWithOrigin:(CGPoint)origin
	  andListViewSize:(CGSize)listViewSize
			 andStyle:(afListViewStyle)s;

-(CGFloat) computeViewHeightForStyle:(afListViewStyle) s;

@end

@protocol afListViewContainerDelegate

@optional 
-(NSString *) afListViewContainer:(afListViewContainer *)ls 
					titleForIndex:(int)index;
-(NSString *) afListViewContainer:(afListViewContainer *)ls 
			subtitletitleForIndex:(int)index;
@end