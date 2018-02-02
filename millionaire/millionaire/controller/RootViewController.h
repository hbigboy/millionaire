//
//  RootViewController.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
//  用来管理界面的跳转
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <GameKit/GameKit.h>

@interface RootViewController : BaseViewController//<GKLeaderboardViewControllerDelegate>
@property (nonatomic, retain) BaseViewController    *currentViewController;//当前的viewcontroller

- (void)backHomeView;
-(void)showHomeView;
- (void)stopGame;

- (void)getVersion;

- (void)playBackgroundMusic:(NSString *)file;
- (void)stopBackgroundMusic;
- (void)playSoundWithID:(int)index;
- (void)stopSoundWithID:(int)index;

- (void)mute:(BOOL)flag;

@end
