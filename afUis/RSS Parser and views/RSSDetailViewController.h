//
//  RSSDetailViewController.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 20/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afSwipableView.h"

@protocol RSSDetailViewControllerDelegate;

enum afNetworkImageViewTransitionStyle {
	TransitionStyleFading = 0,
	TransitionStyleNone,
	TransitionStyleFlip,
	TransitionStyleCurl,
	TransitionStyleMoveIn,
	TransitionStylePush,
	TransitionStyleReveal
};

enum afNetworkImageViewTransitionSubtype {
	TransitionFromLeft = 0,
	TransitionFromRight,
	TransitionFromTop,
	TransitionFromBottom
};
@interface RSSDetailViewController : UIViewController <afSwipableViewDelegate,UIWebViewDelegate>{

	id<RSSDetailViewControllerDelegate> dataSource;
	
	UIBarButtonItem *leftButton;
	
	UIBarButtonItem *rightButton;
	
	UIToolbar *navButtons;
	
	int currentIndex; // from 0 to x
	
	BOOL transitioning;
	
	UIView *containerView;
	
	UISegmentedControl *seg;

	UIView *theDetailedView;
	
	UIView *theNextDetailedView;
}
@property (assign) BOOL transitioning;
@property (assign) int currentIndex;
@property (nonatomic,retain) NSDictionary *dico;
@property (nonatomic,retain) UISegmentedControl *seg;
@property (nonatomic,retain) UIToolbar *navButtons;
@property (nonatomic ,retain) UIBarButtonItem *leftButton;
@property (nonatomic ,retain) UIBarButtonItem *rightButton;
@property (nonatomic, assign) id<RSSDetailViewControllerDelegate> dataSource;
@property (nonatomic,retain) UIView *containerView;

-(UIView *) createDetailViewWithTitle:(NSString *)theTitle
					   andDescription:(NSString *)theDesc
						 andImageLink:(NSString *)theImgLink;

-(void) setArrowsForIndex:(int)index;
-(void) nextDetailedView;
-(void) previousDetailedView;
@end


@protocol RSSDetailViewControllerDelegate <NSObject>

-(int) detailViewDataSourceCount:(RSSDetailViewController *)theVC;
-(NSDictionary *) detailView:(RSSDetailViewController *)theVC 
				dataForIndex:(int)theI;

@end