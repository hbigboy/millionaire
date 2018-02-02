//
//  WinGameView.h
//  millionaire
//
//  Created by book on 13-7-21.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

typedef enum _eAnswerResult
{
    answerRight = 0,
    answerWrong = 1,
    answerTimeOut = 2,
    
}eAnswerResult;

@interface WinGameView : BaseView
{
    //UILabel *_scoreLb;  //显示当前金币数
    UILabel *_timeLb;   //显示将要进入下一题的剩余时间
}

- (void)setLevelScore:(NSInteger)score; //显示过一关增加的金币
- (void)showView:(BOOL)flag;
- (void)setAnswerResultView:(eAnswerResult)result;
- (void)startTimer:(int)seconds block:(void(^)())block;
- (void)stopTimer;
@end
