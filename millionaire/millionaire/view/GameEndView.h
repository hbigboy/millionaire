//
//  GameOverView.h
//  millionaire
//
//  Created by zizhu on 13-7-30.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EndBaseView.h"

typedef enum _eEndViewType
{
    endViewPassThrought = 0,
    endViewWrongAnswer = 1,
    endViewTimeout = 2,
}eEndViewType;

@interface GameEndView : EndBaseView
@property (nonatomic, copy) void(^callBack)(int);
- (void)setEndViewType:(eEndViewType)type;
- (void)setScore:(NSInteger)score;
@end
