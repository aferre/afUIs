//
//  ImageDiscConfig.h
//  Disque
//
//  Created by adrien ferré on 24/05/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#define DEBUGIMAGESELECTIONDISK 1

#define Disc1		@"cercle_bigstring3.png"
#define Disc2		@"cercle_bigstring2.png"
#define Disc3		@"cercle_bigstring1.png"
#define BackgroundV @"bgV.png"
#define BackgroundH @"bgH.png"
#define Header		@"new_header.png"

#define TabBarHeight 44.0

#define TransitionTime					0.5
#define Disc_H							804.0
#define Disc_W							Disc_H
#define Disc_Radius						(Disc_H/2.0)
#define image_Selection_Disc_Center_x	Disc_Radius
#define image_Selection_Disc_Center_y	Disc_Radius
#define discShadowOffset				4.0

#define radius_To_Image_Portrait	(Disc_Radius - Image_H/2 - Margin_H/2 - discShadowOffset)	/**< Radius to the circle to chich belong the centers of the images in portrait mode (anchor point (0.5,0.5))*/
#define radius_To_Image_Landscape	(Disc_Radius - Image_W/2 - Margin_W/2 - discShadowOffset) /**< Radius to the circle to chich belong the centers of the images in landscape mode (anchor point (0.5,0.5))*/

//Images
#define Image_W				100.0		/**< Image width. For further use of the library, you might want to change this to a dynamic parameter. This is for better code reading.*/
#define Image_H				75.0		/**< Image height. For further use of the library, you might want to change this to a dynamic parameter. This is for better code reading.*/
#define Margin_H			20.0		/**< Total margin height. */
#define Margin_W			20.0		/**< Total margin width. */
#define Image_Shadow_Height 3

//ImageSelectionDisc
#define nbImagesToBeDisplayed	3 /**< The number of images that are displayed to the user.*/
#define nbImagesOnDisc			18		/**< The number of images that are displayed on the disc. This could be changed when using smaller or larger images, or a smaller or larger disc (typically on Ipad).*/

//ImageSelectionDiscView
#define firstScale					0.85						/**< Deprecated.*/
#define secondScale					0.7/firstScale			/**< Because going back to identity transform before doing the animations, just handy for the code, deprecated.*/
#define firstTranslationOffsetY_V	(-78.0)				/**< The first translation offset applied to each disk, when in portrait mode.*/
#define secondTranslationOffsetY_V	(-55.0)				/**< The second translation offset applied to each disk, when in portrait mode.*/
#define firstTranslationOffsetY_H	(-30.0)				/**< The first translation offset applied to each disk, when in landscape mode.*/
#define secondTranslationOffsetY_H	(-65.0)				/**< The second translation offset applied to each disk, when in landscape mode.*/