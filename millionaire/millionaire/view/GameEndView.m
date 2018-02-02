//
//  GameOverView.m
//  millionaire
//
//  Created by zizhu on 13-7-30.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "GameEndView.h"
#import "Constants.h"

@interface GameEndView()
@property (nonatomic, retain) UIButton *shareBtn;
@property (nonatomic, retain) UIButton *shareBtn2;
@end

@implementation GameEndView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(112, 272, 100, 100)];
//        [_shareBtn setImage:[UIImage imageNamed:@"wx_fri.png"] forState:UIControlStateNormal];
        _shareBtn.layer.borderWidth = 1.0;
        _shareBtn.layer.borderColor = [[UIColor redColor] CGColor];
        _shareBtn.layer.cornerRadius = 15.0;
        
        [_shareBtn setImage:[UIImage imageNamed:@"weixinIcon.png"] forState:UIControlStateNormal];
        [self addSubview:_shareBtn];
        
        CGRect frame = _shareBtn.frame;
        frame.size.height = 20;
        frame.origin.y += 80;
        UILabel *lbTip = [[UILabel alloc] initWithFrame:frame];
        lbTip.textAlignment = UITextAlignmentCenter;
        lbTip.text = @"询问答案";
        lbTip.font = [UIFont systemFontOfSize:18];
        lbTip.textColor = [UIColor colorWithRed:48/255.0 green:160/255.0 blue:133/255.0 alpha:1.0];
        lbTip.backgroundColor = [UIColor clearColor];
        [self addSubview:lbTip];
        [lbTip release];
        
        [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _shareBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(_shareBtn.right + 16, _shareBtn.top, 32, 32)];
//        [_shareBtn2 setImage:[UIImage imageNamed:@"wx_fris.png"] forState:UIControlStateNormal];
//        [self addSubview:_shareBtn2];
        [_shareBtn2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnToMainView.hidden = YES;
    }
    return self;
}

- (void)dealloc
{
    [_shareBtn2 release];
    [_shareBtn release];
    [super dealloc];
}

- (void)setEndViewType:(eEndViewType)type
{
    //通关奖励页面
    if (type == endViewPassThrought) {
        
        [self setGamePassEndView];
    }
    
    //失败页面
    else if (type == endViewWrongAnswer || type == endViewTimeout) {
        
        [self setGameFailedEndView];
    }
}

- (void)setGamePassEndView
{
    //设置为通关的页面
    UIImage *image = [UIImage imageNamed:@"gamePass_header.png"];
    self.imgvHead.image = image;
    image = [UIImage imageNamed:@"gamePass_text.png"];
    self.imgvResult.image = image;
//    image = [UIImage imageNamed:@"endView_score_count.png"];
//    self.imgvScore.image = image;
    image = [UIImage imageNamed:@"gamePass_tip.png"];
    self.imgvTip.image = image;
    self.imgvTip.hidden = YES;
}
- (void)setGameFailedEndView
{
    //设置为挑战失败的页面
    UIImage *image = [UIImage imageNamed:@"gameFailed_header.png"];
    self.imgvHead.image = image;
//    image = [UIImage imageNamed:@"gameFailed_text.png"];
//    self.imgvResult.image = image;
//    image = [UIImage imageNamed:@"endView_score_count.png"];
//    self.imgvScore.image = image;
//    image = [UIImage imageNamed:@"gameFailed_tip.png"];
//    self.imgvTip.image = image;
    
    
}

- (void)setScore:(NSInteger)score
{
    self.lbScore.text = [NSString stringWithFormat:@"%d 分",score];
    
    NSNumber *numHScore = [[DBManager sharedInstance] getHighestScore];
    NSInteger hScore = [numHScore integerValue];
    if (score > hScore) {
        hScore = score;
        numHScore = [NSNumber numberWithInteger:hScore];
        [[DBManager sharedInstance] setHighestScore:numHScore];
    }
    
    UILabel *lbHighest = [[UILabel alloc] initWithFrame:self.lbScore.frame];
    int gap = 10;
    CGPoint center = self.lbScore.center;
    center.y += self.lbScore.frame.size.height + gap;
    lbHighest.center = center;
    lbHighest.backgroundColor = [UIColor clearColor];
    //lbHighest.font = self.lbScore.font;
    lbHighest.textAlignment = self.lbScore.textAlignment;
    
    lbHighest.text = [NSString stringWithFormat:@"最高记录 %d", hScore];
    [self addSubview:lbHighest];
    [lbHighest release];
    
}


- (void)shareAction:(UIButton *)btn
{
    
    if (_callBack) {
        if (btn == _shareBtn) {
//            _callBack(0);
            _callBack(1);
        }
        if (btn == _shareBtn2) {
            _callBack(1);
        }
    }

}
@end
