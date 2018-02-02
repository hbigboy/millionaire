//
//  VersionInfo.h
//  millionaire
//
//  Created by book on 13-8-8.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfo : NSObject

@property (nonatomic, copy) NSString *appstoreUrl;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, assign) int  forceUpdate;
@end
