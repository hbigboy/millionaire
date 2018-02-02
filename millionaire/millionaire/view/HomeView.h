//
//  HomeView.h
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface HomeView : BaseView
{
    UIImageView *_imgvLogo;
    UIButton    *_rankButton;
    UIButton    *_coinCountButton;
    UIButton    *_startGameButton;
    UIButton    *_aboutButton;
    UIButton    *_helpButton;
    
    UIButton    *_muteButton;
    UIButton    *_settingButton;
}

- (void)setCoinCount:(NSString *)strCount;

- (void)addStartGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addAboutGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addHelpGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addRaceGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)showRankViewEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

/*
-(void)startGameEvent:(ActionBlock)action;//开始游戏事件
-(void)aboutEvent:(ActionBlock)action;//关于游戏事件
-(void)helpEvent:(ActionBlock)action;//帮助游戏事件
 */
@end
