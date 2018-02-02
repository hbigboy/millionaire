//
//  StepItemView.m
//  millionaire
//
//  Created by HuangZizhu on 13-8-18.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "StepItemView.h"
#import <QuartzCore/QuartzCore.h>

@interface StepItemView ()
@property (nonatomic, retain) UIImageView *imgvPassed;
@property (nonatomic, retain) UIImageView *imgvCurrent;

@property (nonatomic, retain) UIColor *clr01;
@property (nonatomic, retain) UIColor *clr02;
- (void)initSubviews;
@end

@implementation StepItemView

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
    self.lbNum = nil;
    self.imgvCurrent = nil;
    self.imgvPassed = nil;
    self.clr01 = nil;
    self.clr02 = nil;
    [super dealloc];
}

- (void)initSubviews
{
    int fontS = 12;
    self.clr01 = colorRGB(211, 89, 1);
    self.clr02 = colorRGB(254, 230, 64);
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    UIImage *image = [UIImage imageNamed:@"game_passedStep_point.png"];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    point.y -= 1;
    imgv.center = point;
    imgv.image = image;
    self.imgvPassed = imgv;
    self.imgvPassed.hidden = YES;
    [self addSubview:imgv];
    [imgv release];
    
    //point.y += 1;
    image = [UIImage imageNamed:@"game_currentStep_point.png"];
    imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imgv.center = point;
    imgv.image = image;
    self.imgvCurrent = imgv;
    [self addSubview:imgv];
    self.imgvCurrent.hidden = YES;
    [imgv release];
    
    //point.y -= 1;
    CGRect rc = CGRectMake(0, 0, 25, 15);
    UILabel *lbN = [[UILabel alloc] initWithFrame:rc];
    lbN.center = point;
    lbN.font = [UIFont systemFontOfSize:fontS];
    lbN.textAlignment = UITextAlignmentCenter;
    lbN.backgroundColor = [UIColor clearColor];
    lbN.textColor = self.clr01;
    self.lbNum = lbN;
    [self addSubview:lbN];
    [lbN release];
}

- (void)setNumber:(NSString *)strNum
{
    self.lbNum.text = strNum;
}

- (void)setStatus:(NSInteger)status
{
    if (status == itemStatus_notReach) {
        self.imgvCurrent.hidden = YES;
        self.imgvPassed.hidden = YES;
        self.lbNum.textColor = self.clr01;
    } else if (status == itemStatus_current) {
        self.imgvCurrent.hidden = NO;
        self.imgvPassed.hidden = YES;
        self.lbNum.textColor = self.clr02;
    } else if (status == itemStatus_passed) {
        self.imgvPassed.hidden = NO;
        self.imgvCurrent.hidden = YES;
        self.lbNum.textColor = self.clr01;
    }
}

- (void)setAsEnemyItem
{
    self.imgvPassed.hidden = YES;
    self.imgvCurrent.hidden = YES;
    self.layer.cornerRadius = 90.0;
    self.lbNum.textColor = [UIColor blueColor];
    //[self setNumber:@"敌"];
}

@end
