//
//  StepItemView.h
//  millionaire
//
//  Created by HuangZizhu on 13-8-18.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

typedef enum eStepItemStatus
{
    itemStatus_notReach = 0,    //为到达的关卡
    itemStatus_current = 1,     //当前关卡
    itemStatus_passed = 2,      //已经完成的关卡
}_eStepItemStatus;

@interface StepItemView : BaseView
@property (nonatomic, retain) UILabel *lbNum;
- (void)setNumber:(NSString *)strNum;
- (void)setStatus:(NSInteger)status;
- (void)setAsEnemyItem; //设置为表示对方的圆圈
@end
