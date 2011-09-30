    //
//  RatingViewController.m
//  twitter test
//
//  Created by Mac Mini 1 MoMac on 09/07/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import "RatingViewController.h"


@implementation RatingViewController

@synthesize firstStar,secondStar,thirdStar,fourthStar,fifthStar,currentRating,myDelegate;


-(void) updateViewWithRating:(int)theRating{
	
	switch (theRating) {
		case 0:{
			[firstStar setHighlighted:NO];
			[secondStar setHighlighted:NO];
			[thirdStar setHighlighted:NO];
			[fourthStar setHighlighted:NO];
			[fifthStar setHighlighted:NO];
		}			
			break;
		case 1:{
			[firstStar setHighlighted:YES];
			[secondStar setHighlighted:NO];
			[thirdStar setHighlighted:NO];
			[fourthStar setHighlighted:NO];
			[fifthStar setHighlighted:NO];
		}		
			
			break;
		case 2:{
			[firstStar setHighlighted:YES];
			[secondStar setHighlighted:YES];
			[thirdStar setHighlighted:NO];
			[fourthStar setHighlighted:NO];
			[fifthStar setHighlighted:NO];
		}		
			
			break;
		case 3:{
			[firstStar setHighlighted:YES];
			[secondStar setHighlighted:YES];
			[thirdStar setHighlighted:YES];
			[fourthStar setHighlighted:NO];
			[fifthStar setHighlighted:NO];
		}		
			
			break;
		case 4:{
			[firstStar setHighlighted:YES];
			[secondStar setHighlighted:YES];
			[thirdStar setHighlighted:YES];
			[fourthStar setHighlighted:YES];
			[fifthStar setHighlighted:NO];
		}		
			
			break;
		case 5:{
			[firstStar setHighlighted:YES];
			[secondStar setHighlighted:YES];
			[thirdStar setHighlighted:YES];
			[fourthStar setHighlighted:YES];
			[fifthStar setHighlighted:YES];
		}		
			
			break;
		default:
			break;
	}
	
}

-(id) initWithRating:(int)theRating{

	if (self = [super init]) {
		currentRating = theRating;
	}
	return self;
}

-(void) validate{

	if (myDelegate !=NULL) [myDelegate ratingView:self didRate:currentRating];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIImage *starEmpty = [UIImage imageNamed:@"Star_Empty.png"];
	UIImage *starFilled = [UIImage imageNamed:@"Star_Filled.png"];
	
	UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	
	firstStar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, starEmpty.size.width, starEmpty.size.height)];
	[firstStar setImage:starEmpty];
	[firstStar setHighlightedImage:starFilled];
	firstStar.userInteractionEnabled = YES;
	
	secondStar = [[UIImageView alloc] initWithFrame:CGRectMake(firstStar.frame.origin.x + firstStar.frame.size.width, 20, starEmpty.size.width, starEmpty.size.height)];
	[secondStar setImage:starEmpty];
	[secondStar setHighlightedImage:starFilled];
	secondStar.userInteractionEnabled = YES;
	
	thirdStar = [[UIImageView alloc] initWithFrame:CGRectMake(secondStar.frame.origin.x + secondStar.frame.size.width,20, starEmpty.size.width, starEmpty.size.height)];
	[thirdStar setImage:starEmpty];
	[thirdStar setHighlightedImage:starFilled];
	thirdStar.userInteractionEnabled = YES;
	
	fourthStar = [[UIImageView alloc] initWithFrame:CGRectMake(thirdStar.frame.origin.x + thirdStar.frame.size.width, 20, starEmpty.size.width, starEmpty.size.height)];
	[fourthStar setImage:starEmpty];
	[fourthStar setHighlightedImage:starFilled];
	fourthStar.userInteractionEnabled = YES;
	
	fifthStar = [[UIImageView alloc] initWithFrame:CGRectMake(fourthStar.frame.origin.x + fourthStar.frame.size.width, 20, starEmpty.size.width, starEmpty.size.height)];
	[fifthStar setImage:starEmpty];
	[fifthStar setHighlightedImage:starFilled];
	fifthStar.userInteractionEnabled = YES;
	
	UIButton *rateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, firstStar.frame.origin.y + firstStar.frame.size.height, 40, 30)];
	[rateBtn setTitle:@"Rate" forState:UIControlStateNormal];
	[rateBtn addTarget:self action:@selector(validate) forControlEvents:UIControlEventTouchUpInside];
	[rateBtn setBackgroundColor:[UIColor blackColor]];
	rateBtn.titleLabel.textColor = [UIColor whiteColor];
	
	[theView addSubview:firstStar];
	[theView addSubview:secondStar];
	[theView addSubview:thirdStar];
	[theView addSubview:fourthStar];
	[theView addSubview:fifthStar];
	[theView addSubview:rateBtn];
	[rateBtn release];
	[self updateViewWithRating:currentRating];
	
	self.view = theView;
	[theView release];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view]; 
	
	int theCurrentRating;
	
	UIView *touchedView = [self.view hitTest:point withEvent:event];
	
	if ([touchedView isEqual:firstStar]) 
		theCurrentRating = 1;		
	
	else if ([touchedView isEqual:secondStar]) 
		theCurrentRating = 2;	
	
	else if ([touchedView isEqual:thirdStar]) 
		theCurrentRating = 3;	
	
	else if ([touchedView isEqual:fourthStar]) 
		theCurrentRating = 4;

	else if ([touchedView isEqual:fifthStar]) 
		theCurrentRating = 5;

	
	if (theCurrentRating!=currentRating) {
		if (myDelegate != NULL) 
			[myDelegate ratingView:self changedRate:theCurrentRating];
		
		currentRating = theCurrentRating ;
		[self updateViewWithRating:currentRating];
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view]; 
	
	int theCurrentRating;
	
	UIView *touchedView = [self.view hitTest:point withEvent:event];
	
	if ([touchedView isEqual:firstStar]) 
		theCurrentRating = 1;		
	
	else if ([touchedView isEqual:secondStar]) 
		theCurrentRating = 2;	
	
	else if ([touchedView isEqual:thirdStar]) 
		theCurrentRating = 3;	
	
	else if ([touchedView isEqual:fourthStar]) 
		theCurrentRating = 4;
	
	else if ([touchedView isEqual:fifthStar]) 
		theCurrentRating = 5;
	
	
	if (theCurrentRating!=currentRating) {
		if (myDelegate != NULL) 
			[myDelegate ratingView:self changedRate:theCurrentRating];
		
		currentRating = theCurrentRating ;
		[self updateViewWithRating:currentRating];
	}
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
