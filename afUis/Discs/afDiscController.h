//
//  ImageSelectionDiscViewController.h
//  Disque
//
//  Created by adrien ferré on 26/05/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "afDisc.h"

@class afDisc;

@interface afDiscController : UIViewController <afDiscData,afDiscDelegate> {
	afDisc *disc;	/**< First disc.  */
	//////////////
	UIImageView *background;	/**< Background of the view. We need a reference to it because we need to handle the orientation changes, and therefor change this background. */
	//////////////
	CGPoint touchPoint;			/**< Used to store the current touch point. */
	BOOL isDraging;				/**< Used to figure out whether. */
	BOOL touchingDisc;
	NSString *discTouchedName;	/**< Used to store the current selection. */
	
	//////////////
	
	UIInterfaceOrientation currentOrientation; /**< Used to store the current orientation so that when rotating the device by 180 degrees (portrait to portrait, or landscape to landscape), nothing is done. */
}

//////////////
@property (nonatomic,retain) UIImageView *background;

@property (nonatomic,retain) afDisc *disc;
//////////////
@property (nonatomic,assign) CGPoint touchPoint;
@property (nonatomic,assign) NSString *discTouchedName;
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation;
//////////////
@property BOOL isDraging;
@property BOOL touchingDisc;

-(id) initWithDiscDataSource:(id)dataSource
			   andDiscDelegate:(id)del;

- (void) updateSelected;

- (void) afDiscController:(afDiscController *)afDiscC
	   selectionDidChange:(int)aIndex;

- (void) afDiscController:(afDiscController *)afDiscC 
		   didSelectIndex:(int)aIndex;

@end
