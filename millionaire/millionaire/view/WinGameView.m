//
//  WinGameView.m
//  millionaire
//
//  Created by book on 13-7-21.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "WinGameView.h"

#define kCorrectText @"恭喜你，答对了！"
#define kWrongText @"对不起，答错了！"
#define kTimeOutText @"对不起，时间到了！"
#define kStartNext @"马上开始下一题 [ %d ]" 
#define kGameOver @"答题错误，游戏结束 [ %d ]"

@interface WinGameView()
{
    int count;
    UIView  *_bgMask;
}
@property (nonatomic, retain) UIImageView *imgvHeader; //答对打错的卡通头像
@property (nonatomic, retain) UILabel *lbAnswerResult;
@property (nonatomic, retain) UILabel *lbLevelScore;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, copy) void(^stopBlock)(void);
@end

@implementation WinGameView

- (void)dealloc
{
    self.imgvHeader = nil;
    self.lbAnswerResult = nil;
    self.stopBlock = nil;
    self.lbLevelScore = nil;
    [self.timer invalidate];
    self.timer = nil;
    [_timeLb release];
    [_bgMask release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        //背景蒙层
        _bgMask = [[UIView alloc] initWithFrame:self.bounds];
        _bgMask.backgroundColor = [UIColor blackColor];
        _bgMask.alpha = 0.7;
        [self addSubview:_bgMask];
        
        CGSize size = CGSizeMake(300, 30);
        
        CGRect rc = CGRectZero;
//        CGRect rc;
        rc.size = size;
        
        //答对还是答错
        UILabel *lb = [[UILabel alloc] initWithFrame:rc];
        lb.text = @"";
        lb.textAlignment = UITextAlignmentCenter;
        lb.backgroundColor = [UIColor clearColor];
        [lb setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        lb.textColor = [UIColor whiteColor];
        self.lbAnswerResult = lb;
        [self addSubview:self.lbAnswerResult];
        [lb release];
                
        rc.size.width = 169;
        rc.size.height = 169;
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:rc];
        imgv.center = CGPointMake(self.frame.size.width/2, 130);
        self.imgvHeader = imgv;
        [self addSubview:imgv];
        [imgv release];
        
        rc = CGRectMake(75, _imgvHeader.height - 60, 70, 20);
        //过当前一关的分数
        lb = [[UILabel alloc] initWithFrame:rc];
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont fontWithName:@"DBLCDTempBlack" size:20];
        [_imgvHeader addSubview:lb];
        self.lbLevelScore = lb;
        [lb release];
        
        //倒计时
        size = CGSizeMake(200, 30);
        _timeLb = [[UILabel alloc] initWithFrame:CGRectMake((self.width-size.width)/2, (self.height-size.height)/2, size.width, size.height)];
        _timeLb.textAlignment = UITextAlignmentCenter;
        _timeLb.top = self.lbAnswerResult.bottom + 5;
        _timeLb.textColor = [UIColor whiteColor];
        _timeLb.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLb];
        
    }
    return self;
}

- (void)setAnswerResultView:(eAnswerResult)result
{
    if (result == answerRight) {
        self.lbAnswerResult.text = kCorrectText;
        self.imgvHeader.image = [UIImage imageNamed:@"answerResult_right.png"];
        self.lbLevelScore.hidden = NO;
    } else if (result == answerWrong) {
        self.lbAnswerResult.text = kWrongText;
        self.imgvHeader.image = [UIImage imageNamed:@"answerResult_wrong.png"];
                self.lbLevelScore.hidden = YES;
    } else {
        self.lbAnswerResult.text = kTimeOutText;
        self.imgvHeader.image = [UIImage imageNamed:@"answerResult_wrong.png"];
                self.lbLevelScore.hidden = YES;
    }
}

- (void)setLevelScore:(NSInteger)score
{
    self.lbLevelScore.text = IntergerToString(score);
}

//显示与隐藏
- (void)showView:(BOOL)flag
{
    if (flag)
    {
        _bgMask.alpha = 0.7;
    }
    else
    {
        _bgMask.alpha = 0.0;
    }

}

//倒计时，进入下一道题
- (void)startTimer:(int)seconds block:(void(^)())block
{
    
    self.stopBlock = block;
    count = seconds;
    _timeLb.text = [NSString stringWithFormat:kGameOver, count];

    
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLb) userInfo:nil repeats:YES];
    
    
}

//计时器更新函数，更新倒计时时间
- (void)updateTimeLb
{
    count--;
    
    if (count <= 0) {
        
        _stopBlock();
        [self stopTimer];
    }

    _timeLb.text = [NSString stringWithFormat:kGameOver, count];

}


- (void)stopTimer
{
    self.stopBlock = nil;
    [self.timer invalidate];
    self.timer = nil;
    
}


@end
