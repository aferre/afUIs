//
//  NetworkTools.m
//  IHM NOUVEAU TEST
//
//  Created by adrien ferré on 28/03/10.
//  Copyright 2010 Emma. All rights reserved.
//

#import "NetworkTools.h"

#import "Reachability.h"

@implementation NetworkTools
@synthesize connected, aConnectionRequired;

static NetworkTools *sharedToolManager = nil;

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedTool] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

+ (NetworkTools*)sharedTool{
    if (sharedToolManager == nil) {
        sharedToolManager = [[super allocWithZone:NULL] init];
    }
    return sharedToolManager;
}

-(BOOL) testNetwork{
	BOOL returnVal=NO;
	Reachability *curReach = [[Reachability reachabilityForInternetConnection] retain];
	[curReach startNotifer];
	
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //BOOL  connectionRequired = [curReach connectionRequired];
    
	switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Access Not Available");
			aConnectionRequired	 = YES;
	//		connectionRequired = YES;  
			connected = NO;
			returnVal = NO;

			break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"Reachable WWAN");
			aConnectionRequired	 = NO;
	//		connectionRequired = NO;  
			returnVal = YES;
			connected = YES;
            break;
        }
        case ReachableViaWiFi:
        {
			NSLog(@"Reachable WiFi");
			aConnectionRequired	 = NO;
	//		connectionRequired = NO;  
            returnVal = YES;
			connected = YES;
			break;
		}
    }
	[curReach release];
	
	return returnVal;
}

-(BOOL)isConnected{
	return connected;
}
	

@end
