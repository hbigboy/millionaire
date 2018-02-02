//
//  ScoreView.m
//  millionaire
//
//  Created by book on 13-7-30.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
// 此类用于显示当前得分
//

#import "ScoreView.h"

@interface ScoreView()
{
    
    UIImageView *_imageView;
    UILabel     *_scoreLb;
    
}

@property (nonatomic, copy) void(^timeoutBlock)(void);
@property (nonatomic, copy) void(^timeFireBlock)(void);
@property (nonatomic, assign) int score;
@property (nonatomic, assign) float time;
@property (nonatomic, assign) int   step;
@property (nonatomic, retain) NSTimer   *timer;

@end


@implementation ScoreView

- (void)dealloc
{
    [self stopTimer];
    [_imageView release];
    [_scoreLb release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect rc = CGRectMake(0, 0, self.width, 31);
        _imageView = [[UIImageView alloc] initWithFrame:rc];
        _imageView.image = [[UIImage imageNamed:@"score_bg.png"] stretchableImageWithLeftCapWidth:90 topCapHeight:0];
        [self addSubview:_imageView];
        
        rc = CGRectMake(90, 7, _imageView.width-100, _imageView.height-10);
        _scoreLb = [[UILabel alloc] initWithFrame:rc];
        _scoreLb.backgroundColor = [UIColor clearColor];
        //_scoreLb.textAlignment = UITextAlignmentCenter;
        [_scoreLb setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];

        [self addSubview:_scoreLb];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
- (void)setScore:(int)score
{
    _scoreLb.text = IntergerToString(score);
}
*/

- (void)setTimerViewScore:(int)score timeFireBlock:(void(^)(void))timeFireBlock timeoutBlock:(void(^)(void))timeoutBlock
 {
     self.timeFireBlock = timeFireBlock;
     self.timeoutBlock = timeoutBlock;
     MLog(@"score: %d", score);
     self.score = score;
 
     if (score != 0) {
         if (score >= 10000) {
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
     
//         self.time = (double)15/score;
//         self.step = 1;
     }
     else
     {
         self.time = 0;
     }
 
     _scoreLb.text = [NSString stringWithFormat:@"%d", score];
 }

- (NSInteger)getScore
 {
     return self.score;
 }

//计时器对应的响应函数
- (void)scoreMinus:(NSTimer *)timer
 {
     self.score -= _step;
//     static int times = 0;
//     MLog(@"%d  %d", _score, times++);
 
     if (_score <= 0) {
         _score = 0;     
         if (self.timeoutBlock) {
             _timeoutBlock();
         }
         [self stopTimer];
     }
 
     if (self.timeFireBlock) {
         _timeFireBlock();
     }
     _scoreLb.text = [NSString stringWithFormat:@"%d", _score];
 
 }

/*
- (void)updateTime
{
    if (_time > 0) {
        
        //减少1秒
        _time--;
        
        
    } else {
        
        //超时
        if (self.timeoutBlock) {
            _timeoutBlock();
        }
        [self stopTimer];
    }
    _scoreLb.text = [NSString stringWithFormat:@"%d", (int)_time];
}
 */

- (void)startTimer
{
    MLog(@"start Timer %f", _time);
    if(_time > 0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_time target:self selector:@selector(scoreMinus:) userInfo:nil repeats:YES];
        
    }
}

- (void)stopTimer
{
    self.timeFireBlock = nil;
    self.timeoutBlock = nil;
    [self.timer invalidate];
    self.timer = nil;
    
    MLog(@"stop Timer");
    
}
@end
