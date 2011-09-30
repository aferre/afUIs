//
//  StringSelectionDisc.h
//  Disque
//
//  Created by Adrien Ferré on 21/05/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
//#import <ApplicationServices/ApplicationServices.h>

@protocol afDiscData;

@protocol afDiscDelegate;

@class UIImageView;

@interface afDisc : UIImageView {
	
	BOOL hasNavigationArrows;
	
	id<afDiscDelegate> delegate;
	id<afDiscData> dataSource;
	
	NSMutableArray *data; 
	NSString *highlightedImageName;
	
	UIImageView *arrowUp;
	UIImageView *arrowDown;
	
	CGFloat discRadius;
	CGPoint discCenter;
	CGFloat viewRadius;
	CGSize viewSize;
}
@property (assign) BOOL hasNavigationArrows;
@property (assign) CGSize viewSize;
@property (assign) CGPoint discCenter;
@property (assign) CGFloat discRadius;
@property (assign) CGFloat viewRadius;
@property (assign) id<afDiscData> dataSource;
@property (assign) id<afDiscDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, assign) NSString *highlightedImageName;
@property (nonatomic, retain) UIImageView *arrowUp;
@property (nonatomic, retain) UIImageView *arrowDown;

- (id) initWithFrame:(CGRect) theFrame 
	   andDiscRadius:(CGFloat) theRadius
		 andViewSize:(CGSize) theViewSize
andViewRadius:(CGFloat)theViewRadius;

- (void) setupDiscWithImages ;

- (void) addNavigationArrows;

- (void) showNavigationArrows:(BOOL) showIt;

- (void) updateWithAngleStep:(CGFloat) angleStep;

- (BOOL) setSelected:(NSString *)name;

- (void) animateToSelectedForOrientation:(UIInterfaceOrientation) interfaceOrientation;

- (void) animateImagesForOrientation:(UIInterfaceOrientation) orientation withStep:(CGFloat) angleStep;

- (void) handleOrientationChange:(UIInterfaceOrientation) toOrientation during:(float) duration;

- (void) rotateDiscBy:(CGFloat) rotAngle during:(CGFloat) duration;

- (void) updateImagesPositionsForOrientation:(UIInterfaceOrientation)toInterfaceOrientation during:(float)duration;

- (void) rotateImagesBy:(CGFloat)rotAngle during:(CGFloat)duration;

- (void) moveNavigationArrowsForOrientation:(UIInterfaceOrientation) theOrientation;
@end

@protocol afDiscDelegate

@optional
-(void)afDisc:(afDisc *)theDisc selectedIndex:(NSInteger) theIndex;
@end


@protocol afDiscData

@required
-(UIImageView *)afDisc:(afDisc *)theDisc viewForIndex:(NSInteger)theIndex;
-(NSInteger)numberOfItemsInDisc:(afDisc *)theDisc;
@end