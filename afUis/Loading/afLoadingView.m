//
//  afLoadingView.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 05/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afLoadingView.h"


@implementation afLoadingView

@synthesize notConnectedLabel,loadingAI,loadingLabel,loadingProgressView;

-(id)initWithFrame:(CGRect)theFrame
andConnectionToNetwork:(BOOL)hasNetwork{
	
	if (self = [super initWithFrame:theFrame]) {
	
	}
	return self;
}

-(void) startLoading{
	
}

-(void) stopLoading{
	
}

-(void) showNotConnectedLabel:(BOOL) showIt{
	
	NSString *str = @"Vous n'êtes pas connecté à Internet.";
	if (!notConnectedLabel && showIt) {
		notConnectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
		notConnectedLabel.text = str;
		notConnectedLabel.backgroundColor = [UIColor clearColor];
		notConnectedLabel.textColor = [UIColor blackColor];
		notConnectedLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
		notConnectedLabel.numberOfLines = 0;
		notConnectedLabel.lineBreakMode = UILineBreakModeWordWrap;
		notConnectedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:notConnectedLabel];
	}
	else if (showIt) [self addSubview:notConnectedLabel];
	else if (notConnectedLabel && !showIt) [notConnectedLabel removeFromSuperview];
}

-(void) showLoadingView:(BOOL)showIt{
	if (!loadingAI && showIt) {
		loadingAI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loadingAI.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
		[self addSubview:loadingAI];
		
		[loadingAI startAnimating];
	}
	else if (showIt) {
		[self addSubview:loadingAI];
		
		[loadingAI startAnimating];
	}
	else if (loadingAI && !showIt) {
		[loadingAI stopAnimating];
		[loadingAI removeFromSuperview];
	}
}

- (void)dealloc {
    [super dealloc];
	if (notConnectedLabel) [notConnectedLabel release];
	if (loadingAI) {
		[loadingAI release];
	}
}

@end