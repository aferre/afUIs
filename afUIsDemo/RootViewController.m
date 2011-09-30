//
//  RootViewController.m
//  afUIsDemo
//
//  Created by adrien ferré on 28/09/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "RootViewController.h"
#import "afUIsDemoController.h"
#import "afNetworkImageViewDemo.h"
#import "RatingViewController.h"
#import "afListViewDemoController.h"
#import "afDiscControllerDemo.h"

@implementation RootViewController

@synthesize viewControllers;

-(id) initWithCoder:(NSCoder *)aDecoder{
    
	if (self = [super initWithCoder:aDecoder]){
		self.title = @"afLib";
		NSMutableArray *theViewControllers = [[NSMutableArray alloc] init];
		
        	afNetworkImageViewDemo *a = [[afNetworkImageViewDemo alloc] init];
         [theViewControllers addObject:a];
         [a release];
        
         afDiscControllerDemo *f = [[afDiscControllerDemo alloc] init];
         [theViewControllers addObject:f];
         [f release];
        
        RatingViewController *r = [[RatingViewController alloc] initWithRating:0];
        [theViewControllers addObject:r];
        [r release];
		
		afListViewDemoController *list = [[afListViewDemoController alloc] init];
		[theViewControllers addObject:list];
        [list release];
		
		afUIsDemoController *uis = [[afUIsDemoController alloc] init];
		[theViewControllers addObject:uis];
		[uis release];
		
		viewControllers = [[NSArray alloc] initWithArray:theViewControllers];
		[theViewControllers release];
	}
	return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [viewControllers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.textLabel.text = [NSString stringWithFormat:@"%@",[[viewControllers objectAtIndex:indexPath.row] class]] ;
	
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *detailViewController = [viewControllers objectAtIndex:indexPath.row];
    // ...
    // Pass the selected object to the new view controller.
	//if ([detailViewController isKindOfClass:[afDiscController class]]) {
	//	[self presentModalViewController:detailViewController animated:YES];
	//}
    [((afUIsDemoAppDelegate *) [UIApplication sharedApplication].delegate).navigationController pushViewController:detailViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
