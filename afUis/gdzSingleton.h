//
//  gdzSingleton.h
//
//  Created by Guillaume DROULEZ on 11/05/10.
//  Copyright 2010 thegdz.net. All rights reserved.
//


//
// Macro to place in interface (MyClassName.h)
//
// DECLARE_SINGLETON_FOR_CLASS(MyClassName)
//    => +(MyClassName *)sharedMyClassName method definition
//
#define DECLARE_SINGLETON_FOR_CLASS(classname)\
\
+(classname *)shared##classname;


//
// Macro to place in implementation (MyClassName.m)
//
// SYNTHESIZE_SINGLETON_FOR_CLASS(MyClassName)
//    => static MyClassName *sharedMyClassName = nil;
//    => +(classname *)shared##classname method implementation
//    => +(id)allocWithZone:(NSZone *)zone method override
//    => -(id)copyWithZone:(NSZone *)zone method override
//    => -(id)retain method override
//    => -(NSUInteger)retainCount method override
//    => -(void)release method override
//    => -(id)autorelease method override
//
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+(classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+(id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
-(id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
-(id)retain \
{ \
return self; \
} \
\
-(NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
-(void)release \
{ \
} \
\
-(id)autorelease \
{ \
return self; \
}\
\

