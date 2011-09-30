//
//  RSSViewController.h
//  Letudiant
//
//  Created by Mac Mini 1 MoMac on 28/06/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "EtudiantNavBar.h"
#import "RSSDetailViewController.h"

@protocol RSSDelegate;

@class EGORefreshTableHeaderView;

@interface RSSViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,RSSDetailViewControllerDelegate> {
	
	//ERGO REFRESH
	EGORefreshTableHeaderView *refreshHeaderView;
	
	//  Reloading should really be your tableviews model class
	//  Putting it here for demo purposes 
	BOOL _reloading;
	
	//connection & loading display
	UILabel *notConnectedLabel;
	UIActivityIndicatorView *theAI;
	
	NSMutableArray *theDataSource;
	
	UITableView *theTableView;
	
	NSString *theURL;					 
	
	id<RSSDelegate> myDelegate;
	
	EtudiantNavBar *theHeaderView;
	
	UIButton *refreshButton;
}

@property(assign,getter=isReloading) BOOL reloading;
@property (nonatomic ,retain) UILabel *notConnectedLabel;
@property (nonatomic ,retain) UIActivityIndicatorView *theAI;
@property (assign) id<RSSDelegate> myDelegate;
@property (nonatomic,retain) UIButton *refreshButton;
@property (nonatomic,retain) NSMutableArray *theDataSource;
@property (nonatomic,retain) NSString *theURL;
@property (nonatomic,retain) UITableView *theTableView;
@property (nonatomic,retain) EtudiantNavBar *theHeaderView;

- (void) setArrowsForIndex;

- (void)reloadTableViewDataSource;

- (void) dataSourceDidFinishLoadingNewData;

- (void)doneLoadingTableViewData;

- (void) loadFromDisk;

- (void)requestWithURL:(NSString *)stringURL;

- (UIView *) createDetailViewWithTitle:(NSString *)theTitle
					   andDescription:(NSString *)theDesc
						 andImageLink:(NSString *)theImgLink;

- (UIView *) createDetailViewWithDico:(NSDictionary *)theDico;

- (void) refresh;

- (void) previousDetailedView;

- (void) nextDetailedView;

- (NSString *) stringFromDate:(NSDate *)theDate;

- (NSDate *) stringToDate:(NSString *)theDate;

@end

@protocol RSSDelegate <NSObject>
@optional
-(void) RSSView:(RSSViewController *)rssviewCon hasNewFeed:(NSDictionary*) theFeed;
@end