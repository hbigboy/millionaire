//
//  RankModel.m
//  millionaire
//
//  Created by book on 13-8-2.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RankInfo.h"

@implementation RankInfo
- (void)dealloc
{
    self.upic = nil;
    self.uname = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@" %d %d %@ %d", _order, _uid, _uname, _gold];
}
@end
