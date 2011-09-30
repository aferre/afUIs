//
//  afLoadingView.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 05/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface afLoadingView : UIView {
	
	UILabel *notConnectedLabel;
	UIActivityIndicatorView *loadingAI;
	UILabel *loadingLabel;
	UIProgressView *loadingProgressView;
}
@property (nonatomic,retain) UILabel *notConnectedLabel;
@property (nonatomic,retain) UIActivityIndicatorView *loadingAI;
@property (nonatomic,retain) UILabel *loadingLabel;
@property (nonatomic,retain) UIProgressView *loadingProgressView;
@end
