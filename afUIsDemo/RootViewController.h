//
//  RootViewController.h
//  afUIsDemo
//
//  Created by adrien ferré on 28/09/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afUIsDemoAppDelegate.h"

@interface RootViewController : UITableViewController{
NSArray *viewControllers;

}
@property (nonatomic,retain) NSArray *viewControllers;
@end
