//
//  EndView.m
//  millionaire
//
//  Created by zizhu on 13-7-31.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "EndBaseView.h"

@interface EndBaseView ()
- (void)initSubviews;
@end

@implementation EndBaseView

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
    self.imgvHead = nil;
    //self.lbResult = nil;
    self.imgvResult = nil;
    //self.lbTip = nil;
    self.imgvTip = nil;
    self.imgvScore = nil;
    self.lbScore = nil;
    self.btnToMainView = nil;
    self.btnRetryAgain = nil;
    [super dealloc];
}

- (void)initSubviews
{
    //背景图片
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:self.frame];
    [imgv setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:imgv];
    [imgv release];
    
    CGRect rc = CGRectZero;
    rc.size.width = 122;
    rc.size.height = 119;
    
    CGPoint point;
    point.x = self.frame.size.width/2;
    point.y = 100;
    
    int gap = 10;
    
    //成功或者失败的卡通头像
    imgv = [[UIImageView alloc] initWithFrame:rc];
    imgv.backgroundColor = [UIColor clearColor];
    [imgv setCenter:point];
    [self addSubview:imgv];
    self.imgvHead = imgv;
    [imgv release];
    
    rc.size.width = 66;
    rc.size.height = 15;
    point.y = self.imgvHead.bottom + rc.size.height/2 + gap;
    
    //成功或者失败的表示文字
    //UILabel *lb = [[UILabel alloc] initWithFrame:rc];
    //lb.center = point;
    //lb.textAlignment = UITextAlignmentCenter;
    //[self addSubview:lb];
    //self.lbResult = lb;
    //[lb release];
    
    imgv = [[UIImageView alloc] initWithFrame:rc];
    imgv.backgroundColor = [UIColor clearColor];
    [imgv setCenter:point];
    [self addSubview:imgv];
    self.imgvResult = imgv;
    [imgv release];
    
    rc.size.width = 136;
    rc.size.height = 31;
    point.y = self.imgvResult.bottom +rc.size.height/2 + gap;
    
    //分数
    imgv = [[UIImageView alloc] initWithFrame:rc];
    imgv.backgroundColor = [UIColor clearColor];
    [imgv setCenter:point];
    [self addSubview:imgv];
    self.imgvScore = imgv;
    [imgv release];
    
    point.x += 90;
    UILabel *lb = [[UILabel alloc] initWithFrame:rc];
    CGPoint center = CGPointMake(320/2, point.y);
    lb.center = center;
    lb.textAlignment = UITextAlignmentCenter;
    lb.font = [UIFont fontWithName:@"DBLCDTempBlack" size:26];
    lb.backgroundColor = [UIColor clearColor];
    self.lbScore = lb;
    //lb.center = point;
    [self addSubview:lb];
    [lb release];
    
    rc.size.width = 205;
    rc.size.height = 19;
    point.x = self.frame.size.width/2;
    point.y = self.imgvScore.bottom + rc.size.height/2 + gap;
    //其他文字提示
    //lb = [[UILabel alloc] initWithFrame:rc];
    //lb.center = point;
    //lb.textAlignment = UITextAlignmentCenter;
    //[self addSubview:lb];
    //self.lbTip = lb;
    //[lb release];
    
    imgv = [[UIImageView alloc] initWithFrame:rc];
    imgv.backgroundColor = [UIColor clearColor];
    [imgv setCenter:point];
    [self addSubview:imgv];
    self.imgvTip = imgv;
    [imgv release];
    
    
    rc.size.width = 191;
    rc.size.height = 65;
    point.y = self.imgvTip.bottom + rc.size.height/2 + gap + 30;
    
    
    //返回到主页按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *image = [UIImage imageNamed:@"button_toMainView_normal.png"];
    UIImage *image = [UIImage imageNamed:@"button_toRangView_n.png"];
    [button setImage:image forState:UIControlStateNormal];
    //image = [UIImage imageNamed:@"button_toMainView_pressed.png"];
    image = [UIImage imageNamed:@"button_toRangView_p.png"];
    [button setImage:image forState:UIControlStateHighlighted];
    button.frame = rc;
    button.center = point;
    self.btnToMainView = button;
    [self addSubview:self.btnToMainView];
    
    //重新挑战按钮
    point.y = self.btnToMainView.bottom + rc.size.height/2 + gap + 10;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageNamed:@"button_retryAgain_normal.png"];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"button_retryAgain_pressed.png"];
    [button setImage:image forState:UIControlStateHighlighted];
    button.frame = rc;
    button.center = point;
    self.btnRetryAgain = button;
    [self addSubview:self.btnRetryAgain];
}

@end
