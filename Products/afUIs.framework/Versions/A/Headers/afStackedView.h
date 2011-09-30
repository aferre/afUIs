//
//  afStackedView.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 02/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface afStackedView : UIView {
	
	CGFloat widthMargin;
	CGFloat heightMargin;
}

@property (assign) CGFloat widthMargin;
@property (assign) CGFloat heightMargin;

- (id)initWithFrame:(CGRect)frame
	 andWidthMargin:(CGFloat)theWidthMargin
	andHeightMargin:(CGFloat)theHeightMargin;

@end
