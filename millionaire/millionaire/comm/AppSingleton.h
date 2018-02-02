//
//  AppSingleton.h
//  millionaire
//
//  Created by book on 13-7-27.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSingleton : NSObject
+ (AppSingleton*) sharedInstance;
- (NSString *)uid;
@end
