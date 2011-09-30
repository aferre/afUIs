//
//  afNetwork.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 07/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afNetwork.h"

@implementation afNetwork

static afNetwork *sharedSingleton = nil;

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}
- (void) updateInterfaceWithReachability: (Reachability*) curReach{
	/*   if(curReach == hostReach)
	 {
	 NetworkStatus netStatus = [curReach currentReachabilityStatus];
	 BOOL connectionRequired= [curReach connectionRequired];
	 
	 if(connectionRequired)
	 {
	 baseLabel=  @"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.";
	 }
	 else
	 {
	 baseLabel=  @"Cellular data network is active.\n  Internet traffic will be routed through it.";
	 }
	 summaryLabel.text= baseLabel;
	 }
	 if(curReach == internetReach)
	 {	
	 [self configureTextField: internetConnectionStatusField imageView: internetConnectionIcon reachability: curReach];
	 }
	 if(curReach == wifiReach)
	 {	
	 [self configureTextField: localWiFiConnectionStatusField imageView: localWiFiConnectionIcon reachability: curReach];
	 }
	 */
}

-(void)load {
	
	[[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(reachabilityChanged:) 
                                                 name: kReachabilityChangedNotification 
                                               object: nil];
	
    //Change the host name here to change the server your monitoring
	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
	
}

+ (afNetwork*)sharedManager
{
    if (sharedSingleton == nil) {
        sharedSingleton = [[super allocWithZone:NULL] init];
		[self load];
    }
    return sharedSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
