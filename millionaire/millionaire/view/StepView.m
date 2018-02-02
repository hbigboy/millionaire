//
//  StepView.m
//  millionaire
//
//  Created by HuangZizhu on 13-8-17.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "StepView.h"
#import "StepItemView.h"
#import <QuartzCore/QuartzCore.h>

#define vItemW (25)
#define Point_One_Center CGPointMake(10, 74)

@interface StepView ()

@property (nonatomic, retain) UIImageView *imgvBg;

@property (nonatomic, retain) StepItemView *enemyItem; //对战

- (void)initSubviews;
@end

@implementation StepView

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
    self.imgvBg = nil;
    self.enemyItem = nil;
    [super dealloc];
}

//路线图
- (void)initSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    CGRect rc = self.frame;
    rc.origin.x = 0;
    rc.origin.y = 0;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rc];
    self.imgvBg = imgv;
    UIImage *image = [UIImage imageNamed:@"game_step_bg.png"];
    imgv.image = image;
    [self addSubview:imgv];
    [imgv release];
    
    [self initNumbers];
    [self addEnemyItem];
}

//1到15的数字
- (void)initNumbers
{
    int xGap = 54;
    int yGap = 27;
    
    CGPoint point = Point_One_Center;
    
    CGRect fr = CGRectMake(0, 0, vItemW, vItemW);
    
    
    for (int i=1; i<=6; i++) {
        
        StepItemView *item = [[StepItemView alloc] initWithFrame:fr];
        item.center = point;
        [self.imgvBg addSubview:item];
        [item setNumber:IntergerToString(i)];
        item.lbNum.hidden = YES;
        [item release];
        point.x += xGap;
    }
    
    point.x -= xGap;
    point.y -= yGap;
    
    for (int i=7; i<=11; i++) {
        
        StepItemView *item = [[StepItemView alloc] initWithFrame:fr];
        item.center = point;
        [self.imgvBg addSubview:item];
        [item setNumber:IntergerToString(i)];
        item.lbNum.hidden = YES;
        [item release];
        point.x -= xGap;
        
    }
    
    point.x += xGap;
    point.x += xGap/2;
    point.y -= (yGap-1);
    
    for (int i=12; i<=15; i++) {
        
        StepItemView *item = [[StepItemView alloc] initWithFrame:fr];
        item.center = point;
        [self.imgvBg addSubview:item];
        [item setNumber:IntergerToString(i)];
        item.lbNum.hidden = YES;
        [item release];
        point.x += xGap;
        
    }
}

- (void)addEnemyItem
{
    if (!self.enemyItem) {
        self.enemyItem = [[StepItemView alloc] initWithFrame:CGRectMake(0, 0, vItemW, vItemW)];
        self.enemyItem.center = Point_One_Center;
        [self.enemyItem setAsEnemyItem];
        [self addSubview:self.enemyItem];
    }
}

- (void)setStep:(NSInteger)step
{
    NSArray *arr = [self.imgvBg subviews];
    
    //从前一点移动到后一点的动画
    StepItemView *item01 = nil;
    StepItemView *item02 = nil;
    
    if (step > 1) {
        for (UIView *view in arr) {
            StepItemView *item = (StepItemView *)view;
            item.lbNum.hidden = YES;
            if ([item.lbNum.text integerValue] == step-1) {
                item01 = item;
            }
            if ([item.lbNum.text integerValue] == step) {
                item02 = item;
            }
        }
    }
    
    CGRect rc = item01.frame;
    [UIView animateWithDuration:1.0 animations:^(){
        item01.frame = item02.frame;
    }completion:^(BOOL finished){
        item01.frame = rc;
        item01.lbNum.hidden = YES;
        [self updateItemsStatus:step];
    }];
    
}

- (void)updateItemsStatus:(NSInteger)step
{
    NSArray *arr = [self.imgvBg subviews];

    for (UIView *view in arr) {
        if ([view isKindOfClass:[StepItemView class]]) {
            StepItemView *item = (StepItemView *)view;
            if ([item.lbNum.text integerValue] < step) {
                [item setStatus:itemStatus_passed];
            } else if ([item.lbNum.text integerValue] == step) {
                [item setStatus:itemStatus_current];
            } else if ([item.lbNum.text integerValue] > step) {
                [item setStatus:itemStatus_notReach];
            }
        }
    }
}

//联机
- (void)setMyStep:(NSInteger)step
{
    [self setStep:step];
}
- (void)setEnemyStep:(NSInteger)step
{
    NSArray *arr = [self.imgvBg subviews];
    
    
    
    //从前一点移动到后一点的动画
    StepItemView *item01 = nil;
    
    if (step >= 1) {
        for (UIView *view in arr) {
            StepItemView *item = (StepItemView *)view;
            
            if ([item.lbNum.text integerValue] == step) {
                item01 = item;
            }
        }
    }
    
    if (step == 1) {
        self.enemyItem.frame = item01.frame;
        return;
    }
    
    [UIView animateWithDuration:1.0 animations:^(){
        self.enemyItem.frame = item01.frame;
    }completion:^(BOOL finished){
        
    }];
}



@end
