//
//  RaceViewController.h
//  millionaire
//
//  Created by HuangZizhu on 13-9-2.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseViewController.h"
#import "GCHelper.h"

@class RaceView;

@interface RaceViewController : BaseViewController <GCHelperDelegate,
                                                    UIAlertViewDelegate>
{
    RaceView *_raceView;
}
@property (nonatomic, copy) void (^completeBlock)(id);
@property (nonatomic, retain) UIImage *image;//暂存题目题片

- (void)nextQuestion;

//处理答题结束，进入下一题的逻辑
- (void)answerResult:(NSNumber *)numIsRight;

@end
