//
//  ActuViewController.m
//  Letudiant
//
//  Created by Mac Mini 1 MoMac on 25/06/10.
//  Copyright 2010 MoMac. All rights reserved.
//

#import "ActuViewController.h"
#define ACTU_JSON_URL @"http://pipes.yahoo.com/pipes/pipe.run?_id=be1e99f3bd66e7d77b8bea636e2b35e0&_render=json"

//#define ACTU_JSON_URL @"http://pipes.yahoo.com/pipes/pipe.run?_id=be1e99f3bd66e7d77b8bea636e2b35e0&_render=json"

@implementation ActuViewController

- (void)loadView {
	
	[super loadView];
	
	theHeaderView.rightLabel.text = self.title;
	
}

-(id)init{
	
	if(self = [super init]){
		self.title = @"Actualités";
		self.tabBarItem.image = [UIImage imageNamed:@"tabbar_news.png"];
		self.tabBarItem.title = @"Actus";
		theURL = [[NSString alloc] initWithString: ACTU_JSON_URL];
	}
	return self;
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
}

- (void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
