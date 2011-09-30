

#import "afDisc.h"
#import "afMaths.h"
#import "ImageSelectionDiscConfig.h"

@implementation afDisc

@synthesize discRadius,discCenter,viewRadius,viewSize;

@synthesize data, highlightedImageName, arrowUp, arrowDown,hasNavigationArrows;

@synthesize dataSource,delegate;

- (void)setViewRadiusForOrientation:(UIInterfaceOrientation) ori{
	/**< Radius to the circle to chich belong the centers of the images in portrait mode (anchor point (0.5,0.5))*/
	/**< Radius to the circle to chich belong the centers of the images in landscape mode (anchor point (0.5,0.5))*/
	
	if (UIInterfaceOrientationIsPortrait(ori)) {
		viewRadius = discRadius - viewSize.height/2 - Margin_H/2;
	}
	else {
		viewRadius = discRadius - viewSize.width/2 - Margin_H/2;
	}
}

#pragma mark -
#pragma mark === Disc init ===
#pragma mark -

/**
 Custom init.
 @param discNumber The disc number.
 @param aUIImageViews The images to be displayed.
 @param theFrame The frame the disc is init with.
 */
- (id) initWithFrame:(CGRect) theFrame 
	   andDiscRadius:(CGFloat) theRadius
		 andViewSize:(CGSize) theViewSize
	   andViewRadius:(CGFloat)theViewRadius{
	
	UIImage *discImage = [UIImage imageNamed:Disc1];
	
	if (self = [super initWithImage:discImage]){
		
		if (CGRectEqualToRect(theFrame, CGRectNull)) self.frame = CGRectMake(- theRadius + 160, - (theRadius * 2) + theViewSize.height + Margin_H, theRadius*2,theRadius*2);
		else self.frame = theFrame;
		
		viewSize = theViewSize;
		discRadius = theRadius;
		discCenter = CGPointMake(theRadius, theRadius);
		
		[self setViewRadiusForOrientation:[UIApplication sharedApplication].statusBarOrientation];
		
		self.userInteractionEnabled = YES;
		self.layer.anchorPoint = CGPointMake(0.5, 0.5);
		self.layer.name = @"disc";
		
		data = [[NSMutableArray alloc] init];
		//	[self setupDiscWithImages];
		
		if ([data count]>1) [self addNavigationArrows];
		arrowDown.hidden = YES;
	}
	
	return self;
}

-(void) reloadData{
	
}

/**
 Setup the disc with the iamges contained in data.
 */
- (void) setupDiscWithImages {
	
	CGFloat angleStep = 360.0/nbImagesOnDisc;
	CGFloat angle = 90.0;
	
	int theCount = 0;
	int counter = 0;
	
	int numberOfItems = [dataSource numberOfItemsInDisc:self];
	
	//for all images in imgArray, compute coordinates, anchor point and rotation and add them
	for (int i = 0; i < numberOfItems ; i++) {
		NSMutableDictionary *theDico;
		
		if (i + 1 > [data count]) {
			theDico = [[NSMutableDictionary alloc] init];
			NSString *theName = [NSString stringWithFormat:@"%d",i];
			UIView *theImageView = [dataSource afDisc:self viewForIndex:i];
			
			//UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat: @"%d.png",i]]];
			//theImageView.userInteractionEnabled = YES;
			theImageView.layer.name = theName;
			
			[theDico setObject:theImageView forKey:@"view"];
			[theDico setObject:theImageView.layer.name forKey:@"name"];
		
			[theImageView release];
			[data addObject:theDico];
			[theDico release];
		}
		
		theDico = [data objectAtIndex:i];
		
		UIImageView *imgView = [theDico objectForKey:@"view"];
		imgView.layer.anchorPoint = CGPointMake(0.5,0.5);
		
		CGFloat x = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		CGFloat y = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		
		[imgView.layer setValue:[NSValue valueWithCGPoint:CGPointMake(x, y)] 
					 forKeyPath:@"position"];
		//rotation
		[imgView.layer setValue:[NSNumber numberWithFloat:[afMaths DegreesToRadians: fmod(angle-90,360.0)]] 
					 forKeyPath:@"transform.rotation"];
		
		[theDico setObject:[NSNumber numberWithFloat: angle] forKey:@"currentRotation"];
		
		theCount = (([data count] < nbImagesOnDisc) ? [data count] : nbImagesOnDisc);
		if (counter > theCount-1) imgView.hidden = YES;
		counter ++;
		
		//adding to layer
		[self addSubview:imgView];
		
		angle -= angleStep;
		
	}
	
	[self bringSubviewToFront:arrowUp];
	[self bringSubviewToFront:arrowDown];
}

#pragma mark -
#pragma mark === Interface orientation handling ===
#pragma mark -

/**
 Handle all orientation changes. This is were you might want to implement other stuff when presenting a portrait or landscape view.
 @param toOrientation The orientation that the device will be in.
 @param duration The whole animation duration
 */
- (void) handleOrientationChange:(UIInterfaceOrientation) toOrientation 
						  during:(CGFloat) duration {
	
	CGFloat imagesRotationAngle;
	if (UIInterfaceOrientationIsPortrait(toOrientation)){
		imagesRotationAngle = 0.0;
	}
	else {
		imagesRotationAngle = 0;
	}
	
	[self animateToSelectedForOrientation:toOrientation];
	[self updateImagesPositionsForOrientation:toOrientation during:duration];
	[self rotateImagesBy:imagesRotationAngle during:duration];
	[self moveNavigationArrowsForOrientation:toOrientation];
}

/**
 Rotate the disc for orientation change. Deprecated since the iamges are drawn in different ways when in portrait or 
 landscape mode since an earlier version of this lib.
 @param rotAngle The angle of rotation.
 @param duration The animation duration.
 */
- (void) rotateDiscBy:(CGFloat) rotAngle 
			   during:(CGFloat) duration {
	
	self.layer.anchorPoint = CGPointMake(0.5, 0.5);
	CATransform3D rotation = CATransform3DRotate(self.layer.transform, rotAngle, 0.0, 0.0, 1.0);
	
	CABasicAnimation *imageRotation	= [CABasicAnimation animationWithKeyPath:@"transform"];
	imageRotation.fromValue			= [self.layer valueForKeyPath:@"transform"];
	imageRotation.toValue			= [NSValue valueWithCATransform3D:rotation];
	imageRotation.duration			= duration;
	imageRotation.timingFunction	= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	imageRotation.delegate			= self;
	imageRotation.autoreverses		= NO;
	
	[self.layer setValue:[NSValue valueWithCATransform3D:rotation] forKeyPath:@"transform"];
	
	[self.layer addAnimation:imageRotation forKey:@"transform"];
}

/**
 Update the postions (centers with anchorpoint (0.5:0.5)) of the images.
 @param toInterfaceOrientation The orientation of the device.
 @param duration The animation duration.
 */
- (void) updateImagesPositionsForOrientation:(UIInterfaceOrientation) toInterfaceOrientation 
									  during:(CGFloat) duration {
	
	[self setViewRadiusForOrientation:toInterfaceOrientation];
	
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
	{
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"updating position for portrait orientation");
		
	}else {
		
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"updating position for landscape orientation");
		
	}
	for (NSMutableDictionary *dictionary in data) {
		CGFloat angle = [[dictionary objectForKey:@"currentRotation"] floatValue]; 
		CGFloat x = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		CGFloat y = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		
		UIImageView *imgView = [dictionary objectForKey:@"view"];
		imgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		
		CABasicAnimation *imageTranslation	= [CABasicAnimation animationWithKeyPath:@"position"];
		imageTranslation.fromValue			= [NSValue valueWithCGPoint:imgView.layer.position];
		imageTranslation.toValue			= [NSValue valueWithCGPoint:CGPointMake(x,y)];
		imageTranslation.duration			= duration;
		imageTranslation.timingFunction	    = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
		imageTranslation.delegate			= self;
		imageTranslation.autoreverses		= NO;
		
		[imgView.layer setValue:[NSValue valueWithCGPoint:CGPointMake(x,y)] forKeyPath:@"position"];
		
		[imgView.layer addAnimation:imageTranslation forKey:@"position"];
	}
}

/**
 Roate all iamges on the disc.
 @param rotAngle The angle of rotation.
 @param duration The animation duration.
 */
- (void) rotateImagesBy:(CGFloat) rotAngle 
				 during:(CGFloat) duration {
	
	for (NSMutableDictionary *dictionary in data) {
		CGFloat angle = [[dictionary objectForKey:@"currentRotation"] floatValue];
		UIImageView *imgView = [dictionary objectForKey:@"view"];
		imgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		CATransform3D rotation = CATransform3DRotate(imgView.layer.transform, rotAngle, 0.0, 0.0, 1.0);
		
		CABasicAnimation *imageRotation	= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		imageRotation.fromValue			= [imgView.layer valueForKeyPath:@"transform.rotation"];
		imageRotation.toValue			= [NSNumber numberWithFloat:[[imgView.layer valueForKeyPath:@"transform.rotation"] floatValue]  + rotAngle];
		imageRotation.duration			= duration;
		imageRotation.timingFunction	= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
		imageRotation.delegate			= self;
		imageRotation.autoreverses		= NO;
		
		angle = angle + [afMaths RadiansToDegrees:rotAngle];
		
		[dictionary setObject:[NSNumber numberWithFloat:fmod(angle,360.0)] forKey:@"currentRotation"];
		
		[imgView.layer setValue:[NSValue valueWithCATransform3D:rotation] forKeyPath:@"transform"];
		
		[imgView.layer addAnimation:imageRotation forKey:@"transform"];
	}
}

#pragma mark -
#pragma mark === Disc updating, drawing ===
#pragma mark -

/**	
 Used for rotation with touch. 
 @param angleStep the angle in degrees to rotate
 */ 
- (void) updateWithAngleStep:(CGFloat) angleStep {
	
	[self setViewRadiusForOrientation:[UIApplication sharedApplication].statusBarOrientation];
	
	CGFloat angleForOrientation;
	if( UIInterfaceOrientationIsPortrait( [UIApplication sharedApplication].statusBarOrientation)){
		angleForOrientation = - 90.0;
		
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"current orientation is portrait !!!");
		
	}
	else {
		
		if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"current orientation is landscape!!!");
		
		angleForOrientation = 0.0;
	}
	
	for (NSMutableDictionary *dictionary in data) {
		
		UIImageView *imgView = [dictionary objectForKey:@"view"];
		
		CGFloat angle = [[dictionary objectForKey:@"currentRotation"] floatValue];
		
		angle -= angleStep;
		
		imgView.layer.anchorPoint = CGPointMake(0.5,0.5);
		
		CGFloat x = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		CGFloat y = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		[imgView.layer setPosition:CGPointMake(x,y)];
		
		[imgView.layer setValue:[NSNumber numberWithFloat:[afMaths DegreesToRadians: fmod(angle+angleForOrientation,360.0)]]
					 forKeyPath:@"transform.rotation"];
		[dictionary setObject:[NSNumber numberWithFloat:fmod(angle,360.0)] forKey:@"currentRotation"];	
	}
}

/**	
 Used for animating the rotation. 
 @param orientation The current orientation. 
 @param angleStep The angle in degrees to rotate.
 */ 
- (void) animateImagesForOrientation:(UIInterfaceOrientation) orientation 
							withStep:(CGFloat) angleStep {
	
	[self setViewRadiusForOrientation:orientation];
	
	CGFloat angleForOrientation;
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		angleForOrientation = -90;
	}else {
		angleForOrientation = 0.0;
	}
	for (NSMutableDictionary *dictionary in data) {
		
		UIImageView *imgView = [dictionary objectForKey:@"view"];
		
		CGFloat angle = fmod([[dictionary objectForKey:@"currentRotation"] floatValue] + 360,360);
		
		if ([imgView.layer.name isEqual:self.highlightedImageName] && TARGET_IPHONE_SIMULATOR)
			if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"Rotation angle of selected image is %f",angle);
		
		CGMutablePathRef curvedPath = CGPathCreateMutable();
		
		if (angleStep <0.0) {
			CGPathAddArc(curvedPath,NULL,discCenter.x,discCenter.y,
						 viewRadius,[afMaths DegreesToRadians:fmod(angle,360.0)],
						 [afMaths DegreesToRadians: fmod(angle-angleStep,360.0)], NO);
		}
		else if (angleStep>0.0)	{
			CGPathAddArc(curvedPath,NULL,discCenter.x,discCenter.y,
						 viewRadius,[afMaths DegreesToRadians:fmod(angle,360.0)],
						 [afMaths DegreesToRadians: fmod(angle-angleStep,360.0)], YES);
		}
		angle -= angleStep;
		
		//position animation
		CAKeyframeAnimation *posAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		posAnimation.path = curvedPath;
		CGPathRelease(curvedPath);
		posAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
		[posAnimation setAutoreverses:NO];
		
		//rotation animation
		CABasicAnimation *rotAnimation	= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		rotAnimation.fromValue			= [NSNumber numberWithFloat:[afMaths DegreesToRadians: fmod(angle+angleStep+angleForOrientation,360.0)]];
		rotAnimation.toValue			= [NSNumber numberWithFloat:[afMaths DegreesToRadians: fmod(angle+angleForOrientation,360.0)]];
		rotAnimation.timingFunction		= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
		[rotAnimation setAutoreverses:NO];
		
		//saving rotation
		if ([imgView.layer.name isEqual:self.highlightedImageName] && TARGET_IPHONE_SIMULATOR)
			if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"New rotation angle of selected image is %f",angle);
		
		[dictionary setObject:[NSNumber numberWithFloat:fmod(angle,360.0)] forKey:@"currentRotation"];
		
		//grouping animations
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
		[group setAnimations:[NSArray arrayWithObjects:posAnimation, rotAnimation, nil]];
		group.duration = 0.3;
		group.delegate = self;
		[group setAutoreverses:NO];
		[group setValue:imgView forKey:@"imageViewBeingAnimated"];
		
		[imgView.layer setValue:[NSNumber numberWithFloat:[afMaths DegreesToRadians: fmod(angle+angleForOrientation,360.0)]]
					 forKeyPath:@"transform.rotation"];
		
		CGFloat x = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		CGFloat y = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: fmod(angle,360.0)]);
		
		[imgView.layer setValue:[NSValue valueWithCGPoint:CGPointMake(x, y)] 
					 forKeyPath:@"position"];
		
		//launch them
		[imgView.layer addAnimation:group forKey:@"rotatingAnimation"];		
	}
}

/**	
 Used for animating to the center of the currently selected image. 
 */ 
- (void) animateToSelectedForOrientation:(UIInterfaceOrientation) interfaceOrientation {
	CGFloat angle;
	
	[self setViewRadiusForOrientation:interfaceOrientation];
	
	if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
		angle = 90.0;
	}else {
		angle = 0.0;
	}
	//compute angle beetwen selected image and selection center
	CGFloat xSelection =  discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: angle]);
	CGFloat ySelection =  discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: angle]);
	CGPoint point;
	
	for (NSMutableDictionary *dico in data)
		if ([[dico objectForKey:@"name"] isEqual:highlightedImageName]) {
			if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"last image selected is %@", ((UIImageView *)[dico objectForKey:@"view"]).layer.name);
			CALayer *theLayer = [(UIImageView *)[dico objectForKey:@"view"] layer];
			theLayer.anchorPoint = CGPointMake(0.5,0.5);
			point = theLayer.position;
		}
	
	CGPoint selectionPoint = CGPointMake(xSelection, ySelection);
	
	CGFloat rotationAngle = [afMaths RadiansToDegrees:
							 [afMaths angleBetween:selectionPoint 
											   and:point 
										 andOrigin:CGPointMake(discCenter.x, discCenter.y)]];
	
	if(DEBUGIMAGESELECTIONDISK && TARGET_IPHONE_SIMULATOR) NSLog(@"Rotation angle is : %f",rotationAngle);
	
	[self animateImagesForOrientation:interfaceOrientation withStep:rotationAngle];
}

#pragma mark -
#pragma mark === Selection updating ===
#pragma mark -

- (BOOL) setSelected:(NSString *)name {
	
	if ([name isEqual:highlightedImageName] || name==nil || 
		[name isEqual:@""] || [name isEqual:self.layer.name]) 
		return FALSE;
	
	highlightedImageName=name;
	
	return TRUE;
}

#pragma mark -
#pragma mark === CAAnimation delegate ===
#pragma mark -

- (void) animationDidStart:(CAAnimation *)anim {
	
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	
}

#pragma mark -
#pragma mark === Navigation arrows handling ===
#pragma mark -

/**
 Add the navigation arrows. This is for allowing the user to choose between dragging or tapping his way into the lists of images.
 The navigation arrows are always kept instantiated, but can be hidden with showNavigationArrows:.
 */
- (void) addNavigationArrows{
	
	CGFloat xUp = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: fmod(90-15,360.0)]);
	CGFloat yUp = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: fmod(90-15,360.0)]);
	
	UIImage *img = [UIImage imageNamed:@"vod_nav.png"];
	
	arrowUp = [[UIImageView alloc] initWithImage:img];
	arrowUp.layer.anchorPoint = CGPointMake(0.5, 0.5);
	arrowUp.center = CGPointMake(xUp, yUp);
	arrowUp.userInteractionEnabled = YES;
	arrowUp.transform = CGAffineTransformRotate(arrowUp.transform, [afMaths DegreesToRadians: -15]);
	arrowUp.layer.name = @"ArrowUp";
	
	CGFloat xDown = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: fmod(90+15,360.0)]);
	CGFloat yDown = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: fmod(90+15,360.0)]);
	
	arrowDown = [[UIImageView alloc] initWithImage:img];
	arrowDown.userInteractionEnabled = YES;
	arrowDown.layer.anchorPoint = CGPointMake(0.5, 0.5);
	arrowDown.center = CGPointMake(xDown, yDown);
	arrowDown.transform = CGAffineTransformRotate(arrowDown.transform, [afMaths DegreesToRadians:180 + 15]);
	arrowDown.layer.name = @"ArrowDown";
	
	[self addSubview:arrowUp];
	[self addSubview:arrowDown];
}

/**
 Fuction used to show or hide the navigation arrows.
 @param showIt YES when showing the arrows, NO when hiding them.
 */
- (void) showNavigationArrows:(BOOL) showIt{
	arrowUp.hidden = !showIt;
	arrowDown.hidden = !showIt;	
}

/**
 Function used to place the navigation arrows correctly when the device orientation changes
 @param theOrientation The orientation to be displayed.
 */
- (void) moveNavigationArrowsForOrientation:(UIInterfaceOrientation) theOrientation{
	
	CGFloat angleForOrientationUp;
	CGFloat angleForOrientationDown;
	
	CGAffineTransform theUpTransform = CGAffineTransformIdentity;
	CGAffineTransform theDownTransform = CGAffineTransformIdentity;
	
	[self setViewRadiusForOrientation:theOrientation];
	
	if (UIInterfaceOrientationIsPortrait(theOrientation)) {
		angleForOrientationUp = 90 - 15;
		angleForOrientationDown = 90 + 15;
		theUpTransform = CGAffineTransformRotate(theUpTransform, [afMaths DegreesToRadians: -15]);
		theDownTransform = CGAffineTransformRotate(theDownTransform, [afMaths DegreesToRadians:180 + 15]);
	}else {
		angleForOrientationUp = - 15;
		angleForOrientationDown = + 15;
		theUpTransform = CGAffineTransformRotate(theUpTransform, [afMaths DegreesToRadians: 180 + 90 - 15]);
		theDownTransform = CGAffineTransformRotate(theDownTransform, [afMaths DegreesToRadians: 90 + 15]);
	}
	
	CGFloat xUp = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: angleForOrientationUp]);
	CGFloat yUp = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: angleForOrientationUp]);
	
	arrowUp.layer.anchorPoint = CGPointMake(0.5, 0.5);
	arrowUp.center = CGPointMake(xUp, yUp);
	
	arrowUp.transform = theUpTransform;
	
	CGFloat xDown = discCenter.x + viewRadius * cosf([afMaths DegreesToRadians: angleForOrientationDown]);
	CGFloat yDown = discCenter.y + viewRadius * sinf([afMaths DegreesToRadians: angleForOrientationDown]);
	
	arrowDown.layer.anchorPoint = CGPointMake(0.5, 0.5);
	arrowDown.center = CGPointMake(xDown, yDown);
	
	arrowDown.transform = theDownTransform;
}

#pragma mark -
#pragma mark === Touch handling ===
#pragma mark -

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([[touch view].layer.name isEqual:@"ArrowUp"]){
		
	}
	else if ([[touch view].layer.name isEqual:@"ArrowDown"]){
		
	}
	else [super touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([[touch view].layer.name isEqual:@"ArrowUp"]){
		
	}
	else if ([[touch view].layer.name isEqual:@"ArrowDown"]){
		
	}
	else [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([[touch view].layer.name isEqual:@"ArrowUp"]){
		[self animateImagesForOrientation:[UIApplication sharedApplication].statusBarOrientation withStep:-20];	
		
		
	}
	else if ([[touch view].layer.name isEqual:@"ArrowDown"]){
		[self animateImagesForOrientation:[UIApplication sharedApplication].statusBarOrientation withStep:20];
		
	}
	else [super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark === Override ===
#pragma mark -

- (void) dealloc{
	
	if (data != nil) [data release];
	[arrowUp release];
	[arrowDown release];
	
	[super dealloc];
}

@end