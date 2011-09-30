//
//  afMultiDiscController.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class afDiscController;
@protocol afDiscControllerSelectionDelegate;


@interface afMultiDiscController : UIViewController {
	
}

@end

@protocol afDiscControllerSelectionDelegate



@optional

-(void) afMultiDiscController:(afMultiDiscController *)afMultiDiscC
			  discWillRetract:(int)discNumber;

-(void) afMultiDiscController:(afMultiDiscController *)afMultiDiscC
			   discWillAppear:(int)discNumber;

-(void) afMultiDiscController:(afMultiDiscController *)afMultiDiscC
			   discDidRetract:(int)discNumber;

-(void) afMultiDiscController:(afMultiDiscController *)afMultiDiscC
				discDidAppear:(int)discNumber;

@end