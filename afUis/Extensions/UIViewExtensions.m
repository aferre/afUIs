//
//  afViewExt.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 20/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIViewExtensions.h"

@implementation UIView (UIViewExtensions)

#pragma mark -
#pragma mark == ==
#pragma mark -

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

/*!
 @function
 @abstract		Constructor for a width constrained label, possibly scrollable.
 @discussion	If useScrollView is YES, the label will be contained in a scrollview only if its frame 
				size with the font exceeds the width of the frame given as a parameter.
				If resize is YES, the label's font will be sized down in order to fit the label to the frame given as parameter.
				You can't use both yet, and the scroll view is used by default if it is YES (that means if both canUseScrollView 
				and canResize are YES, you will be returned a scroll view).
 @param			frame	The frame of the label.
 @param			str		The label's text.
 @param			theFont The Font of the label.
 @param			textColor The label's color.
 @param			useScrollView Boolean value used to know whether the label can be displayed inside a scrollview.
 @param			resize Boolean value to know whether the label font can be sized down in order to be displayed.
 @result		Returns either a UILabel or a UIScrollView object with the label inside.
 */
+(UIView *) labelViewWithFrame:(CGRect) frame
					  withText:(NSString *) str
					   andFont:(UIFont *) theFont
				  andTextColor:(UIColor *) textColor
			  canUseScrollView:(BOOL)useScrollView
					 canResize:(BOOL)canResize{
	
	CGFloat width = frame.size.width;
	
	CGSize s = [str sizeWithFont:theFont
			   constrainedToSize:CGSizeMake(width, 10000) 
				   lineBreakMode:UILineBreakModeWordWrap];
	
	UIScrollView *theScrollView;
	
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.textColor = textColor;
	textLabel.userInteractionEnabled = YES;
	textLabel.font = theFont;
	textLabel.text = str;
	textLabel.numberOfLines = 0;
	
	if (s.height > frame.size.height) {
		if (useScrollView) {
			theScrollView = [[UIScrollView alloc] initWithFrame:frame];
			[theScrollView setShowsVerticalScrollIndicator:NO];
			
			textLabel.frame = CGRectMake(0, 0, width , s.height);
			
			[theScrollView addSubview:textLabel];
			[textLabel release];
			
			[theScrollView setContentSize:CGSizeMake(width, s.height)];
			return [theScrollView autorelease];
		}
		else if (canResize){
			int i = theFont.pointSize;
			
			while (s.height > frame.size.height) {
				i --;
				s = [str sizeWithFont:[UIFont fontWithName:theFont.fontName size:i]
					constrainedToSize:CGSizeMake(width,10000)
						lineBreakMode:UILineBreakModeWordWrap];		
			}
			
			textLabel.frame = CGRectMake(frame.origin.x,frame.origin.y, 
										 width, 
										 frame.size.height);
			return [textLabel autorelease];
		}
	}
	
	textLabel.frame = frame;
	
	return [textLabel autorelease];
}

/*!
 @function
 @abstract		Used on a container view to flip between two views.
 @discussion	Used on a container view to flip between two views.
 @param			goingAwayView The view which needs to be hidden.
 @param			comingView The view to be displayed.
 @param			transSub	The transition subtype (left or right).
 @param			del		The delegate of the animation.
 @param			didStopSel The selector which handles the end of the animation in case it's not a flip.
 @param			duration The duration of the animation.
 @result		Returns Yes if transtioning, No if not.
 */

- (BOOL) setupFlipTransitionBetweenGoing:(UIView *)goingAwayView 
							   andComing:(UIView *)comingView
				   andTranstitionSubType:(int)transSub
					   animationDelegate:(id) del
				animationDidStopSelector:(SEL) didStopSel
								  during:(float)duration{
	
	[UIView beginAnimations:nil context:NULL]; 
	[UIView setAnimationDelegate:del];
	[UIView setAnimationDidStopSelector:@selector(didStopSel)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:duration];
	
	switch (transSub) {
		case TransitionFromLeft:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
			break;
		case TransitionFromRight:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
			break;
		default:
			return NO;
			break;
	}
	
	[goingAwayView removeFromSuperview];   
	
	[self addSubview:comingView];
	
	[UIView commitAnimations];
	
	return YES;
}

/*!
 @function
 @abstract		Used on a container view to transition betwwen two views.
 @discussion	Used on a container view to transition betwwen two views.
 @param			goingAwayView The view which needs to be hidden.
 @param			comingView The view to be displayed.
 @param			transStyle	The transition type, see afNetworkImageViewTransitionStyle.
 @param			transSub	The transition subtype, see afNetworkImageViewTransitionSubtype.
 @param			del		The delegate of the animation.
 @param			didStopSel The selector which handles the end of the animation in case it's not a flip.
 @param			duration The duration of the animation.
 @result		Returns Yes if transtioning, No if not.
 */

- (BOOL) setupTransitionBetweenGoing:(UIView *)goingAwayView 
						   andComing:(UIView *)comingView
				 withTransitionStyle:(int)transStyle
			   andTranstitionSubType:(int)transSub
				   animationDelegate:(id) del
			animationDidStopSelector:(SEL) didStopSel
							  during:(float)duration{
	
	if (transStyle == TransitionStyleFlip) {
		return [self setupFlipTransitionBetweenGoing:goingAwayView
										   andComing:comingView
							   andTranstitionSubType:transSub
								   animationDelegate:del
							animationDidStopSelector:didStopSel
											  during:duration];
		
	}
	else if (transStyle == TransitionStyleCurl){
		
		return NO;
	}
	else if (transStyle == TransitionStyleNone){
		
		return NO;
	}
	
	comingView.hidden = YES;
	[self addSubview:comingView];
	
	CATransition *transition = [CATransition animation];
	
	transition.duration = duration;
	
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
			return NO;
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
			return NO;
			break;
	}
	transition.delegate = del;
	
	[self.layer addAnimation:transition forKey:nil];
	
	comingView.hidden = NO;
	goingAwayView.hidden = YES;
	
	return YES;
}



@end
