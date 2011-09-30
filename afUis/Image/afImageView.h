#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface afImageView : UIImageView  {
	
	UIImage *baseImage;			/**< Image to display. */
	
	UIImageView *theBorder;		/**< Border used for highlighting selection. */
	
	UIImageView *theImageView;	/**< ImageView with shadow borders as default image. */
	
	UIImageView *theOverlay;	/**< Overlay for presenting a play button to user. */
	
	BOOL hasOverlay;			/**< Saving whether the overlay is there or not. */
	
	BOOL hasBorder;				/**< Saving whether the border is there or not. */
}
@property (nonatomic,assign) UIImage *baseImage;
@property (nonatomic,retain) UIImageView *theBorder;
@property (nonatomic,retain) UIImageView *theImageView;
@property (nonatomic,retain) UIImageView *theOverlay;

@property (assign) BOOL hasOverlay;
@property (assign) BOOL hasBorder;
/*
- (id) initWithDefaultImageRef:(NSString *)imgRessourceRef withName:(NSString *)theName andImageLoader:(imageLoader*)aImgLoader forDisc:(int)discNumber;
*/
- (void) hasABorder:(BOOL) hasIt forDisc:(int) discNumber;

- (void) hasAnOverlay:(BOOL) hasIt;

- (UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end
