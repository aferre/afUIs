#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

typedef enum {
	highPriority = 0,	/**< Highest priority possible.*/
	normalPriority,		/**< Normal priority.*/
	lowPriority			/**< Lowest priority possible.*/
} afJobPriority;			/**< Enum used to assign a priority to a job.*/

typedef enum {
	AlwaysReload = 0,
	NeverReload,
	TimeReload,
	None
} afReloadPolicy;

typedef enum {
	OnlyOnWifi = 0,
	Always
} afReloadNetworkPolicy;

@protocol afASIHTTPRequestDelegate;

@interface afASIHTTPRequest : ASIHTTPRequest <ASIHTTPRequestDelegate>{
    //////////////////////////////
	id<afASIHTTPRequestDelegate>			afDelegate;				/**< */
	afJobPriority	priority;			/**< Job priority. See jobPriority enumeration.  */
	//////////////////////////////
	afReloadPolicy cachePolicyType;
	afReloadNetworkPolicy cacheNetworkPolicyType;
	int cacheDuration; //seconds
	NSArray *folderPath;
	NSString *fileName;
	BOOL isCached;
}

//////////////////////////////
@property (nonatomic, assign) id<afASIHTTPRequestDelegate> afDelegate;
@property (nonatomic, assign) afJobPriority priority;
//////////////////////////////
@property (nonatomic,assign) BOOL isCached;
@property (nonatomic,retain) NSArray *folderPath;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,assign) afReloadNetworkPolicy cacheNetworkPolicyType;
@property (nonatomic,assign) afReloadPolicy cachePolicyType;
@property (nonatomic,assign) int cacheDuration;
//////////////////////////////
-(void) setTheDelegate:(id <afASIHTTPRequestDelegate>) del;
//////////////////////////////
+ (id)requestWithURL:(NSURL *)newURL;

- (id) initWithDelegate:(id)aDelegate 
				 andUrl:(NSURL*)aURL 
			andPriority:(int)aPriority;
/**
 @param aDelegate
 @param aURL
 @param aPriority		The priority of the job.
 @param aDelay			The cached data expiration delay.
 @param aFile			The cached file name.
 @param aPath			The file destination.
 @param aLoadingType	See enum.
 @result				The object.
 */
-(id) initWithDelegate:(id)aDelegate 
				andUrl:(NSURL*)aURL 
		   andPriority:(int)aPriority 
			  andDelay:(int)aDelay 
		   andFileName:(NSString*)aFile
	  andDirectoryPath:(NSArray*)aPath
	andCachePolicyType:(afReloadPolicy)theCachePol
	  andNetworkPolicy:(afReloadNetworkPolicy) theNetPol; 

- (void) writeToFile;

- (NSString *) fullPathToFile;

- (NSString *) parentDirectory;

#pragma mark -
#pragma mark === Job Delay handling ===
#pragma mark -

/**
 Function used to check for delay expiration. It should be used only with a cache policy.
 
 @param theJob The queued job.
 @result YES if the job delay has expired. NO if the delay hasn't expired or if there is no the file loading policy is not a cachePolicy.
 */
- (BOOL) checkDelay;

- (BOOL) removeFileAndTimestamp;

- (BOOL) removeTimestamp;

- (void) createTimestamp;

@end
//////////////////////////////

@protocol afASIHTTPRequestDelegate <NSObject>
@optional
- (void)requestStarted:(afASIHTTPRequest *)request;
- (void)requestReceivedResponseHeaders:(afASIHTTPRequest *)request;
- (void)requestFinished:(afASIHTTPRequest *)request;
- (void)requestFailed:(afASIHTTPRequest *)request;

@end