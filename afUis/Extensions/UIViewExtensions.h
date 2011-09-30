//
//  afViewExt.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 20/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (UIViewExtensions)

- (BOOL) setupFlipTransitionBetweenGoing:(UIView *)goingAwayView 
							  andComing:(UIView *)comingView
				  andTranstitionSubType:(int)transSub
					  animationDelegate:(id) del
			   animationDidStopSelector:(SEL) didStopSel
								 during:(float)duration;

- (BOOL) setupTransitionBetweenGoing:(UIView *)goingAwayView 
						  andComing:(UIView *)comingView
				withTransitionStyle:(int)transStyle
			  andTranstitionSubType:(int)transSub
				  animationDelegate:(id) del
		   animationDidStopSelector:(SEL) didStopSel
							 during:(float)duration;

+ (UIView *) labelViewWithFrame:(CGRect) frame
					  withText:(NSString *) str
					   andFont:(UIFont *) theFont
				  andTextColor:(UIColor *) textColor
			  canUseScrollView:(BOOL)useScrollView
					 canResize:(BOOL)canResize;

@end
