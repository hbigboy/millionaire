//
//  GameView.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-17.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@class WaitingView;
@class QuestionView;
@class WinGameView;
@class TimerView;
@class ScoreView;
@class CheckPointsView;
@class StepView;

@interface GameView : BaseView

@property (nonatomic, retain) UILabel *lbLevel; //记录答题进度
@property (nonatomic, retain) ScoreView *lbScore; //记录本局得分
@property (nonatomic, retain) StepView *stepView; //第几关


- (WaitingView *)waitingView;
- (QuestionView *)questionView;
- (WinGameView *)winGameView;
- (TimerView *)timerView;
- (CheckPointsView *)checkPointsView;
- (ScoreView *)scoreView;
- (void)reset;

- (void)setQuestion:(Question *)question;

//- (void)setScore:(int)score;


//- (void)handleBackAction:(ActionBlock)action;

- (void)addBackHomeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

//答题相关界面数据或事件绑定
- (void)addSelectTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
/*
- (void)handleSelectAEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
- (void)handleSelectBEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
- (void)handleSelectCEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
- (void)handleSelectDEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
*/
@end
