//
//  RSSViewController.m
//  Letudiant
//
//  Created by Mac Mini 1 MoMac on 28/06/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import "RSSViewController.h"
#import "ActuCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NetworkTools.h"
#import "EGORefreshTableHeaderView.h"
#import "RSSDetailViewController.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation RSSViewController

@synthesize theDataSource,refreshButton,theTableView,theURL,myDelegate,theHeaderView;
@synthesize notConnectedLabel, theAI;
@synthesize reloading = _reloading;

#pragma mark -
#pragma mark == Init == 
#pragma mark -

- (id) init {
	
	if(self = [super init]){
		theDataSource = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) loadView {
	
	theHeaderView = [[EtudiantNavBar alloc] init];
	[theHeaderView showBackButton:NO animated:NO];
	[theHeaderView showModifyButton:NO animated:NO];
	
	theHeaderView.logoImage.hidden = NO;
	
	CGRect frame = CGRectMake(0, 0, 320, 367);
	
	UIView *theView = [[UIView alloc] initWithFrame:frame];
	UIImage *bgImg = [UIImage imageNamed:@"bg.png"];
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
	
	[theView addSubview:bgImgView];
	[bgImgView release];
	
	[theView addSubview:theHeaderView];
	
	theTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, theHeaderView.frame.size.height + theHeaderView.frame.origin.y + 7.5 , 
																 theView.frame.size.width - 20 ,theView.frame.size.height - 20 ) 
												style:UITableViewStylePlain];
	theTableView.backgroundColor = [UIColor clearColor];
	theTableView.delegate = self;
	theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	theTableView.dataSource = self;
	[theView addSubview:theTableView];
	
	self.view = theView;
	[theView release];
}

- (void) viewWillAppear:(BOOL)animated{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if ([[NetworkTools sharedTool] testNetwork]) {
		if ([theDataSource count] == 0) {
			if (!theAI) {
				theAI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
				theAI.center = CGPointMake(self.view.frame.size.width/2 , self.view.frame.size.height/2 );
				theAI.hidesWhenStopped = YES;
				[self.view addSubview:theAI];
			}
			
			if (notConnectedLabel && ![notConnectedLabel.superview isEqual:nil]) 
				[notConnectedLabel removeFromSuperview];
			
			[theAI startAnimating];
		}	
		[self refresh];
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"RSS"]]) {
		[self loadFromDisk];
	}
	else {
		
		NSString *str = @"Vous n'êtes pas connecté à Internet.";
		
		if (!notConnectedLabel) {
			notConnectedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			notConnectedLabel.text = str;
			notConnectedLabel.backgroundColor = [UIColor clearColor];
			notConnectedLabel.textColor = [UIColor blackColor];
			notConnectedLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
			notConnectedLabel.numberOfLines = 0;
			notConnectedLabel.lineBreakMode = UILineBreakModeWordWrap;
			notConnectedLabel.textAlignment = UITextAlignmentCenter;
			
			CGSize theSize = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16]
							 constrainedToSize:CGSizeMake(self.view.frame.size.width, 2000.0f) 
								 lineBreakMode:UILineBreakModeWordWrap];
			notConnectedLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, theSize.height);
			notConnectedLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
		}
		if (notConnectedLabel && [notConnectedLabel.superview isEqual:nil]) 
			[self.view addSubview:notConnectedLabel];
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - theTableView.bounds.size.height, 300.0f, theTableView.bounds.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
		[theTableView addSubview:refreshHeaderView];
		theTableView.showsVerticalScrollIndicator = NO;
		//[refreshHeaderView release];
	}
}

#pragma mark -
#pragma mark ==== Table view ====
#pragma mark -
#pragma mark == Data source ==
#pragma mark -

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView 
  numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) 
		return [theDataSource count];
	
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *) tableView:(UITableView *)tableView 
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int theRow = indexPath.row;
	
	ActuCell *cell;
	UILabel *titleLabel = nil;
	UILabel *subtitleLabel = nil;	
	UIView *bgView = nil;
	NSString *theDesc = [[theDataSource objectAtIndex:theRow] objectForKey:@"shortDescription"];	
	NSString *theTitle = [[theDataSource objectAtIndex:theRow] objectForKey:@"title"];	
	
	cell = (ActuCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil){
		cell = [[[ActuCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
		
		bgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
		bgView.contentMode = UIViewContentModeScaleToFill;
		bgView.tag = 3;
		
		cell.backgroundView = bgView;
		
		titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		[titleLabel setLineBreakMode:UILineBreakModeWordWrap];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setMinimumFontSize:FONT_SIZE];
		[titleLabel setNumberOfLines:0];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE]];
		[titleLabel setTag:1];
		
		[[cell contentView] addSubview:titleLabel];
		
		subtitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		[subtitleLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[subtitleLabel setBackgroundColor:[UIColor clearColor]];
		[subtitleLabel setMinimumFontSize:FONT_SIZE];
		[subtitleLabel setNumberOfLines:1];
		[subtitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		[subtitleLabel setTag:2];
		
		[[cell contentView] addSubview:subtitleLabel];
	}
	
	CGFloat lastHeight = 0;
	NSString *text = theTitle;
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE] 
				   constrainedToSize:constraint 
					   lineBreakMode:UILineBreakModeWordWrap];
	
	if (!titleLabel)
		titleLabel = (UILabel*)[cell viewWithTag:1];
	
	[titleLabel setText:text];
	[titleLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height)];
	
	lastHeight = titleLabel.frame.size.height + titleLabel.frame.origin.y;
	
	if (!subtitleLabel) 
		subtitleLabel = (UILabel *)[cell viewWithTag:2];
	
	
	if (![theDesc isEqual:nil] && ![theDesc isEqualToString:@""]){
		[subtitleLabel setText:theDesc];
		[subtitleLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, titleLabel.frame.size.height + titleLabel.frame.origin.y + 3, 
										   CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20)];
		lastHeight = subtitleLabel.frame.size.height + subtitleLabel.frame.origin.y;
	}
	else {
		[subtitleLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, titleLabel.frame.size.height + titleLabel.frame.origin.y + 3, 
										   CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 0)];
		subtitleLabel.text = @"";
	}
	
	if (!bgView) 
		bgView = (UIImageView *)[cell viewWithTag:3];
	
	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	if ([indexPath compare:firstIndexPath] == NSOrderedSame) {
		[(UIImageView *)bgView setImage:[UIImage imageNamed:@"cellule_top.png"]];
		[cell hasCornerView:YES];
	}
	else {
		[(UIImageView *)bgView setImage:[UIImage imageNamed:@"cellule.png"]];
		[cell hasCornerView:NO];
	}
	
	bgView.frame = CGRectMake(0, 0, CELL_CONTENT_WIDTH, lastHeight);
	
    return cell;
}

#pragma mark -
#pragma mark == Delegate ==
#pragma mark -

- (CGFloat) tableView:(UITableView *)tableView 
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *text = [[theDataSource objectAtIndex:[indexPath row]] objectForKey:@"title"];
	NSString *theDesc = [[theDataSource objectAtIndex:indexPath.row] objectForKey:@"description"];	
	
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE] 
				   constrainedToSize:constraint 
					   lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat height = size.height;
	
	if (![theDesc isEqual:nil] && ![theDesc isEqualToString:@""])
		return height + 20 + (CELL_CONTENT_MARGIN * 2);
	else 
		return height + (CELL_CONTENT_MARGIN * 2);
}

- (void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	theHeaderView.logoImage.hidden = YES;
	theHeaderView.rightLabel.hidden = YES;
	refreshButton.hidden = YES;
	
	int row = indexPath.row;
	
	RSSDetailViewController *theVC = [[RSSDetailViewController alloc] initWithIndex:row];
	//
	theVC.dataSource = self;
	[self.navigationController pushViewController:theVC animated:YES];
	
	/*
	[theHeaderView showBackButton:YES animated:NO];
	[theHeaderView.backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
	*/
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

#pragma mark -
#pragma mark == RSSDetailViewController Delegate ==
#pragma mark -

-(int) detailViewDataSourceCount:(RSSDetailViewController *)theVC{
	return [theDataSource count];
}

-(NSDictionary *) detailView:(RSSDetailViewController *)theVC 
				dataForIndex:(int)theI{
	
	return [theDataSource objectAtIndex:theI];
}

#pragma mark -
#pragma mark ==== ====
#pragma mark -
#pragma mark == Feed's loading ==
#pragma mark -

// load feed from cached data
-(void) loadFromDisk{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSArray *a = [NSArray arrayWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"RSS"]];
	[theDataSource addObjectsFromArray:a];
	if (myDelegate !=NULL) {
		if ([theDataSource count]>0) [myDelegate RSSView:self hasNewFeed:[theDataSource objectAtIndex:0]];
	}
	[theTableView reloadData];
}

- (void) requestWithURL:(NSString *)stringURL{
	
	NSURL *url = [NSURL URLWithString:stringURL];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	
	[request setTimeOutSeconds:10];
	[request startAsynchronous];
	
}

-(void) refresh{
	
	[self requestWithURL:theURL];
	
}

- (NSString *)stringFromDate:(NSDate *)theDate{
	
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
	
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setLocale:usLocale];
	[df setDateFormat:@"dd/MM/yyyy"];
	[usLocale release];
	return [df stringFromDate:theDate];
}

- (NSDate *)stringToDate:(NSString *)theDate{
	
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	NSString *subString = [theDate substringWithRange:NSMakeRange(0, 25)];
	
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setLocale:usLocale];
	[df setDateFormat:@"EEE, dd MMM yyyy HH:mm:SS"];
	[usLocale release];
	
	NSDate *myDate = [df dateFromString: subString];
	
	return myDate;
}

- (void) dismissView{
	
	theHeaderView.rightLabel.hidden = NO;
	refreshButton.hidden = NO;
	//leftButton.hidden = YES;
	//rightButton.hidden = YES;	
	self.navigationItem.leftBarButtonItem = nil;
	theHeaderView.logoImage.hidden = NO;
	
	[theHeaderView showBackButton:NO animated:NO];
	[theHeaderView.backButton removeTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark == ASIHTTP request delegate ==
#pragma mark -

- (void)requestStarted:(ASIHTTPRequest *)request{
	
}

- (void)requestFinished:(ASIHTTPRequest *)request{
	
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	SBJSON *json;
	NSError *jsonError;
	
	NSDictionary *jsonResults;
	
	// Init JSON
	json = [[SBJSON new] autorelease];
	
	// Get result in a NSDictionary
	jsonResults = [json objectWithString:responseString error:&jsonError];
	
	// Check if there is an error
	if (jsonResults == nil) {
		
		NSLog(@"Erreur lors de la lecture du code JSON (%@).", [jsonError localizedDescription]);
		
	} else {
		
		theTableView.hidden = NO;
		
		if ([theDataSource count]!=0) 
			[theDataSource removeAllObjects];
		
		for (NSDictionary *dico in [[jsonResults objectForKey:@"value"] objectForKey:@"items"]) {
			
			NSMutableDictionary  *theSavedDico = [[NSMutableDictionary alloc] initWithCapacity:6];
			[theSavedDico setObject:[dico objectForKey:@"title"] forKey:@"title"];	
			[theSavedDico setObject:[dico objectForKey:@"content:encoded"] forKey:@"description"];
			[theSavedDico setObject:[dico objectForKey:@"link"] forKey:@"link"];
			[theSavedDico setObject:[dico objectForKey:@"description"] forKey:@"shortDescription"];
			
			NSDate *theDate;
			id dateObj = [dico objectForKey:@"pubDate"];
			if ([dateObj isKindOfClass:[NSArray class]]) 
				theDate = [self stringToDate:[dateObj objectAtIndex:0]];
			else if ([dateObj isKindOfClass:[NSString class]]) 
				theDate = [self stringToDate:dateObj];
			
			
			
			[theSavedDico setObject:theDate forKey:@"pubDate"];
			
			NSDictionary *enclosureDico = [dico objectForKey:@"media:content"];
			
			if (enclosureDico !=nil) {
				NSString *u = [enclosureDico objectForKey:@"url"];
				[theSavedDico setObject:u forKey:@"imageLink"];
			}
			
			[theDataSource addObject:theSavedDico];
			
			[theSavedDico release];
		}
		
		if ([theDataSource count]!=0) {
			
			NSMutableArray *ar = [NSMutableArray arrayWithArray:theDataSource];
			
			int range;
			
			range = ([theDataSource count] < 15 ? [theDataSource count] : 15);
			
			[ar removeObjectsInRange:NSMakeRange(range, [ar count] - range)];
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			if([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"RSS"]]) {
				NSError *error;
				[[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"RSS"] 
														   error:&error];
			}	
			[ar writeToFile:[documentsDirectory stringByAppendingPathComponent:@"RSS"] atomically:YES];
			[self doneLoadingTableViewData];
			[self.theTableView reloadData];
			
			if (myDelegate != NULL) {
				if ([theDataSource count]>0) 
					[myDelegate RSSView:self hasNewFeed:[theDataSource objectAtIndex:0]];
			}
		}
		else {
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			if([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"RSS"]]) 
				[self loadFromDisk];
			
			[self doneLoadingTableViewData];
			
		}
		[theAI removeFromSuperview];
		[notConnectedLabel removeFromSuperview];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request{
	//NSError *error = [request error];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"RSS"]]) 
		[self loadFromDisk];
	[self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark == EGO Pull to refresh == 
#pragma mark -

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews model to reload
	//  put here just for demo
	[self refresh];
}


- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	[self dataSourceDidFinishLoadingNewData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && 
			scrollView.contentOffset.y > -65.0f && 
			scrollView.contentOffset.y < 0.0f && 
			!_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && 
				   scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		theTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)dataSourceDidFinishLoadingNewData{
	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[theTableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
}

#pragma mark -

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
	refreshHeaderView=nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	refreshHeaderView = nil;
	[theDataSource release];
	[theTableView release];
	[theURL release];
	myDelegate = nil;
	[theHeaderView release];
	[refreshButton release];
	
	[super dealloc];
}




@end
