//
//  GameView.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-17.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "GameView.h"
#import "WaitingView.h"
#import "QuestionView.h"
#import "TimerView.h"
#import "WinGameView.h"
#import "ScoreView.h"
#import "CheckPointsView.h"
#import "StepView.h"

@interface GameView()
{
    UIButton        *_backButton;
    WaitingView     *_waitingView;  //该版本不用
    QuestionView    *_questionView;
    WinGameView     *_winGameView;  //答对答错页面
    
    TimerView       *_timerView;    //计时器
    StepView        *_stepView;     //第几关的路线
    CheckPointsView *_checkView;    //金币数
}

@end


@implementation GameView

- (void)dealloc
{
    self.lbLevel = nil;
    self.lbScore = nil;
    self.stepView = nil;
    [_timerView release];
    [_waitingView release];
    [_questionView release];
    [_winGameView release];
    [_checkView release];
    [_stepView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addBgView];
        
        [self initStepView];

       _backButton = [self addBackButton];
        
        //计时器
        CGRect rc = CGRectMake(20, 130, 280, 40);
        if ([UIDevice isRunningOniPhone5]) {
            rc.origin.y += 60;
        }
        _timerView = [[TimerView alloc] initWithFrame:rc];
        _timerView.backgroundColor = [UIColor clearColor];
        
        //得分
        rc.origin.y = _timerView.bottom + 5 - 20;
        if ([UIDevice isRunningOniPhone5]) {
            rc.origin.y += 10;
        }
        rc.size.width = 150;

        self.lbScore = [[[ScoreView alloc] initWithFrame:rc] autorelease];
        _lbScore.right = 300;
        [self addSubview:self.lbScore];
        
        
        rc = CGRectMake(0, 180, 320, 280);
        if ([UIDevice isRunningOniPhone5]) {
            rc.origin.y += 80;
        }
        _waitingView = [[WaitingView alloc] initWithFrame:rc];
        _questionView = [[QuestionView alloc] initWithFrame:rc]; //题目及答案
        
        [self addSubview:_timerView];
        
        //[self addSubview:_waitingView];
        [self addSubview:_questionView];
             
        //显示级别
        rc.origin.x = 120;
        rc.origin.y = 10;
        rc.size.width = 210;
        rc.size.height = 60;
        
        UILabel *lb = [[UILabel alloc] initWithFrame:rc];
        [lb setFont:[UIFont systemFontOfSize:20]];
        [lb setText:@""];
        lb.backgroundColor = [UIColor clearColor];
        self.lbLevel = lb;
        [lb release];
        //[self addSubview:self.lbLevel];
        
        rc.size.height = 21;
        rc.size.width = 131;
        _checkView = [[CheckPointsView alloc] initWithFrame:rc];
        [self addSubview:_checkView];
        if ([UIDevice isRunningOniPhone5]) {
            _checkView.top += 20;
        }
        rc = self.bounds;
        _winGameView = [[WinGameView alloc] initWithFrame:rc];
        _winGameView.alpha = 0;
        [self addSubview:_winGameView];
        
    }
    return self;
}

- (void)initStepView
{
    if (!_stepView) {
        _stepView = [[StepView alloc] initWithFrame:CGRectMake(12, 40, 290, 83)];
        [self addSubview:_stepView];
    }
    self.stepView = _stepView;
    if ([UIDevice isRunningOniPhone5]) {
        _stepView.top += 30;
    }
    //[_stepView setStep:8];
}


- (void)addBackHomeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    
    [_backButton addTarget:self action:@selector(stopTimer) forControlEvents:controlEvents];
    [_backButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)stopTimer
{
    [_winGameView stopTimer];    //进入下一题的计时器
    [_timerView stopTimer];      //当前题目答题时间的计时器
}

- (QuestionView *)questionView
{
    return _questionView;
}

- (WaitingView *)waitingView
{
    return _waitingView;
}

- (TimerView *)timerView
{
    return _timerView;
}

- (WinGameView *)winGameView
{
    return _winGameView;
}

- (CheckPointsView *)checkPointsView
{
    return _checkView;
}

- (ScoreView *)scoreView
{
    return _lbScore;
}

- (void)reset
{
    [_timerView reset];
    [_waitingView resetReadyGoLabel];
    [_questionView reset];
    _winGameView.alpha = 0;
}
/*
 *
 * 答题相关界面数据或事件绑定
 *
 */
- (void)setQuestion:(Question *)question
{
    [_questionView setQuestion:question];
}

/*
- (void)setScore:(int)score
{
    //[_lbScore setScore:score];
    [_lbScore setTimerViewScore:score timeoutBlock:^(){
        
    }];
    [_lbScore startTimer];
}
 */

- (void)addSelectTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_questionView addSelectTarget:target action:action forControlEvents:controlEvents];
}
@end
