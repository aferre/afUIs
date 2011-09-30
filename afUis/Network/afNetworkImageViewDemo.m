//
//  afNetworkImageViewDemo.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 05/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afNetworkImageViewDemo.h"
#import "afNetworkImageView.h"

@implementation afNetworkImageViewDemo

@synthesize imgArray;

-(id)init{

	if (self = [super init]) {
		self.title = @"afNetworkImageDemo";
	}
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) ];
	
	UIImage *defImage = [UIImage imageNamed:@"1.png"];
	
	afNetworkImageView *i1 = [[afNetworkImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100) 
																 andDefaultImage:defImage 
																andURL:[NSURL URLWithString:@"http://olof92.free.fr/fichiers/bm-voiture.jpg"] 
																 
															  andTransitionStyle:TransitionStyleFlip 
															 andTranstionSubtype:TransitionFromLeft];
	i1.backgroundColor = [UIColor blueColor];
	
	afNetworkImageView *i2 = [[afNetworkImageView alloc] initWithFrame:CGRectMake(110, 10, 100, 100) 
																 andDefaultImage:defImage 
																		  andURL:[NSURL URLWithString:@"http://olof92.free.fr/fichiers/bm-voiture.jpg"] 
																   
															  andTransitionStyle:TransitionStyleFading 
															 andTranstionSubtype:TransitionFromBottom];
	
	afNetworkImageView *i3 = [[afNetworkImageView alloc] initWithFrame:CGRectMake(220, 10, 100, 100) 
																 andDefaultImage:defImage 
																		  andURL:[NSURL URLWithString:@"http://pulsmail.com/~wallpaper/data/media/31/fond_d_ecran_voiture_de_course_40.jpg"]
															
															  andTransitionStyle:TransitionStyleMoveIn
															 andTranstionSubtype:TransitionFromBottom];
	
	afNetworkImageView *i4 = [[afNetworkImageView alloc] initWithFrame:CGRectMake(10, 110, 100, 100) 
																 andDefaultImage:defImage 
																		  andURL:[NSURL URLWithString:@"http://www.creanum.fr/Portals/0/Tutoriels/2008_anterieur/voiture_toon/27.jpg"] 
																   
															  andTransitionStyle:TransitionStylePush 
															 andTranstionSubtype:TransitionFromRight];
	
	afNetworkImageView *i5 = [[afNetworkImageView alloc] initWithFrame:CGRectMake(110, 110, 100, 100) 
																 andDefaultImage:defImage 
																		  andURL:[NSURL URLWithString:@"http://www.villiard.com/blog/wp-content/uploads/2007/03/voiture-futur.jpg"] 
																   
															  andTransitionStyle:TransitionStyleReveal 
															 andTranstionSubtype:TransitionFromTop];
	
	afNetworkImageView *i6 = [[afNetworkImageView alloc] initWithFrame:CGRectMake(220, 110, 100, 100) 
																 andDefaultImage:defImage 
																		  andURL:[NSURL URLWithString:@"http://www.luxury-club.fr/images/location-voiture-de-luxe-ferrari-porsche-lamborghini.jpg"] 
																  
															  andTransitionStyle:TransitionStyleNone 
															 andTranstionSubtype:TransitionFromBottom];
	
	imgArray = [[NSArray alloc] initWithObjects:i1,i2,i3,i4,i5,i6,nil];
	
	for (afNetworkImageView *i in imgArray) {
		[theView addSubview:i];
		[i queueRequest];
	}
	
	self.view = theView;
	[theView release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[imgArray release];
    [super dealloc];
}


@end
