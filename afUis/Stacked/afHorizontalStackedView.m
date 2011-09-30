//
//  afHorizontalStackedView.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 17/09/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "afHorizontalStackedView.h"


@implementation afHorizontalStackedView

- (id)initWithFrame:(CGRect)frame
	 andWidthMargin:(CGFloat)theWidthMargin
	andHeightMargin:(CGFloat)theHeightMargin{
	
	if (self = [super initWithFrame:frame 
					 andWidthMargin:theWidthMargin 
					andHeightMargin:theHeightMargin]) {
		
	}
	return self;
}

-(void) addSubview:(UIView *)theView{
    
	CGRect theVFrame = theView.frame;
    
    CGRect lastViewFrame = ((UIView *)[[self subviews] lastObject]).frame;
    
	theView.frame = CGRectMake(lastViewFrame.origin.x + lastViewFrame.size.width + widthMargin, 
                               heightMargin, 
                               theVFrame.size.width, theVFrame.size.height);
	
    [super addSubview:theView];
}

- (void)dealloc {
    [super dealloc];
}


@end
