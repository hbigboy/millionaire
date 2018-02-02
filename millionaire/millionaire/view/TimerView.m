//
//  TimerView.m
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "TimerView.h"
#import "TimerProgressView.h"

@interface TimerView()
{
    TimerProgressView  *_progressView;
    UILabel         *_titleLb;
    UILabel         *_timerLb;
    UILabel         *_titleLb2;
}
@property (nonatomic, retain) NSTimer   *timer;
//@property (nonatomic, assign) int       score;  //记录本局金币数，得分
//@property (nonatomic, assign) int       step;
@property (nonatomic, assign) double    time;
@property (nonatomic, assign) double    totalTime;
@end


@implementation TimerView

- (void)dealloc
{
    [_progressView release];
    [_titleLb release];
    [_titleLb2 release];
    [_timerLb  release];
    self.timeoutBlock = nil;
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        _progressView = [[TimerProgressView alloc] initWithFrame: CGRectMake(0, 8, self.width, 6)] ;
        
        //_progressView.progressImage = [UIImage imageNamed:@"progress_bg.png"];
        //_progressView.trackImage = [UIImage imageNamed:@"track_bg.png"];
        
        [self addSubview: _progressView] ;
        
        /*_titleLb = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 57, 20)];
        [_titleLb setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:16]];
        _titleLb.backgroundColor = [UIColor clearColor];
        _titleLb.text = @"倒计时:";
        
        [self addSubview: _titleLb];
        
        //_timerLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.right, _titleLb.top, 50, _titleLb.height)];
        _timerLb.backgroundColor = [UIColor clearColor];
        _timerLb.textAlignment = UITextAlignmentRight;
        [_timerLb setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
        [self addSubview:_timerLb];
        
        //_titleLb2 = [[UILabel alloc] initWithFrame:CGRectMake(_timerLb.right, _timerLb.top, 80, _timerLb.height)];
        _titleLb2.backgroundColor = [UIColor clearColor];
        [_titleLb2 setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
        [self addSubview:_titleLb2];
        
        _titleLb2.text = @" / 15";*/
    
    }
    return self;
}

- (void)reset
{
    self.timeoutBlock = nil;
    //self.score = 0;
    self.time = 0;
    [self.timer invalidate];
    self.timer = nil;
    _timerLb.text = [NSString stringWithFormat:@"%d", (int)self.time];
    
    _progressView.progress = 1;

}

- (void)setTimerView:(int)time timeOutBlock:(void (^)(void))stopBlock
{
    MLog(@"timer time is : %d", time);
    self.timeoutBlock = stopBlock;
    self.time = time;
    self.totalTime = time;
     _timerLb.text = [NSString stringWithFormat:@"%d", (int)_time];
    _progressView.progress = 1;
}

- (void)updateTime
{
    if (_time >= 0.01) {
        
        //减少1秒
        _time-=0.01;
        
        
    } else {
        
        //超时
        if (self.timeoutBlock) {
            _timeoutBlock();
        }
        [self stopTimer];
    }
    _timerLb.text = [NSString stringWithFormat:@"%0.2f", _time];
    _progressView.progress = (float)_time/self.totalTime;
}

- (void)startTimer
{
    MLog(@"start Timer %f", _time);
    if(_time > 0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
    }
}

- (void)stopTimer
{
    self.timeoutBlock = nil;
    [self.timer invalidate];
    self.timer = nil;
    
    MLog(@"stop Timer");
    
}

/*- (void)setTimerViewScore:(int)score timeoutBlock:(void(^)(void))timeoutBlock
{
    self.timeoutBlock = timeoutBlock;
    MLog(@"score: %d", score);
    self.score = score;

    if (score != 0) {
        if (score > 10000) {
            self.time = (double)15/(score/100);
            self.step = 100;
        }
        else if (score > 1000) {
            self.time = (double)15/(score/10);
            self.step = 10;
        }
        else
        {
            self.time = (double)15/score;
            self.step = 1;
        }

    }
    else
    {
        self.time = 0;
    }

    _timerLb.text = [NSString stringWithFormat:@"%d", score];
}*/
/*- (NSInteger)getScore
{
    return self.score;
}*/

//计时器对应的响应函数
/*- (void)scoreMinus:(NSTimer *)timer
{
    self.score -= _step;
    
    if (_score <= 0) {
        _score = 0;

        
        if (self.timeoutBlock) {
            _timeoutBlock();
        }
        
        [self stopTimer];
        
    }
    
    _timerLb.text = [NSString stringWithFormat:@"%d", _score];
    
    
}*/


@end
