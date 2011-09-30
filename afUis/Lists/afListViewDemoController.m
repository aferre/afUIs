    //
//  afListViewDemo.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afListViewDemoController.h"
#import "afListViewContainer.h"
#import "afVerticalListView.h"
#import "afListViewTime.h"

@implementation afListViewDemoController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
    if ((self = [super init])) {
        // Custom initialization
    }
    return self;
}

- (int) numberOfItems:(afListView *)listView{
	return 25;
}

- (UIView *) listView:(afListView *)listView viewForIndex:(int)theIndex{
	UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",theIndex]];
	UIImageView *iv = [[UIImageView alloc] initWithImage:img];
	iv.userInteractionEnabled = YES;
	return [iv autorelease];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	UIView *theV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	
	afListViewContainer *first = [[afListViewContainer alloc] initWithOrigin:CGPointMake(0, 0)
															andListViewSize:CGSizeMake(320, 75)
																	andStyle:PageControl_Title_Subtitle];
	
	[theV addSubview:first];
	
	afVerticalListView *third = [[afVerticalListView alloc] initWithFrame:CGRectMake(0, first.frame.origin.y + first.frame.size.height, 100, 200)
															andDataSource:self
															 hasNavArrows:YES];
	[theV addSubview:third];
	
	afListViewTime *time = [[afListViewTime alloc] initWithFrame:CGRectMake(0 ,third.frame.origin.y + third.frame.size.height, 320, 100)];
	
	[theV addSubview:time];
	[first release];
	
	[third release];
	
	self.view = theV;
	
	[theV release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
