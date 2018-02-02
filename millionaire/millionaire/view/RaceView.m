//
//  RaceView.m
//  millionaire
//
//  Created by HuangZizhu on 13-9-2.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RaceView.h"
#import "ScoreView.h"
#import "TimerView.h"
#import "RaceViewController.h"

@interface RaceView()
@property (nonatomic, copy) void(^callBack)(void);
@property (nonatomic, retain) UILabel *lbTip;
@end

@implementation RaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initSubviews];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.callBack = nil;
    self.btnBack = nil;
    self.lbTip = nil;
    [super dealloc];
}

- (void)initSubviews
{
    [self addBgView];
    self.btnBack = [self addBackButton];
    self.lbScore.hidden = YES; //隐藏分数，对战不使用分数
    
    [self addLabelTip];
    
}

- (void)addLabelTip
{
    if (!self.lbTip) {
        //文本提示控件
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        lb.textAlignment = UITextAlignmentCenter;
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont boldSystemFontOfSize:22];
        
        CGPoint p;
        p.x = [self timerView].center.x;
        p.y = [self timerView].frame.origin.y;
        p.y += (lb.frame.size.height/2 + 20);
        lb.center = p;
        
        self.lbTip = lb;
        [lb release];
        
        self.lbTip.text = @"123";
        self.lbTip.hidden = NO;
        [self addSubview:self.lbTip];
    }
}

- (void)removeLabelTip
{
    if (self.lbTip) {
        [self.lbTip removeFromSuperview];
        self.lbTip = nil;
    }
}

- (void)setLabelTip:(NSString *)strText
{
    if (self.lbTip) {
        self.lbTip.text = strText;
    }
}



- (void)showResultAnimation:(NSNumber *)isRight
{
    BOOL bRight = [isRight boolValue];
    MLog(@"show answer result animation : %d", bRight);
    
    int scale = 3.5;
    
    if (!self.lbTip) {
        [self addLabelTip];
    }
    if (bRight) {
        self.lbTip.text = @"答案正确";
    } else {
        self.lbTip.text = @"错误!";
    }
    
    CGPoint center = self.lbTip.center;
    CGRect rc = self.lbTip.frame;
    rc.size.width *= scale;
    rc.size.height *= scale;
    self.lbTip.frame = rc;
    self.lbTip.center = center;
    self.lbTip.font = [UIFont boldSystemFontOfSize:22*scale];
    
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.lbTip.transform = CGAffineTransformMakeScale(0.4, 0.4);
    }completion:^(BOOL finish){
        int delay = 1.0;
        [self performSelector:@selector(removeLabelTip) withObject:nil afterDelay:delay];
        
        if (self.controller && [self.controller respondsToSelector:@selector(answerResult:)]) {
            [self.controller performSelector:@selector(answerResult:) withObject:isRight afterDelay:delay];
        }
    }];
    
}



- (void)lock:(NSNumber *)second block:(void(^)(void))block
{
    self.callBack = block;
    [self.timerView setTimerView:[second intValue] timeOutBlock:block];
    [self.timerView startTimer];
}


- (void)runCallBack;
{
    
    //__block typeof (self)bself = self;
    if (_callBack) {
        
        //[bself ]
        _callBack();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
