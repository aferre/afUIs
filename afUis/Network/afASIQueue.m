//
//  afASIQueue.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 14/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afASIQueue.h"


@implementation afASIQueue
SYNTHESIZE_SINGLETON_FOR_CLASS(afASIQueue)
@synthesize networkQueue,jobsQueue;


- (id) init{
	
	if (self = [super init]){
		[self newQueue];
		jobsQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)newQueue{
	// Stop anything already in the queue before removing it
	[[self networkQueue] cancelAllOperations];
	
	jobsQueue = [[NSMutableArray alloc] init];
	
	// Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidStartSelector:@selector(requestDidStartSelector:)];
	[[self networkQueue] setRequestDidReceiveResponseHeadersSelector:@selector(requestDidReceiveResponseHeadersSelector:)];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
	[self networkQueue].shouldCancelAllRequestsOnFailure = NO;
	[[self networkQueue] go];
}

- (void) addNetworkOperation:(afASIHTTPRequest *)request{
	
	[self.jobsQueue addObject:request];
	[self sortLoadingQueueWithPriority:NO];
	
	[[self networkQueue] addOperation:request];
}

#pragma mark ASIHTTPRequest delegate methods
- (void) requestDidStartSelector:(afASIHTTPRequest *)request{
	
	NSLog(@"Queued request started");
	
	if (request.delegate && request.didStartSelector) {
		[request.delegate performSelector:request.didStartSelector];
	}
}

- (void) requestDidReceiveResponseHeadersSelector:(afASIHTTPRequest *)request{
	
	NSLog(@"Queued request received response headers");
	NSLog(@"%@",[request  responseHeaders]);
}

- (void) requestFinished:(afASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		[self setNetworkQueue:nil]; 
	}
	
//	if (request.delegate && request.didFinishSelector) {
//		[request.delegate performSelector:request.didFinishSelector];
//	}
	
	//... Handle success
	NSLog(@"Queued request finished");
}

- (void)requestFailed:(afASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
	
	if (request.delegate && request.didFailSelector) {
		[request.delegate performSelector:request.didFailSelector];
	}
	//... Handle failure
	NSLog(@"Queued request failed");
}
#pragma mark -
#pragma mark === ASIHTTPQueue delegate methods ===
#pragma mark -
- (void)queueFinished:(afASIQueue *)queue
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
	NSLog(@"Queue finished");
}


#pragma mark -
#pragma mark === Priority handling ===
#pragma mark -

- (void) sortLoadingQueueWithPriority:(BOOL)ascending{
	
	int capa = [self.jobsQueue count];
	
	NSMutableArray *highPriorityTasks = [[NSMutableArray alloc] initWithCapacity:capa];
	NSMutableArray *normalPriorityTasks = [[NSMutableArray alloc] initWithCapacity:capa];
	NSMutableArray *lowPriorityTasks = [[NSMutableArray alloc] initWithCapacity:capa];
	NSMutableArray *newQueueArray = [[NSMutableArray alloc] initWithCapacity:capa];
	
	for (afASIHTTPRequest *queueJob in self.jobsQueue){
		
		switch (queueJob.priority) {
			case highPriority:{
				[highPriorityTasks addObject:queueJob];
			}
				break;
			case normalPriority:{
				[normalPriorityTasks addObject:queueJob];
			}
				break;
			case lowPriority:{
				[lowPriorityTasks addObject:queueJob];
			}
				break;
			default:{ //assign a normal priority if priority not set.
				[normalPriorityTasks addObject:queueJob];
			}
				break;
		}
	}
	if (ascending) {		
		[newQueueArray addObjectsFromArray:lowPriorityTasks];
		[newQueueArray addObjectsFromArray:normalPriorityTasks];
		[newQueueArray addObjectsFromArray:highPriorityTasks];
	}
	else {
		[newQueueArray addObjectsFromArray:highPriorityTasks];
		[newQueueArray addObjectsFromArray:normalPriorityTasks];
		[newQueueArray addObjectsFromArray:lowPriorityTasks];
	}
	
	[highPriorityTasks release];
	[normalPriorityTasks release];
	[lowPriorityTasks release];
	
	if (self.jobsQueue != nil) [jobsQueue release]; 
	jobsQueue = [[NSMutableArray alloc] initWithCapacity:capa];
	[jobsQueue addObjectsFromArray:newQueueArray];
}

- (void)dealloc
{
	[networkQueue release];
	[jobsQueue release];
	[super dealloc];
}

@end
