//
//  afListViewTime.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afHorizontalStackedView.h"

@interface afListViewTime : UIView {
	// Current state support
	double offset;
	
	NSTimer *timer;
	double startTime;
	double lastTime;
	double startOff;
	double startPos;
	double startSpeed;
	double runDelta;
	double lastDelta;
	BOOL touchFlag;
	CGPoint startTouch;
	CGPoint currentTouch;
	
	double lastPos;
	
	afHorizontalStackedView *listView;
}

@property (nonatomic,retain) afHorizontalStackedView *listView;

@end
