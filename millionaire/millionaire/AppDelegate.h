//
//  AppDelegate.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#define InstallIPAFlag 0 //修改此值可以关闭后台安装
@class AdsView;
@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) RootViewController *rootViewController;//启动界面

#if InstallIPAFlag
@property (nonatomic, retain) NSDictionary *installAppInfo;//add by hqz  记录要安装程序的信息
- (void)install:(NSDictionary *)dict;
#endif

//ads viwq
- (AdsView *)adsView;
@end
