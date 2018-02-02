//
//  StepView.h
//  millionaire
//
//  Created by HuangZizhu on 13-8-17.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface StepView : BaseView
- (void)setStep:(NSInteger)step; //单机接口

//对战接口
- (void)setMyStep:(NSInteger)step;
- (void)setEnemyStep:(NSInteger)step;

@end
