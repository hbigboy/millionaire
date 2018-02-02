//
//  TimerView.h
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

@interface TimerView : BaseView
@property (nonatomic, copy) void(^timeoutBlock)(void);
//- (void)setTimerViewScore:(int)score timeoutBlock:(void(^)(void))stopBlock;
- (void)setTimerView:(int)time timeOutBlock:(void(^)(void))stopBlock;
- (void)reset;
- (void)startTimer;
- (void)stopTimer;

//- (NSInteger)getScore;
@end
