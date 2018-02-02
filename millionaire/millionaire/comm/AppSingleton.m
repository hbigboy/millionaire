//
//  AppSingleton.m
//  millionaire
//
//  Created by book on 13-7-27.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "AppSingleton.h"
static AppSingleton * sharedObj= nil;
@implementation AppSingleton
+ (AppSingleton*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (oneway void) release
{
    
}

- (id) autorelease
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        //往往放一些要初始化的变量.
    }
    
    return self;
}

- (NSString *)uid
{
    NSString *uid = [CommUtils getLocalData:UserIDKey];
    
    return uid;
}

@end
