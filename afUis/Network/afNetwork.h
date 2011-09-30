//
//  afNetwork.h
//  afLibBrowser
//
//  Created by Adrien Ferré on 07/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface afNetwork : NSObject {
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
	
	NetworkStatus theNetworkStatus;
}

@end
