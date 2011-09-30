//
//  afStackedView.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 02/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afStackedView.h"


@implementation afStackedView

@synthesize widthMargin,heightMargin;

- (id)initWithFrame:(CGRect)frame
	 andWidthMargin:(CGFloat)theWidthMargin
	 andHeightMargin:(CGFloat)theHeightMargin{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.widthMargin = theWidthMargin;
		self.heightMargin = theHeightMargin;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
