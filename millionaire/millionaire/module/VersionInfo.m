//
//  VersionInfo.m
//  millionaire
//
//  Created by book on 13-8-8.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "VersionInfo.h"

@implementation VersionInfo
- (void)dealloc{
    
    self.appVersion = nil;
    self.appstoreUrl = nil;
    [super dealloc];
}
@end
