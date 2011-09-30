#import "afASIHTTPRequest.h"
#import <afExtensions/afStringExtensions.h>
#import <afExtensions/afFileManagerExtensions.h>

@implementation afASIHTTPRequest
@synthesize afDelegate, priority;
@synthesize cacheDuration, cachePolicyType,cacheNetworkPolicyType,folderPath,fileName,isCached;

#pragma mark -
#pragma mark == Init ==
#pragma mark -

+(id) requestWithURL:(NSURL *)newURL{
	
	return [[[self alloc] initWithDelegate:nil 
								andUrl:newURL 
							   andPriority:normalPriority] autorelease];
}

- (id) initWithDelegate:(id)aDelegate 
				andUrl:(NSURL*)aURL 
		   andPriority:(int)aPriority {
	/////////////////////////////
	if (self = [super initWithURL:aURL]) {
		afDelegate = aDelegate;
		priority = aPriority;
		self.delegate = self;
		isCached = NO;
	}
	return self;
	/////////////////////////////
}

-(void) setTheDelegate:(id <afASIHTTPRequestDelegate>) del{
	afDelegate =del;
}

-(id) initWithDelegate:(id)aDelegate 
				andUrl:(NSURL*)aURL 
		   andPriority:(int)aPriority 
			  andDelay:(int)aDelay 
		   andFileName:(NSString*)aFile
	  andDirectoryPath:(NSArray*)aPath
		andCachePolicyType:(afReloadPolicy)theCachePol
andNetworkPolicy:(afReloadNetworkPolicy) theNetPol{
	/////////////////////////////
	if(self = [super initWithURL:aURL]) {
		self.fileName = aFile;
		self.cacheDuration = aDelay ;
		self.cachePolicyType = theCachePol;
		self.cacheNetworkPolicyType = theNetPol;
		self.folderPath = [[NSArray alloc] initWithArray: aPath];
		self.afDelegate = aDelegate;
		self.priority = aPriority;
		isCached = YES;
	}
	return self;
	/////////////////////////////
}

#pragma mark -
#pragma mark == ASIHTTPRequest delegate methods ==
#pragma mark -

- (void)requestStarted:(ASIHTTPRequest *)req{

	if (afDelegate != NULL && [afDelegate respondsToSelector:@selector(requestStarted:)])
		[afDelegate requestStarted:self];
}

- (void)requestReceivedResponseHeaders:(ASIHTTPRequest *)req{
	if (afDelegate != NULL && [afDelegate respondsToSelector:@selector(requestReceivedResponseHeaders:)])
		[afDelegate requestReceivedResponseHeaders:self];
}

- (void)requestFinished:(ASIHTTPRequest *)req{
	//save according to cache policy, if there is one.
	if (isCached) {
		[self writeToFile];
	}
	if (afDelegate != NULL && [afDelegate respondsToSelector:@selector(requestFinished:)])
		[afDelegate requestFinished:self];
}

- (void)requestFailed:(ASIHTTPRequest *)req{
	if (afDelegate != NULL && [afDelegate respondsToSelector:@selector(requestFailed:)])
		[afDelegate requestFailed:self];
}

#pragma mark 

- (NSString *) fullPathToFile{
	
	NSString *xmlPath = [self parentDirectory];
	xmlPath = [xmlPath stringByAppendingPathComponent:self.fileName];
	return xmlPath;
}

- (NSString *) parentDirectory{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *xmlPath;
	
	for(int i = 0; i < [self.folderPath count]; i++) 
		xmlPath = [documentsDirectory stringByAppendingPathComponent:[self.folderPath objectAtIndex:i]];
	
	return xmlPath;
}

#pragma mark -
#pragma mark == TimeStamp handling == 
#pragma mark -

- (void) createTimestamp{
	
	if (self.cachePolicyType != TimeReload) return;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *err;
	NSString *fileParentFolder = [self parentDirectory];
	NSString *plistPath = [fileParentFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"timestamp%@",self.fileName]];
	
	if([fileManager fileExistsAtPath:plistPath]) {
		return;
	}	
	
	NSDate *now = [NSDate date];
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
	
	NSString *theTimestamp = [outputFormatter stringFromDate:now];
	
	[theTimestamp writeToFile:plistPath atomically:YES encoding:NSUTF8StringEncoding error:&err];	
}

- (BOOL) removeTimestamp{
	
	NSString *jobDirectoryPath = [self parentDirectory];
	
	return [NSFileManager removeFileAtPath:[jobDirectoryPath stringByAppendingPathComponent: [NSString stringWithFormat:@"timestamp%@",self.fileName]]] ;
}

- (void) writeToFile{
	NSFileManager *fileManager =[NSFileManager defaultManager];
	NSString *documentsDirectory = [NSFileManager documentDirectory];
	NSString *queueJobPath;
	
	for(int i=0; i < [self.folderPath count]; i++) {
		queueJobPath = [documentsDirectory stringByAppendingPathComponent:[self.folderPath objectAtIndex:i]];
		BOOL success = [fileManager fileExistsAtPath:queueJobPath];
		if (!success) {
			[fileManager createDirectoryAtPath:queueJobPath withIntermediateDirectories:FALSE attributes:nil error:nil];
		}
	}
	queueJobPath = [queueJobPath stringByAppendingPathComponent:self.fileName];
	
	//if file doesn't already exists
	if(![[NSFileManager defaultManager] fileExistsAtPath:queueJobPath]){
		[[self responseData] writeToFile:queueJobPath atomically:YES];
		[self createTimestamp];
	} 
	//if the file already exists
	else {
		//if policy of object is to be reloaded
		if (self.cachePolicyType == AlwaysReload) {
			[self removeFileAndTimestamp];
			[[self responseData] writeToFile:queueJobPath atomically:YES];
			[self createTimestamp];
		}
		//if policy of object is to be cached, and if there is a delay and this delay is passed
		else if (self.cachePolicyType == TimeReload && [self checkDelay]){
			[self removeFileAndTimestamp];
			[[self responseData] writeToFile:queueJobPath atomically:YES];
			[self createTimestamp];
		}
	}
	
}

- (BOOL) removeFileAndTimestamp{
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *err = nil;
	
	BOOL success = [fm removeItemAtPath:[self parentDirectory] error:&err];
	if (!success || err) {
		NSLog(@"File deletion failed");
		NSLog(@"err: %@",err);
	}
	else{
		[self removeTimestamp];	
	}
	return success;
}

#pragma mark -
#pragma mark === Cache Delay handling ===
#pragma mark -

- (BOOL) checkDelay{
	
	if (self.cacheDuration <= 0 || self.cachePolicyType == NeverReload) return NO;
	
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileParentFolder;
	
	for(int i=0; i < [self.folderPath count]; i++) 
		fileParentFolder = [documentsDirectory stringByAppendingPathComponent:[self.folderPath objectAtIndex:i]];
	
	NSString *plistPath = [fileParentFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"timestamp%@",self.fileName]];
	
	if([fileManager fileExistsAtPath:plistPath]) {
		
		NSString *theTimestamp = [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:&err]; 
		
		NSDate *now = [NSDate date];
		
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
		
		NSDate *timestampDate = [inputFormatter dateFromString:theTimestamp];
		[inputFormatter release];
		
		if ( (int) fabs ([now timeIntervalSinceDate:timestampDate]) > self.cacheDuration) {
			NSLog(@"HAVE TO RELOAD %@ because %d > %d",self.fileName,(int)fabs ([now timeIntervalSinceDate:timestampDate]),self.cacheDuration);
			return YES;
		}
		else {
			NSLog(@"Still %d seconds till reload",(int)fabs ([now timeIntervalSinceDate:timestampDate]));
			return NO;
		}
		
	}
	else {
		NSLog(@"Timestamp does not exist");
	}
	
	return NO;
	
}	


- (void) dealloc {
	/////////////////////////////
	[super dealloc];
	/////////////////////////////
}

@end
