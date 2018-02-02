//
//  GameViewController.h
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
//  主要用来实现游戏界面的相关逻辑

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface GameViewController : BaseViewController <UIAlertViewDelegate>

@property (nonatomic, retain) Question *question;

- (void)gameOver:(void(^)(int, int, BOOL, UIImage *))actionBlock;
- (void)stopTimer;
@end
