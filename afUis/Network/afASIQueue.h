//
//  afASIQueue.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 14/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "gdzSingleton.h"

@interface afASIQueue : NSObject {

	ASINetworkQueue *networkQueue;
	NSMutableArray *jobsQueue; // jobs sorted by priority
}

DECLARE_SINGLETON_FOR_CLASS(afASIQueue)

@property (retain) ASINetworkQueue *networkQueue;
@property (nonatomic,retain) NSMutableArray *jobsQueue;

- (void) doNetworkOperations;

- (void) addNetworkOperation:(ASIHTTPRequest *)request;

- (void) newQueue;

#pragma mark -
#pragma mark === Priority handling ===
#pragma mark -

/**
 Sort the queue array with priority.
 
 @param ascending If NO, the array is sorted with highest priority jobs at the beginning of the array. 
 */
- (void) sortLoadingQueueWithPriority:(BOOL)ascending;

@end
