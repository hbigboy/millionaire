//
//  RaceView.h
//  millionaire
//
//  Created by HuangZizhu on 13-9-2.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "GameView.h"

@class RaceViewController;

@interface RaceView : GameView


@property (nonatomic, assign) RaceViewController *controller;
@property (nonatomic, retain) UIButton *btnBack;

- (void)showResultAnimation:(NSNumber *)isRight; //展示答对答错的动画
- (void)lock:(NSNumber *)second block:(void(^)(void))block;

//提示
- (void)addLabelTip;
- (void)removeLabelTip;
- (void)setLabelTip:(NSString *)strText;


@end
