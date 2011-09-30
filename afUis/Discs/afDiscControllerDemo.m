//
//  afDiscControllerDemo.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 25/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afDiscControllerDemo.h"
#import <QUARTZCORe/QuartzCore.h>

@implementation afDiscControllerDemo

@synthesize DC;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init{
    if ((self = [super init])) {
        self.title = @"afDiscDemo";
		self.view.layer.name = self.title;
		self.view.userInteractionEnabled = YES;
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] ];
	
	afDiscController *f = [[afDiscController alloc] initWithDiscDataSource:nil 
														   andDiscDelegate:nil];
	
	[self.view addSubview:f.view];
	
	DC = f;
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	UIView *v = [touch view];
	if ([v isEqual:self.view]) {
		NSLog(@"touched self");
	}
	else {
		[DC touchesBegan:touches withEvent:event];
	}
	
	CGPoint point = [touch locationInView:self.view]; 
	
	point = [[touch view] convertPoint:point toView:nil];
	
	CALayer *layer = [(CALayer *)self.view.layer.presentationLayer hitTest:point];
	
	
	NSLog(@"%@**: layer touched is %@, superlayer is %@",self.view.layer.name,layer.name,layer.superlayer.name);
    NSLog(@"%@**: view touched is %@",self.view.layer.name,[touch view].layer.name);
	
	//else [self.view.nextResponder touchesBegan:touches 
	//		  withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	UIView *v = [touch view];
	if ([v isEqual:self.view]) {
		NSLog(@"touched self");
	}
	else {
		[DC touchesMoved:touches withEvent:event];
	}
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	UIView *v = [touch view];
	if ([v isEqual:self.view]) {
		NSLog(@"touched self");
	}
	else {
		[DC touchesEnded:touches withEvent:event];
	}
	
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
