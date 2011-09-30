//
//  CustomImageView.m
//  TV5Monde
//
//  Created by Adrien Ferré on 03/06/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import "afImageView.h"
#import "ImageSelectionDiscConfig.h"

#define MaskOff				@"Disc_Image_Mask_Off.png"
#define MaskOn				@"Disc_Image_Mask_On.png"
#define ImagesShadow		@"img_ombre.png"
#define ImagesPlayOverlay	@"overlay_play.png"
#define NoBorderDisc1		@"img_cadre_noselected3.png"
#define NoBorderDisc2		@"img_cadre_noselected2.png"
#define NoBorderDisc3		@"img_cadre_noselected1.png"
#define BorderDisc1			@"img_cadre_selected_3.png"
#define BorderDisc2			@"img_cadre_selected_2.png"
#define BorderDisc3			@"img_cadre_selected_1.png"

@implementation afImageView
@synthesize theBorder, theOverlay, theImageView, hasOverlay, hasBorder, baseImage;

#pragma mark -
#pragma mark === Init ===
#pragma mark -
/*
- (id) initWithDefaultImageRef:(NSString *)imgRessourceRef withName:(NSString *)theName andImageLoader:(imageLoader*)aImgLoader forDisc:(int)discNumber{
	
	if (self = [super initWithImage:[UIImage imageNamed:ImagesShadow]]){
		
		self.userInteractionEnabled = YES;
		self.layer.name = theName;
		
		baseImageView = [[KwImageView alloc] initWithFrame:CGRectMake(Image_Shadow_Height, Image_Shadow_Height, Image_W, Image_H) 
											  andShowStyle:KWUIImageShowStyleNone 
										   andDefaultImage:imgRessourceRef
											andImageLoader:aImgLoader
											 andMyDelegate:self];
		
		baseImage = baseImageView.image;
		
		UIImage *mask = [UIImage imageNamed:MaskOff];
		UIImage	*maskedImage = [self maskImage:baseImage withMask:mask];
		
		theImageView = [[UIImageView alloc] initWithImage:maskedImage];
		
		theImageView.userInteractionEnabled = YES;
		theImageView.layer.name = theName;
		theImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		theImageView.frame = CGRectMake(Image_Shadow_Height, Image_Shadow_Height, Image_W, Image_H);
		
		[self addSubview:theImageView];
		
		hasBorder = YES;
		[self hasABorder:NO forDisc:discNumber];
		hasOverlay = NO;
	}
	return self;
}
*/
#pragma mark -
#pragma mark === Overlay / Border displaying ===
#pragma mark -

/**
 Function used to show the border or not.
 @param hasIt Yes if the image should be displayed with a border. NO otherwise.
 @param discNumber The disc in which the image is displayed.
 */
- (void) hasABorder:(BOOL) hasIt forDisc:(int)discNumber{
	
	if (hasIt == hasBorder) return;
	else if (hasIt){
		if (theBorder==nil){
			theBorder = [[UIImageView alloc] init];
			//In order to avoid antialiasing effect. we add a 1 px transparent border to the border.
			theBorder.frame = CGRectMake(Image_Shadow_Height-1, Image_Shadow_Height-1, Image_W+2, Image_H+2);
			//theBorder.opaque = NO;
			[self addSubview:theBorder];
		}
		UIImage *borderImage;
		switch (discNumber) {
			case 1:{
				borderImage = [UIImage imageNamed:BorderDisc1];
			}
				break;
			case 2:{	
				borderImage = [UIImage imageNamed:BorderDisc2];
			}	
				break;
			case 3:	{	
				borderImage = [UIImage imageNamed:BorderDisc3];
			}	
				break;
			default:
				break;
		}
		[theBorder setImage:borderImage];
		
		UIImage *mask = [UIImage imageNamed:MaskOn];
		
		UIImage *maskedImage = [self maskImage:baseImage withMask:mask];
		
		theImageView.image = maskedImage;
	}
	else {
		if (theBorder==nil){
			theBorder = [[UIImageView alloc] init];
			//In order to avoid antialiasing effect. we add a 1 px transparent border to the border.
			theBorder.frame = CGRectMake(Image_Shadow_Height-1, Image_Shadow_Height-1, Image_W+2, Image_H+2);
			//theBorder.opaque = NO;
			[self addSubview:theBorder];
		}
		
		UIImage *borderImage;
		switch (discNumber) {
			case 1:
			{	borderImage = [UIImage imageNamed:NoBorderDisc1];
			}	break;
			case 2:
			{	borderImage = [UIImage imageNamed:NoBorderDisc2];
			}	break;
			case 3:
			{	borderImage = [UIImage imageNamed:NoBorderDisc3];
			}	break;
			default:
				break;
		}
		
		[theBorder setImage:borderImage];
		
		UIImage *mask = [UIImage imageNamed:MaskOff];
		
		UIImage *maskedImage = [self maskImage:baseImage withMask:mask];
		
		theImageView.image = maskedImage;
	}
	hasBorder = hasIt;
}

/**
 Function used to show the overlay or not.
 @param hasIt Yes if the image should be displayed with an overlay. NO otherwise.
 */
- (void) hasAnOverlay:(BOOL) hasIt{
	
	if (hasIt == hasOverlay) return;
	else if (hasIt)
	{
		if (theOverlay==nil){
			theOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ImagesPlayOverlay]];
			theOverlay.center = CGPointMake((Image_W + 2 * Image_Shadow_Height)/2, (Image_H + 2 * Image_Shadow_Height)/2);		
		}
		[self addSubview:theOverlay];
	}
	else {
		[theOverlay removeFromSuperview];
	}
	hasOverlay = hasIt;	
}

#pragma mark -
#pragma mark === Misc ===
#pragma mark -

/**
 Because the performance when using opacity, rounded corners and the maskToBounds propterites were very bad,
 this function is used to provide the rounded corners and opacity wanted.
 If his is deplyed on Ipad, you might want to use the properties listed above.
 @param image The image to be masked.
 @param maskImage The mask image.
 @result The masked image.
 */
- (UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
	
	CGImageRef maskRef = maskImage.CGImage; 
	
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), 
										NULL, 
										false);
	
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	CGImageRelease(mask);
	
	UIImage *img = [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);
	
	return img;
}

#pragma mark -
#pragma mark === Override ===
#pragma mark -

-(void) dealloc {
	
	/////////////////////	
	[theImageView release];
	[theOverlay release];
	[theBorder release];
	/////////////////////	
	[super dealloc];
	/////////////////////
}

@end

