//
//  EtudiantNavBar.m
//  Etudiant
//
//  Created by adrien ferré on 14/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EtudiantNavBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation EtudiantNavBar

@synthesize backButton, titleLabel, modifyButton,subtitleLabel,rightLabel,logoImage;

-(id) init{

	UIImage *theImage = [UIImage imageNamed:@"header.png"];
	
	if (self = [super initWithFrame:CGRectMake(0, 0, theImage.size.width, theImage.size.height)]){
		
		UIImageView *bgView = [[UIImageView alloc] initWithImage:theImage];
		
		bgView.userInteractionEnabled = YES;
		
		[self addSubview:bgView];
		[bgView release];
		
		backButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 6, 69, 32)];
		[backButton setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
		[self addSubview:backButton];
		
		modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(238, 4, 72, 37)];
		[modifyButton setImage:[UIImage imageNamed:@"Modify.png"] forState:UIControlStateNormal];
		[self addSubview:modifyButton];
		
		subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 0, 165, 44)];
		subtitleLabel.numberOfLines = 2;
		subtitleLabel.textAlignment = UITextAlignmentCenter;
		subtitleLabel.adjustsFontSizeToFitWidth = YES;
		subtitleLabel.minimumFontSize = 10;
		subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		subtitleLabel.backgroundColor = [UIColor clearColor];
		subtitleLabel.textColor = [UIColor whiteColor];
		subtitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		[self addSubview:subtitleLabel];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(79, 0, 165, 45)];
		titleLabel.numberOfLines = 1;
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.minimumFontSize = 10;
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		[self addSubview:titleLabel];
		
		rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 175 , 0, 165, self.frame.size.height-3)];
		rightLabel.numberOfLines = 1;
		rightLabel.textAlignment = UITextAlignmentRight;
		rightLabel.adjustsFontSizeToFitWidth = YES;
		rightLabel.minimumFontSize = 10;
		rightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		rightLabel.backgroundColor = [UIColor clearColor];
		rightLabel.textColor = [UIColor whiteColor];
		rightLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		[self addSubview:rightLabel];
		
		UIImage *logo = [UIImage imageNamed:@"nav_logo.png"];
		logoImage = [[UIImageView alloc] initWithImage:logo];
		logoImage.frame = CGRectMake(5, 5, logo.size.width * 8.5/10.0, logo.size.height* 8.5/10.0);
		logoImage.center = CGPointMake((logo.size.width * 8.5/10.0)/2 + 5, (self.frame.size.height - 3) / 2);
		logoImage.hidden = YES;
		[self addSubview:logoImage];
	}
	return self;
	
}

-(void)showModifyButton:(BOOL)showIt animated:(BOOL)animated{
	
	if (animated) {
		
		CABasicAnimation *theAnimation;
		
		theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
		theAnimation.duration=0.5;
		theAnimation.autoreverses=NO;
		theAnimation.removedOnCompletion=NO;
		theAnimation.fillMode = kCAFillModeBackwards;
		if (showIt) {
			theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
			theAnimation.toValue=[NSNumber numberWithFloat:1.0];
			[modifyButton.layer setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"opacity"];
		}
		else {
			theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
			theAnimation.toValue=[NSNumber numberWithFloat:0.0];
			[modifyButton.layer setValue:[NSNumber numberWithFloat:0.0] forKeyPath:@"opacity"];
		}
		
		[modifyButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
		
	}
	else {
		if (showIt) {
			modifyButton.layer.opacity = 1;
		}
		else {
			modifyButton.layer.opacity = 0;
		}
	}

}


-(void)showBackButton:(BOOL)showIt animated:(BOOL)animated{

	if (animated) {
	
		CABasicAnimation *theAnimation;
		
		theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
		theAnimation.duration=0.5;
		theAnimation.autoreverses=NO;
		theAnimation.removedOnCompletion=NO;
		theAnimation.fillMode = kCAFillModeBackwards;
		if (showIt) {
			theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
			theAnimation.toValue=[NSNumber numberWithFloat:1.0];
		[backButton.layer setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"opacity"];
		}
		else {
			theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
			theAnimation.toValue=[NSNumber numberWithFloat:0.0];
		[backButton.layer setValue:[NSNumber numberWithFloat:0.0] forKeyPath:@"opacity"];
		}

		[backButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
		
	}
	else {
		if (showIt) {
			backButton.layer.opacity = 1;
		}
		else {
			backButton.layer.opacity = 0;
		}
	}
}

- (void)dealloc {
    [super dealloc];
	
	[backButton release];
	
	[modifyButton release];
	
	[titleLabel release];
	
	[subtitleLabel release];
	
	[logoImage release];
	
	[rightLabel release];
}


@end
