//
//  UUID.m
//  millionaire
//
//  Created by book on 13-7-27.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "UUID.h"
#define UUID_KEY (@"MobileUUID")

static UUID *_sharedUUID = nil;


@implementation UUID
@synthesize UUIDString = _UUIDString;


+ (UUID *)sharedUUID;
{
    @synchronized(self)
    {
        if(_sharedUUID == nil)
        {
            _sharedUUID = [[UUID alloc] init];
        }
    }
    return _sharedUUID;
}

- (id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

#pragma mark -
#pragma mark UUIDString
- (NSString *)UUIDString
{
    NSString *uuidString = [[NSUserDefaults standardUserDefaults] objectForKey:UUID_KEY];
    
    if(uuidString && [uuidString length])
    {
        return uuidString;
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(nil);
        CFStringRef stringRef = CFUUIDCreateString(nil, uuidRef);
        uuidString = (NSString *)CFStringCreateCopy(nil, stringRef);
        CFRelease(uuidRef);
        CFRelease(stringRef);
        
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:UUID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return [uuidString autorelease];
    }
    
    return nil;
}

#pragma mark -
#pragma mark dealloc
- (void)dealloc
{
    [_UUIDString release];
    [_sharedUUID release];
    
    [super dealloc];
}

@end
