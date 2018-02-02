//
//  GameOverViewController.h
//  millionaire
//
//  Created by zizhu on 13-7-30.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GameEndView.h"
@interface GameEndViewController : BaseViewController
@property (nonatomic, retain) GameEndView *gameEndView;
- (void)newGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setShareImage:(UIImage *)image;
@end
