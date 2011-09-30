//
//  afNetworkImageView.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afNetworkImageView.h"
#import "afASIQueue.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewExtensions.h"

@implementation afNetworkImageView

@synthesize currentURL,loadingAI,delegate,defaultImageView,loadedImageView,containerView;
@synthesize loaded;
@synthesize transitioning, transitionStyle,transitionSubtype;

- (id)initWithFrame:(CGRect)frame
	andDefaultImage:(UIImage *)theImage
			 andURL:(NSURL *)theURL
 andTransitionStyle:(int)theTransitionStyle
andTranstionSubtype:(int)theTransitionSubtype{
    
	if ((self = [super initWithFrame:frame])) {
		
		self.opaque = YES;
		self.layer.masksToBounds = YES;
		
		loaded = NO;
		
		transitionStyle = theTransitionStyle;
		transitionSubtype = theTransitionSubtype;
		
		currentURL = theURL;
		
		containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		
		defaultImageView = [[UIImageView alloc] initWithImage:theImage];
		defaultImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		defaultImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[containerView addSubview:defaultImageView];
		
		[self addSubview:containerView];
		
		loadingAI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loadingAI.hidesWhenStopped = YES;
		loadingAI.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		[self addSubview:loadingAI];
	}
    
	return self;
}

/*
 -(void) performFlipTransitionBetween:(UIView *)goingAwayView 
 and:(UIView *)comingView
 inContainer:(UIView *)theContainer
 andTranstitionSubType:(int)transSub{
 
 [UIView beginAnimations:nil context:NULL]; 
 [UIView setAnimationDelegate:self];
 [UIView setAnimationDidStopSelector:@selector(questionAnimationEnded)];
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
 transitioning = YES;
 transition.delegate = self;
 
 // Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
 [theContainerView.layer addAnimation:transition forKey:nil];
 
 // Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
 comingView.hidden = NO;
 goingAwayView.hidden = YES;
 }
 */

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(void)queueRequest{
	
	afASIHTTPRequest *theReq = [afASIHTTPRequest requestWithURL:currentURL];
	[theReq setTheDelegate:self];
	[theReq setTimeOutSeconds:10];
	
	[[afASIQueue sharedafASIQueue] addNetworkOperation:theReq];
}

-(void)requestStarted:(afASIHTTPRequest *)theRequest{
	NSLog(@"image start loading");
	
	if (delegate != NULL && 
		[delegate respondsToSelector:@selector(afNetworkImageViewDidStartLoading:)]) {
		[delegate afNetworkImageViewDidStartLoading:self];
	}
	
	[loadingAI startAnimating];
}

-(void)requestFinished:(afASIHTTPRequest *)theRequest{
	NSLog(@"image finished loading");
	
	loaded = YES;
	
	if (delegate != NULL && 
		[delegate respondsToSelector:@selector(afNetworkImageViewDidFinishLoading:)]) {
		[delegate afNetworkImageViewDidFinishLoading:self];
	}
	
	UIImage *theImage = [UIImage imageWithData:[theRequest responseData]];
	[loadingAI stopAnimating];
	if (!loadedImageView) {
		loadedImageView = [[UIImageView alloc] initWithImage:theImage];
		loadedImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		loadedImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	transitioning = [containerView setupTransitionBetweenGoing:defaultImageView 
													 andComing:loadedImageView 
										   withTransitionStyle:transitionStyle 
										 andTranstitionSubType:transitionSubtype 
											 animationDelegate:self 
									  animationDidStopSelector:nil 
														during:0.5];  
}

-(void)requestFailed:(afASIHTTPRequest *)theRequest{
	NSLog(@"image loading failed");
	
	if (delegate != NULL && [delegate respondsToSelector:@selector(afNetworkImageViewLoadingFailed:)]) {
		[delegate afNetworkImageViewLoadingFailed:self];
	}
	
	[loadingAI stopAnimating];
}

- (void)dealloc {
	delegate = nil;
	[currentURL release];
	[loadingAI release];
	[super dealloc];
}
@end