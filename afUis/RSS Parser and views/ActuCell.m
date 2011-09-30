//
//  ActuCell.m
//  Etudiant
//
//  Created by Mac Mini 1 MoMac on 13/07/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import "ActuCell.h"


@implementation ActuCell

@synthesize theTitleLabel,theSubtitleLabel,theCornerView;

-(void)hasCornerView:(BOOL)hasIt{
	
	if (theCornerView == nil) {
		UIImage *img = [UIImage imageNamed:@"cell_corner.png"];
		
		theCornerView = [[UIImageView alloc] initWithImage:img];
		
		theCornerView.frame = CGRectMake(0, 0, img.size.width,img.size.height);
		
		[self addSubview:theCornerView];
	}
	
	theCornerView.hidden = !hasIt;	
}

- (void)dealloc {
	[theTitleLabel release];
	[theSubtitleLabel release];
	[theCornerView release];
	
	[super dealloc];
}


@end
