//
//  AdsView.m
//  millionaire
//
//  Created by zizhu on 13-9-7.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "AdsView.h"
#import "YouMiSpot.h"
#define YouMiAppID          @"16b570bba42d1307"//@"ff83cb4806413897"
#define YouMiAppSecret      @"ad55116de25f95b3"//@"2cb71ffe2bd39a62"

@implementation AdsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initYoumi
{
    [YouMiConfig launchWithAppID:YouMiAppID appSecret:YouMiAppSecret];
    // 启动积分墙
    [YouMiWall enable];
}


- (void)addYouMiView:(UIView *)view
{
    //[self.window makeKeyAndVisible];
    // 设置显示全屏广告的window
    [YouMiConfig setFullScreenWindow:self.window];
}


- (BOOL)showYoumi:(void (^)())dismiss
{
    [YouMiSpot requestSpotADs:NO];
    return [YouMiSpot showSpotDismiss:dismiss];
}

@end
