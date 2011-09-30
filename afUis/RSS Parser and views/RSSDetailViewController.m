//
//  RSSDetailViewController.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 20/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSDetailViewController.h"
#import "afStringExt.h"
#import <QuartzCore/QuartzCore.h>
#import "afSwipableView.h"

@implementation RSSDetailViewController

@synthesize dico,transitioning;
@synthesize navButtons, rightButton, leftButton, dataSource,currentIndex,containerView,seg;

#pragma mark -
#pragma mark == Init ==
#pragma mark -

- (id) initWithIndex:(int)theI{
	
	if (self = [super init]) {
		currentIndex = theI;
	}
	return self;
}

- (id) init{
	
	if (self = [super init]) {
		currentIndex = 0;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// create a toolbar to have two buttons in the right
	if (!navButtons) {
		UIImage *rightImage = [UIImage imageNamed:@"article_next.png"];
		UIImage *leftImage = [UIImage imageNamed:@"article_back.png"];
		
		navButtons = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, leftImage.size.width + rightImage.size.width + 25, rightImage.size.height)];
		//navButtons.autoresizesSubviews = YES;
		
		seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:leftImage,rightImage,nil]];
		seg.segmentedControlStyle = 
		seg.momentary = YES;
		[seg addTarget:self
				action:@selector(action:)
	  forControlEvents:UIControlEventValueChanged];
		
		UIImageView *arrowRight = [[[UIImageView alloc] initWithImage:rightImage] autorelease];
		arrowRight.userInteractionEnabled = YES;
		
		UIBarButtonItem *bb = [[UIBarButtonItem alloc] initWithCustomView:seg];
		UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:arrowRight];
		
		NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
		
		
		[buttons addObject:b];
		[buttons addObject:bb];
		
		// stick the buttons in the toolbar
		[navButtons setItems:buttons animated:NO];
		
		[buttons release];
		
		// and put the toolbar in the nav bar
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButtons];
	}
	
	NSDictionary *theDico = [dataSource detailView:self 
									  dataForIndex:currentIndex];
	
	self.title = [theDico objectForKey:@"title"];
	
	theDetailedView = [self createDetailViewWithDico:theDico];
	
	UIView *theV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, theDetailedView.frame.size.width,theDetailedView.frame.size.height)];
	
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, theDetailedView.frame.size.width,theDetailedView.frame.size.height)];
	[containerView addSubview:theDetailedView];
	
	[theV addSubview:containerView];
	
	self.view = theV;
	
	[theV release];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	//[self setArrowsForIndex:currentIndex];
	
}

#pragma mark -
#pragma mark == SegmentControl ==
#pragma mark -

-(void) action:(UISegmentedControl *)sseg{
	UIImage *rightImage = [UIImage imageNamed:@"article_next.png"];
	UIImage *leftImage = [UIImage imageNamed:@"article_back.png"];
	
	if (sseg.selectedSegmentIndex >= 0 && !transitioning) {
		
		UIImage *img = [seg imageForSegmentAtIndex:sseg.selectedSegmentIndex];
		
		if ([img isEqual:rightImage]) {
			[self nextDetailedView];
		}
		else if ([img isEqual:leftImage]) {
			[self previousDetailedView];
		}		
	}
}

-(void) setArrowsForIndex:(int)index{
	
	int i = [dataSource detailViewDataSourceCount:self];
	
	UIImage *rightImage = [UIImage imageNamed:@"article_next.png"];
	UIImage *leftImage = [UIImage imageNamed:@"article_back.png"];
	
	if (i == 1) {
		while (seg.numberOfSegments != 0) {
			[seg removeSegmentAtIndex:0 animated:YES];
		}	
		//leftButton.enabled = NO;
		//rightButton.enabled = NO;
		return;
	}
	else if (index >= i - 1) {
		
		if (seg.numberOfSegments == 2) {
			
			UIImage *img = [seg imageForSegmentAtIndex:1];
			
			if ([img isEqual:rightImage]) {
				[seg removeSegmentAtIndex:1 animated:YES];
			}
			
		}
		else if (seg.numberOfSegments == 1){
			
			UIImage *img = [seg imageForSegmentAtIndex:0];
			
			if ([img isEqual:rightImage]) {
				[seg removeSegmentAtIndex:0 animated:YES];
				[seg insertSegmentWithImage:leftImage atIndex:0 animated:YES];
			}
		}
		else if (seg.numberOfSegments == 0){
			[seg insertSegmentWithImage:leftImage atIndex:0 animated:YES];
		}
		//rightButton.enabled = NO;
	}
	else if (index == 0) {
		if (seg.numberOfSegments == 2) {
			UIImage *img = [seg imageForSegmentAtIndex:0];
			
			if ([img isEqual:leftImage]) {
				[seg removeSegmentAtIndex:0 animated:YES];
			}
		}
		else if (seg.numberOfSegments == 1){
			
			UIImage *img = [seg imageForSegmentAtIndex:0];
			if ([img isEqual:rightImage]) {
				
			}
			else if ([img isEqual:leftImage]) {
				[seg removeSegmentAtIndex:0 animated:YES];
			}
		}
		else if (seg.numberOfSegments ==0){
			[seg insertSegmentWithImage:rightImage atIndex:0 animated:YES];
		}
		//leftButton.enabled = NO;
	}
	else{
		
		if (seg.numberOfSegments == 2) {
			
		}
		else if (seg.numberOfSegments == 1){
			
			UIImage *img = [seg imageForSegmentAtIndex:0];
			if ([img isEqual:rightImage]) {
				[seg insertSegmentWithImage:leftImage atIndex:0 animated:YES];
			}
			else if ([img isEqual:leftImage]) {
				[seg insertSegmentWithImage:rightImage atIndex:1 animated:YES];
			}
		}
		else if (seg.numberOfSegments == 0){
			[seg insertSegmentWithImage:rightImage atIndex:0 animated:YES];
			[seg insertSegmentWithImage:leftImage atIndex:0 animated:YES];
		}
	}
	
	
}

-(void) performFlipTransitionBetween:(UIView *)goingAwayView 
								 and:(UIView *)comingView
						 inContainer:(UIView *)theContainer
			   andTranstitionSubType:(int)transSub{
	
	[UIView beginAnimations:nil context:NULL]; 
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	
	switch (transSub) {
		case TransitionFromLeft:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:theContainer cache:YES];
			break;
		case TransitionFromRight:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:theContainer cache:YES];
			break;
		default:
			break;
	}
	
	[goingAwayView removeFromSuperview];   
	[theContainer addSubview:comingView];
	[UIView commitAnimations];
}

-(void)performTransitionBetween:(UIView *)goingAwayView 
							and:(UIView *)comingView
					inContainer:(UIView *)theContainerView
			withTransitionStyle:(int)transStyle
		  andTranstitionSubType:(int)transSub{
	
	transitioning = YES;
	
	if (transStyle == TransitionStyleFlip) {
		[self performFlipTransitionBetween:goingAwayView
									   and:comingView 
							   inContainer:theContainerView
					 andTranstitionSubType:transSub];
		return;
	}
	else if (transStyle == TransitionStyleCurl){
		
		return;
	}
	else if (transStyle == TransitionStyleNone){
		
		return;
	}
	
	comingView.hidden = YES;
	[theContainerView addSubview:comingView];
	
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.75;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	switch (transStyle) {
		case TransitionStyleFading:
			transition.type = kCATransitionFade;
			break;
		case TransitionStyleMoveIn:
			transition.type = kCATransitionMoveIn;
			break;
		case TransitionStylePush:
			transition.type = kCATransitionPush;
			break;
		case TransitionStyleReveal:
			transition.type = kCATransitionReveal;
			break;
		default:
			break;
	}
	switch (transSub) {
		case TransitionFromBottom:
			transition.subtype = kCATransitionFromBottom;
			break;
		case TransitionFromRight:
			transition.subtype = kCATransitionFromRight;
			break;
		case TransitionFromLeft:
			transition.subtype = kCATransitionFromLeft;
			break;
		case TransitionFromTop:
			transition.subtype = kCATransitionFromTop;
			break;
		default:
			break;
	}
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[theContainerView.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	comingView.hidden = NO;
	goingAwayView.hidden = YES;
}

-(void)animationDidStop:(CAAnimation *)theAnimation 
			   finished:(BOOL)flag{
	transitioning = NO;
	
	theDetailedView = nil;
	
	theDetailedView = theNextDetailedView;
	
	//theNextDetailedView = nil;
	
}

#pragma mark -
#pragma mark == WebView delegate == 
#pragma mark -

- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType{
	
	/*NSURL *url = request.URL;
	 
	 LetudiantAppDelegate *appDel = (LetudiantAppDelegate *)[UIApplication sharedApplication].delegate;
	 DeclareWebViewController_Phone *wv = [[DeclareWebViewController_Phone alloc] initWithNibName:@"DeclareWebViewController_Phone" bundle:nil];
	 
	 wv.url = url;
	 
	 [wv.webView loadRequest:[NSURLRequest requestWithURL:url]];
	 
	 [appDel.theTabBarController presentModalViewController:wv animated:YES];
	 */
	return NO;
}

-(NSString *)formatedDescription:(NSString *)description {
	static NSString *descriptionFormat = @"<html><head><meta name=\"viewport\" content=\"width=300\"/></head><body>%@</body></html>";
	return [NSString stringWithFormat:descriptionFormat,description];
}


#pragma mark -
#pragma mark == Navigation ==
#pragma mark -

-(void) setupForNewIndex:(int)index{
	transitioning = YES;
	currentIndex = index;
	int transition;
	if (index < currentIndex) 
		transition = TransitionFromLeft;
	else transition = TransitionFromRight;
	
	NSLog(@"Current index is %d",currentIndex);
	
	NSDictionary *theDico = [dataSource detailView:self 
									  dataForIndex:currentIndex];
	
	self.title = [theDico objectForKey:@"title"];
	
	[self setArrowsForIndex:currentIndex];
	
	//swipe right				
	theNextDetailedView = [self createDetailViewWithDico:theDico];
	
	[self performTransitionBetween:theDetailedView 
							   and:theNextDetailedView 
					   inContainer:containerView 
			   withTransitionStyle:TransitionStyleMoveIn
			 andTranstitionSubType:transition];
}

-(void) nextDetailedView{
	
	int newIndex = currentIndex + 1;
	
	int i = [dataSource detailViewDataSourceCount:self];
	
	if (newIndex >= i ) 
		NSLog(@"no can do");
	else [self setupForNewIndex:currentIndex + 1];
}

-(void) previousDetailedView{
	int newIndex = currentIndex - 1;
	
	if (newIndex < 0) 
		NSLog(@"no can do");
	else [self setupForNewIndex:currentIndex - 1];
}

#pragma mark -
#pragma mark == View Creation ==
#pragma mark -

-(UIView *) createDetailViewWithDico:(NSDictionary *)theDico{
	
	NSString *theDesc = [theDico objectForKey:@"description"];	
	
	NSString *theDate = [NSString stringFromDate:[theDico objectForKey:@"pubDate"]
							 withLocalIdentifier:@"fr_FR"
								   andDateFormat:@"dd/MM/yyyy"];		
	
	NSString *theTitle = [NSString stringWithFormat:@"%@ - le %@",[theDico objectForKey:@"title"],theDate];	
	
	NSString *theImgLink = [theDico objectForKey:@"imageLink"];
	
	return [self createDetailViewWithTitle:theTitle
							andDescription:theDesc 
							  andImageLink:theImgLink];
}

-(UIView *) createDetailViewWithTitle:(NSString *)theTitle
					   andDescription:(NSString *)theDesc
						 andImageLink:(NSString *)theImgLink{
	
	CGRect frame = CGRectMake(0, 0, 320, 480);
	
	UIView *theView = [[UIView alloc] initWithFrame:frame];
	
	UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 	frame.size.height)];
	[bgView setBackgroundColor:[UIColor whiteColor]];
	bgView.layer.opacity = .7;
	bgView.userInteractionEnabled = YES;
	[theView addSubview:bgView];
	[bgView release];
	
	afSwipableView *theSV = [[afSwipableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	theSV.theDelegate = self;
	
	CGSize s = [theTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16] 
					constrainedToSize:CGSizeMake(290, 2000.0f)
						lineBreakMode:UILineBreakModeWordWrap];
	
	UILabel *theTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 290, s.height)];
	[theTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
	[theTitleLabel setNumberOfLines:0];
	[theTitleLabel setBackgroundColor:[UIColor clearColor]];
	[theTitleLabel setTextColor:[UIColor blackColor]];
	[theTitleLabel setText:theTitle];
	[theTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	theTitleLabel.userInteractionEnabled = YES;
	
	UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, s.height + 5, frame.size.width, frame.size.height - s.height - 5)];
	
	[theWebView loadHTMLString:[self formatedDescription:theDesc] 
					   baseURL:[NSURL URLWithString:@""]];
	
	theWebView.delegate = self;
	
	/*
	 KwImageView *theImage;
	 UILabel *theTextView;
	 
	 CGSize descSize = [theDesc sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] 
	 constrainedToSize:CGSizeMake(280, 2000.0f)
	 lineBreakMode:UILineBreakModeWordWrap];
	 
	 if (theImgLink != nil) {
	 theImage = [[KwImageView alloc] initWithFrame:CGRectMake(5,theTitleLabel.frame.size.height + theTitleLabel.frame.origin.y + 5,290,150)
	 andShowStyle:KWUIImageShowStyleNone 
	 andDefaultImage:@"Icon.png"];
	 theImage.shouldResize = NO;
	 theImage.myBaseURL = theImgLink;
	 theImage.myBaseDirectory = @"ImagesRSS";
	 theImage.myImageFile = [theImgLink lastPathComponent] ;
	 
	 [theImage fillImage];
	 [theImage loadImage];
	 
	 [theSV addSubview:theImage];
	 theTextView = [[UILabel alloc] initWithFrame:CGRectMake(10, theImage.frame.origin.y + theImage.frame.size.height + 5, 280, descSize.height)];
	 [theImage release];
	 }
	 else theTextView = [[UILabel alloc] initWithFrame:CGRectMake(10, theTitleLabel.frame.origin.y + theTitleLabel.frame.size.height + 5, 280, descSize.height)];
	 
	 [theTextView setLineBreakMode:UILineBreakModeWordWrap];
	 [theTextView setNumberOfLines:0];
	 [theTextView setBackgroundColor:[UIColor clearColor]];
	 [theTextView setTextColor:[UIColor blackColor]];
	 [theTextView setText:theDesc];
	 theTextView.userInteractionEnabled = YES;
	 [theTextView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	 
	 [theSV addSubview:theTitleLabel];
	 [theTitleLabel release];
	 
	 [theSV addSubview:theTextView];
	 [theTextView release];
	 [theSV setContentSize:CGSizeMake(frame.size.width, theTextView.frame.size.height + theTextView.frame.origin.y)];
	 */
	
	[theSV addSubview:theTitleLabel];
	[theTitleLabel release];
	
	[theSV addSubview:theWebView];
	[theWebView release];
	
	[theView addSubview:theSV];
	[theSV release];
	
	return theView;
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
