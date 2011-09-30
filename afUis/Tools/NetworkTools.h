//
//  untitled.h
//  MomacLibrary
//
//  Created by Mac Mini 1 MoMac on 17/06/10.
//  Copyright 2010 MOMAC FR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkTools : NSObject {

	BOOL connected;
	BOOL aConnectionRequired;
}

@property (nonatomic,assign) BOOL connected;
@property (nonatomic,assign) BOOL aConnectionRequired;

+ (NetworkTools *)sharedTool;
- (BOOL) testNetwork;

@end
