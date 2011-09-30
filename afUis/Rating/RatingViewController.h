//
//  RatingViewController.h
//  twitter test
//
//  Created by Mac Mini 1 MoMac on 09/07/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ratingViewDelegate;


@interface RatingViewController : UIViewController {
	
	UIImageView *firstStar;
	UIImageView *secondStar;
	UIImageView *thirdStar;
	UIImageView *fourthStar;
	UIImageView *fifthStar;
	
	int currentRating;
	
	id<ratingViewDelegate> myDelegate;
}

@property (nonatomic,retain) UIImageView *firstStar;
@property (nonatomic,retain) UIImageView *secondStar;
@property (nonatomic,retain) UIImageView *thirdStar;
@property (nonatomic,retain) UIImageView *fourthStar;
@property (nonatomic,retain) UIImageView *fifthStar;
@property (assign) int currentRating;
@property (assign) id<ratingViewDelegate> myDelegate;


-(id) initWithRating:(int)theRating;

-(void) updateViewWithRating:(int)theRating;

@end

@protocol ratingViewDelegate

@optional
-(void) ratingView:(RatingViewController *) ratingViewCon didRate:(int)rating;
-(void) ratingView:(RatingViewController *) ratingViewCon changedRate:(int)newRating;

@end