//
//  ImageSelectionDiscViewController.m
//  Disque
//
//  Created by adrien ferré on 26/05/10.
//  Copyright 2010 MoMac. All rights reserved.
//
#import "afDiscController.h"
#import "afMaths.h"
#import "ImageSelectionDiscConfig.h"

@implementation afDiscController

@synthesize disc, background;
@synthesize touchPoint, currentOrientation, discTouchedName, isDraging;

BOOL Debug = NO;

#pragma mark -
#pragma mark === Override ===
#pragma mark -

-(void) viewWillAppear:(BOOL)animated{
	self.navigationController.toolbar.hidden = YES;
	self.navigationController.navigationBarHidden = YES;
}

-(id) initWithDiscDataSource:(id)dataSource
			 andDiscDelegate:(id)del{
	
	if (self = [super init]) {
		
		afDisc *newDisc = [[afDisc alloc] initWithFrame:CGRectNull 
										  andDiscRadius:Disc_Radius
											andViewSize:CGSizeMake(Image_W, Image_H)
										  andViewRadius:(Disc_Radius - Image_H/2 - Margin_H/2)];
		
		if (dataSource) {
			newDisc.dataSource = dataSource;
		}
		else {
			newDisc.dataSource = self;
		}
		if (del) {
			newDisc.delegate = del;
		}
		else {
			newDisc.delegate = self;
		}
		
		disc = newDisc;
		//[newDisc release];
		
	}
	return self;
}

- (void) loadView {
	currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
	
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];   
	self.view.layer.name = @"V.O.D.";
	self.view.backgroundColor = [UIColor clearColor];
	
	background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BackgroundV]];
	[self.view addSubview:background];
	
	afDisc *newDisc = [[afDisc alloc] initWithFrame:CGRectNull 
									  andDiscRadius:Disc_Radius
										andViewSize:CGSizeMake(Image_W, Image_H)
									  andViewRadius:(Disc_Radius - Image_H/2 - Margin_H/2)];
	
	newDisc.dataSource = self;
	newDisc.delegate = self;
    
	[newDisc setupDiscWithImages];
	[self.view addSubview:newDisc];
	
    disc = newDisc;
	[newDisc release];
	
	[self performSelector:@selector(updateSelected) withObject:nil afterDelay:0.4];
}

#pragma mark -
#pragma mark === Disc delegate methods ===
#pragma mark -

-(void) afDisc:(afDisc *)theDisc selectedIndex:(NSInteger)theIndex{
	
	NSLog(@"afDisc selected index %d",theIndex);
	
}

#pragma mark -
#pragma mark === Disc data source delegate methods ===
#pragma mark -

-(NSInteger) numberOfItemsInDisc:(afDisc *)theDisc{
	return 5;	
}

-(UIImageView *)afDisc:(afDisc *)theDisc viewForIndex:(NSInteger)theIndex{
	NSString *theName = [NSString stringWithFormat: @"%d.png",theIndex];
	UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:theName]];
	theImageView.userInteractionEnabled = YES;
	
	return theImageView;
}

#pragma mark -
#pragma mark === Touch handling ===
#pragma mark -

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (Debug){
		
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@" touch Began");
		
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:self.view]; 
		
		point = [[touch view] convertPoint:point toView:nil];
		
		CALayer *layer = [(CALayer *)self.view.layer.presentationLayer hitTest:point];
		
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) {
			NSLog(@"%@**: layer touched is %@, superlayer is %@",self.view.layer.name,layer.name,layer.superlayer.name);
			NSLog(@"%@**: view touched is %@",self.view.layer.name,[touch view].layer.name);
		}
	}
	touchingDisc = NO;
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view]; 
	
	CALayer *layer = [(CALayer *)self.view.layer.presentationLayer hitTest:point];
	
	if ([layer.name hasPrefix:@"disc"]) touchingDisc = YES;
	else {
		int i=0;
		while (![layer.superlayer.name hasPrefix:@"disc"]) {
			layer = layer.superlayer;
			i++;
			if (i>5) return;
		}
		touchingDisc = YES;
		//discTouchedName = layer.superlayer.name;
	}
	
	touchPoint = point;
	isDraging = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *theTouch = [touches anyObject];
	if (Debug){
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@" touch Moved");
		
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:self.view]; 
		
		//point = [[touch view] convertPoint:point toView:nil];
		
		CALayer *layer = [(CALayer *)self.view.layer.presentationLayer hitTest:point];
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"%@**: layer touched is %@, superlayer is %@",self.view.layer.name,layer.name,layer.superlayer.name);
		
	}
	//if ([[theTouch view].layer.name isEqual:@"V.O.D."] || [[theTouch view].layer.name isEqual:@"TextView"] || [[theTouch view].layer.name isEqual:NULL]) return;
	//else if (theTouch.phase == UITouchPhaseMoved && [discTouchedName hasPrefix:@"disc"]) {
	else if (theTouch.phase == UITouchPhaseMoved && touchingDisc) {
		
		isDraging=YES;
		
		CGPoint newPoint = [theTouch locationInView:self.view];
		CGFloat newAngle;
		
		/*	if ([discTouchedName isEqual:@"disc"]) {
		 newAngle = [afMaths angleBetween: touchPoint and:newPoint andOrigin:disc.center];
		 [disc updateWithAngleStep:-[afMaths RadiansToDegrees:newAngle]];
		 }	
		 */
		newAngle = [afMaths angleBetween: touchPoint and:newPoint andOrigin:disc.center];
		[disc updateWithAngleStep:-[afMaths RadiansToDegrees:newAngle]];
		
		
		[self updateSelected];
		
		touchPoint = newPoint;	
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (Debug){
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@" touchEnded");
		/*CGPoint location = [[[event allTouches] anyObject] locationInView:self.view];
		 CALayer *hitLayer = [[self.view layer] hitTest:[self.view convertPoint:location fromView:nil]];	
		 NSLog(@"%@**: layer touched is %@, superlayer is %@",self.view.layer.name,hitLayer.name,hitLayer.superlayer.name);*/
		
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:[touch view]]; 
		point = [[touch view] convertPoint:point toView:nil];
		CALayer *layer = [(CALayer *)self.view.layer.presentationLayer hitTest:point];
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"%@**: layer touched is %@, superlayer is %@",self.view.layer.name,layer.name,layer.superlayer.name);
		
	}
	//	UITouch *touch = [touches anyObject];	
	
	if (! isDraging) {
		[self afDiscController:self didSelectIndex:[disc.highlightedImageName intValue]];
	}
	else if (touchingDisc) {
		//if ([discTouchedName isEqual:@"disc"]) {
			[disc animateToSelectedForOrientation:[UIApplication sharedApplication].statusBarOrientation];
		//}
	}	
}

#pragma mark -
#pragma mark === CAAnimation delegate ===
#pragma mark -

- (void) animationDidStart:(CAAnimation *)anim {
	
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	
	if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"Animation interrupted: %@", (!flag)?@"Yes" : @"No");
	/*if (flag) {
	 if (animatingForward) {
	 if (anim == [disc2.layer animationForKey:@"disc2Appearing"]) 
	 currentState = disc2Shown;
	 
	 else if (anim == [disc3.layer animationForKey:@"disc3Appearing"])
	 currentState = disc3Shown;	
	 }
	 else{
	 if (anim == [disc3.layer animationForKey:@"disc3Disappearing"]){
	 currentState = disc2Shown;
	 [self discDidRetract:3];
	 }
	 else if (anim == [disc2.layer animationForKey:@"disc2Disappearing"]){
	 currentState = disc1Shown;
	 [self discDidRetract:2];
	 }
	 }
	 self.view.userInteractionEnabled = YES;
	 
	 }*/
}

#pragma mark -
#pragma mark === Custom animations for the discs ===
#pragma mark -

- (void) transformAnimation:(CATransform3D) theTransform forLayer:(CALayer *) theLayer during:(CGFloat) duration withName:(NSString *)name {
	
	CABasicAnimation *animation		= [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.toValue				= [NSValue valueWithCATransform3D:theTransform];
	animation.fromValue				= [theLayer valueForKeyPath:@"transform"];
	animation.duration				= duration;
	animation.timingFunction		= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	animation.delegate				= self;
	animation.autoreverses			= NO;
	animation.removedOnCompletion	= NO;
	
	[theLayer setTransform:theTransform];
	
	[theLayer addAnimation:animation forKey:name];
}

#pragma mark -
#pragma mark === Misc ===
#pragma mark -

-(void) hideImages:(NSArray *) images{
	
	for (NSDictionary *dico in images)		
		((UIImageView *)[dico objectForKey:@"view"]).hidden = YES;
}

-(void) updateDrawnImagesForDisc{
	
	int count = [disc.data count];
	int selection = [disc.highlightedImageName intValue];
	NSArray *data = disc.data;
	
	if ( count < 5 ) return;
	if(selection == 0){
		((UIImageView *)[[data objectAtIndex:0] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:1] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:2] objectForKey:@"view"]).hidden = NO;
		
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		
		[theArrayOfHiddenImages removeObjectAtIndex:2];
		[theArrayOfHiddenImages removeObjectAtIndex:1];
		[theArrayOfHiddenImages removeObjectAtIndex:0];
		
		[self hideImages:theArrayOfHiddenImages];
	}
	else if(selection == 1)	{
		((UIImageView *)[[data objectAtIndex:0] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:1] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:2] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:3] objectForKey:@"view"]).hidden = NO;
		
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		
		[theArrayOfHiddenImages removeObjectAtIndex:3];
		[theArrayOfHiddenImages removeObjectAtIndex:2];
		[theArrayOfHiddenImages removeObjectAtIndex:1];
		[theArrayOfHiddenImages removeObjectAtIndex:0];
		
		[self hideImages:theArrayOfHiddenImages];
	}	
	else if(selection == 2)	{
		((UIImageView *)[[data objectAtIndex:0] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:1] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:2] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:3] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:4] objectForKey:@"view"]).hidden = NO;
		
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		
		[theArrayOfHiddenImages removeObjectAtIndex:4 ];
		[theArrayOfHiddenImages removeObjectAtIndex:3 ];
		[theArrayOfHiddenImages removeObjectAtIndex:2 ];
		[theArrayOfHiddenImages removeObjectAtIndex:1 ];
		[theArrayOfHiddenImages removeObjectAtIndex:0 ];
		
		[self hideImages:theArrayOfHiddenImages];
	}
	else if(selection == count - 3){
		((UIImageView *)[[data objectAtIndex:count-5] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-4] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-3] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-2] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-1] objectForKey:@"view"]).hidden = NO;
		
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		
		[theArrayOfHiddenImages removeObjectAtIndex:count - 1];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 2];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 3];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 4];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 5];
		
		[self hideImages:theArrayOfHiddenImages];
	}
	else if(selection == count - 2){
		((UIImageView *)[[data objectAtIndex:count-4] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-3] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-2] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-1] objectForKey:@"view"]).hidden = NO;
		
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		
		[theArrayOfHiddenImages removeObjectAtIndex:count - 1];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 2];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 3];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 4];
		
		[self hideImages:theArrayOfHiddenImages];
	}	
	else if(selection == count - 1)	{
		((UIImageView *)[[data objectAtIndex:count-3] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-2] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:count-1] objectForKey:@"view"]).hidden = NO;
		
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 1];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 2];
		[theArrayOfHiddenImages removeObjectAtIndex:count - 3];
		
		[self hideImages:theArrayOfHiddenImages];
	}
	else{
		NSMutableArray *theArrayOfHiddenImages = [[NSMutableArray alloc] initWithArray:data];
		/*
		 [theArrayOfHiddenImages removeObjectAtIndex:selection+2];
		 [theArrayOfHiddenImages removeObjectAtIndex:selection+1];
		 [theArrayOfHiddenImages removeObjectAtIndex:selection];
		 [theArrayOfHiddenImages removeObjectAtIndex:selection-1];
		 [theArrayOfHiddenImages removeObjectAtIndex:selection-2];
		 */
		[self hideImages:theArrayOfHiddenImages];
		
		((UIImageView *)[[data objectAtIndex:selection-2] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:selection-1] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:selection] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:selection+1] objectForKey:@"view"]).hidden = NO;
		((UIImageView *)[[data objectAtIndex:selection+2] objectForKey:@"view"]).hidden = NO;
	}
}

#pragma mark -
#pragma mark === Selection handling ===
#pragma mark -

/**
 According to the state of the discs (whether they are displayed or not), this function tells the current disc which images is currently displayed.
 */
- (void) updateSelected {
	
	CGFloat xBase;
	CGFloat yBase;
	afDisc *theDisc;
	
	//use hard value in order to save computing time
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
		xBase = disc.discCenter.x + disc.viewRadius * cosf(0);
		yBase = disc.discCenter.y + disc.viewRadius * sinf(0);
	}else {
		xBase = disc.discCenter.x + disc.viewRadius * cosf(M_PI/2);
		yBase = disc.discCenter.y + disc.viewRadius * sinf(M_PI/2);
	}
	
	theDisc = disc;
	CGPoint location = CGPointMake(xBase, yBase);
	location = [theDisc convertPoint:location toView:self.view];
	
	CALayer *hitLayer = [(CALayer *)self.view.layer.presentationLayer hitTest:location];
	
	if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"Disc: LAYER UNDER SELECTION IS %@",hitLayer.name);
	
	//if selection didn't change
	if (![hitLayer.name isEqual:@"V.O.D."] && ![hitLayer.name isEqual:@"disc"] ) {
		
		if ([theDisc.data count]==2) {
			if ([hitLayer.name intValue] == 1) {
				//is on last img
				theDisc.arrowUp.hidden = YES;
			}
			else if ([hitLayer.name intValue]==0) {
				//is on first img
				theDisc.arrowDown.hidden = YES;
			} 
		}
		else if ([theDisc.data count] == [hitLayer.name intValue] + 1) {
			//is on last img
			theDisc.arrowUp.hidden = YES;
		}
		else if ([hitLayer.name intValue]==0) {
			//is on first img
			theDisc.arrowDown.hidden = YES;
		} 
		else [theDisc showNavigationArrows:YES];
		
		
		if([theDisc setSelected:hitLayer.name]) {
			[self updateDrawnImagesForDisc];
			[self afDiscController:self selectionDidChange:[hitLayer.name intValue]];
			if ([theDisc.data count]==2) {
				if ([hitLayer.name intValue] == 1) {
					//is on last img
					theDisc.arrowUp.hidden = YES;
				}
				else if ([hitLayer.name intValue]==0) {
					//is on first img
					theDisc.arrowDown.hidden = YES;
				} 
			}
			else if ([theDisc.data count] == [hitLayer.name intValue] + 1) {
				//is on last img
				theDisc.arrowUp.hidden = YES;
			}
			else if ([hitLayer.name intValue]==0) {
				//is on first img
				theDisc.arrowDown.hidden = YES;
			} 
			else [theDisc showNavigationArrows:YES];
		}
	}
}

#pragma mark -
#pragma mark === "Delegate" functions ===
#pragma mark -

- (void) afDiscController:(afDiscController *)afDiscC
	   selectionDidChange:(int)aIndex {
	
}

- (void) afDiscController:(afDiscController *)afDiscC 
		   didSelectIndex:(int)aIndex {
	
}

#pragma mark -
#pragma mark === Orientation handling ===
#pragma mark -

/**
 Handle all interface orientation
 */
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;	
}

/**
 Using the one step orientation change handling. You might want to change to the 2 stes handling for better user experience.
 */
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	//if the next orientation is the same type as the current orientation, don't do anything
	if ( ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && UIInterfaceOrientationIsLandscape(currentOrientation) ) 
		|| ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && UIInterfaceOrientationIsPortrait(currentOrientation) ) ){
		return;
	}
	
	CGFloat deltaDisc1 = 0;
	
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		//replacing textview with its equivalent in the landscape orientation		
		[background setImage:[UIImage imageNamed:BackgroundH]];
		
		[disc handleOrientationChange:toInterfaceOrientation during:duration];
		
		CGRect frameDisc1 = disc.frame;
		
		//animate title and text view
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:duration];
		[background setFrame:CGRectMake(0, 0, 480, 320)];
		[disc setFrame:CGRectMake(-Disc_H + Image_W + Margin_W + (frameDisc1.origin.y - (Image_H + Margin_H - Disc_H)) + deltaDisc1,
								  -Disc_H/2 + 160 - 20,
								  Disc_H, Disc_H)];
		[UIView commitAnimations];
	}
	// from landscape to portrait
	else {
		[background setImage:[UIImage imageNamed:BackgroundV]];
		
		[disc handleOrientationChange:toInterfaceOrientation during:duration];
		
		CGRect frameDisc1 =  disc.frame;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:duration];
		[background setFrame:CGRectMake(0, 0, 320, 480)];
		[disc setFrame:CGRectMake(-Disc_H/2 + 160,
								  - Disc_H + Image_H + Margin_H + (frameDisc1.origin.x - (-Disc_H + Image_W + Margin_W)) - deltaDisc1,
								  Disc_H, Disc_H)];
		[UIView commitAnimations];
	}
	currentOrientation = toInterfaceOrientation;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	//NSLog(@"Did rotate from orientation %@ to %@",((fromInterfaceOrientation == UIInterfaceOrientationPortrait) ? @"portrait": @"landscape" ),
	//	  (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? @"landscape":@"portrait"));	
	
}

#pragma mark -
#pragma mark === Override ===
#pragma mark -

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc {
	[disc release];
	[background release];
    [super dealloc];
}

@end