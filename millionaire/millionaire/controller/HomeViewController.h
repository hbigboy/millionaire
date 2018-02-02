//
//  HomeViewController.h
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
//  实现功能跳转
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HomeViewController : BaseViewController

//-(void)startGameEvent:(ActionBlock)action;//开始游戏事件
//-(void)aboutEvent:(ActionBlock)action;//关于游戏事件
//-(void)helpEvent:(ActionBlock)action;//帮助游戏事件

- (void)addStartGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addAboutGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addHelpGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addRaceGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)showRankViewEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;
@end
