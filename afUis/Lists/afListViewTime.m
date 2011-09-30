//
//  afListViewTime.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afListViewTime.h"

#import <QuartzCore/QuartzCore.h>

/*
 *	Parameters to tweak layout and animation behaviors
 */

#define SPREADIMAGE			0.1		// spread between images (screen measured from -1 to 1)
#define FLANKSPREAD			0.4		// flank spread out; this is how much an image moves way from center
#define FRICTION			10.0	// friction
#define MAXSPEED			10.0	// throttle speed to this value

@implementation afListViewTime

@synthesize listView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        listView = [[afHorizontalStackedView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) 
												   andWidthMargin:5 andHeightMargin:5];
		
		for (int i = 0; i < 10; i ++) {
			UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
			UIImageView *v = [[UIImageView alloc] initWithImage:img];
			v.tag = i + 1;
			v.userInteractionEnabled = YES;
			[listView addSubview:v];
			[v release];
		}
		[self addSubview:listView];
    }
    return self;
}

/*- (void)draw
{
	/*
	 *	Change from Alesandro Tagliati <alessandro.tagliati@gmail.com>:
	 *	We don't need to draw all the tiles, just the visible ones. We guess
	 *	there are 6 tiles visible; that can be adjusted by altering the 
	 *	constant
	 */
	
	//pour ttes vues dans listview.subviews
	//
	
	/*int i,len = [listView.subviews count];
	
	
	int mid = (int)floor(offset + 0.5);
	
	int iStartPos = mid - VISTILES;
	
	if (iStartPos<0) {
		iStartPos=0;
	}
	
	for (i = iStartPos; i < mid; ++i) {
		[self drawTile:i atOffset:i-offset];
	}
	
	int iEndPos = mid + VISTILES;
	
	if (iEndPos >= len) {
		iEndPos = len-1;
	}
	for (i = iEndPos; i >= mid; --i) {
		[self drawTile:i atOffset:i-offset];
	}
	
}

- (void)draw {
    // Drawing code
	
}*/

/************************************************************************/
/*																		*/
/*	Animation															*/
/*																		*/
/************************************************************************/

- (void)updateAnimationAtTime:(double)elapsed{
	
	if (elapsed > runDelta) elapsed = runDelta;
	
	double delta = fabs(startSpeed) * elapsed - FRICTION * elapsed * elapsed / 2;
	
	if (startSpeed < 0) delta = -delta;
	
	NSLog(@"delta = %f",delta);
	
	for (UIView *v in listView.subviews) {
		CGPoint f = v.center;
		f.x += delta - lastDelta;
		v.center = f;
	}
	
	/*offset = startOff + delta;
	
	if (offset > max) offset = max;
	if (offset < 0) offset = 0;
	*/
	
	//[self draw];
	
	lastDelta = delta;
}

- (void)endAnimation
{
	if (timer) {
		/*int max = [listView.subviews count] - 1;
		offset = floor(offset + 0.5);
		if (offset > max) offset = max;
		if (offset < 0) offset = 0;
		[self draw];
		*/
		[timer invalidate];
		timer = nil;
	}
}

- (void)driveAnimation
{
	double elapsed = CACurrentMediaTime() - startTime;
	if (elapsed >= runDelta) {
		[self endAnimation];
	} else {
		[self updateAnimationAtTime:elapsed];
	}
}

- (CGPoint) viewCenterForIndex:(int)index{
	
	UIView *v = [listView viewWithTag:index+1];
	
	return v.center;	
}

- (void)startAnimation:(double)speed{
	if (timer) [self endAnimation];
	
	/*
	 *	Adjust speed to make this land on an even location
	 */
	
	NSLog(@"speed: %lf",speed);
	double delta = speed * speed / (FRICTION * 2);
	if (speed < 0) delta = -delta;
	
	startSpeed = sqrt(fabs(delta * FRICTION * 2));
	if (delta < 0) startSpeed = -startSpeed;
	
	//runDelta = fabs(startSpeed / FRICTION);
	
	runDelta = 1;
	
	startTime = CACurrentMediaTime();
	
	NSLog(@"startSpeed: %lf",startSpeed); //px/sec
	
	NSLog(@"runDelta: %lf",runDelta);
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.01
											 target:self
										   selector:@selector(driveAnimation)
										   userInfo:nil
											repeats:YES];
}

/************************************************************************/
/*																		*/
/*	Touch																*/
/*																		*/
/************************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
	//touching an image
	if ([self hitTest:where withEvent:event].tag !=0 ) touchFlag = YES;
	
	startOff = offset;
	
	startTouch = where;
	
	currentTouch = where;
	
	startTime = CACurrentMediaTime();

	[self endAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
	
	int dx = where.x - startTouch.x;
	
	if (touchFlag == YES) {
	//touched image
	} else {
		
		// Start animation to nearest
		double time = CACurrentMediaTime();
		double speed = dx/(time - startTime);
	//	if (speed > MAXSPEED) speed = MAXSPEED;
	//	if (speed < -MAXSPEED) speed = -MAXSPEED;
		
		[self startAnimation:speed/2];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastTime = CACurrentMediaTime();
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
	
	int dx = where.x - currentTouch.x;
	
	touchFlag = NO;
	/*if (touchFlag) {
		// determine if the user is dragging or not
		if ((dx < 3) && (dy < 3)) return;
		touchFlag = NO;
	}*/
	
	for (UIView *v in listView.subviews) {
		CGPoint f = v.center;
		f.x += dx;
		[v setCenter:f];
	}
	currentTouch = where;
	
	double time = CACurrentMediaTime();
	if (time - startTime > 0.2) {
	    //startTime = time;
		//lastPos = pos;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
