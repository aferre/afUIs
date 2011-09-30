//
//  afNetworkImageView.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "afASIHTTPRequest.h"

@protocol afNetworkImageViewDelegate;

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

@interface afNetworkImageView : UIView <afASIHTTPRequestDelegate>{
	
	UIView *containerView; /*<Used for animation */
	UIImageView *defaultImageView;
	UIImageView *loadedImageView;
	
	id<afNetworkImageViewDelegate> delegate;
	
	NSURL *currentURL;
	
	UIActivityIndicatorView *loadingAI;
	
	BOOL loaded;
	
	int transitionStyle;
	int transitionSubtype;
	BOOL transitioning;
}

@property (nonatomic,assign) BOOL loaded;
@property (nonatomic,assign) BOOL transitioning;
@property (nonatomic,assign) int transitionStyle;
@property (nonatomic,assign) int transitionSubtype;
@property (nonatomic,retain) UIView *containerView;
@property (nonatomic,retain) UIImageView *defaultImageView;
@property (nonatomic,retain) UIImageView *loadedImageView;
@property (nonatomic,assign) id<afNetworkImageViewDelegate> delegate;
@property (assign) NSURL *currentURL;
@property (nonatomic,retain) UIActivityIndicatorView *loadingAI;

- (id)initWithFrame:(CGRect)frame
	andDefaultImage:(UIImage *)theImage
			 andURL:(NSURL *)theURL
 andTransitionStyle:(int)theTransitionStyle
andTranstionSubtype:(int)theTransitionSubtype;

-(void)performFlipTransitionBetween:(UIView *)goingAwayView 
and:(UIView *)comingView
inContainer:(UIView *)theContainer;

-(void)performTransitionBetween:(UIView *)goingAwayView and:(UIView *)comingView;

-(void)queueRequest;

@end


@protocol afNetworkImageViewDelegate <NSObject>

@optional
-(void)afNetworkImageViewDidFinishLoading:(afNetworkImageView *)afNetImgView;
-(void)afNetworkImageViewDidStartLoading:(afNetworkImageView *)afNetImgView;
-(void)afNetworkImageViewLoadingFailed:(afNetworkImageView *)afNetImgView;
@end