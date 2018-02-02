//
//  QuestionView.h
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

/*typedef enum _answerType {
    AnswerType_Right,
    AnswerType_Fault,
    AnswerType_TimeOut
}AnswerType;*/


@class QButton;
@interface QuestionView : BaseView

- (QButton *)rigthAnswer;

//- (void)showResultView:(AnswerType)type completeBlock:(void(^)(QuestionView *))completeBlock;

//- (void)showResultView:(BOOL)flag;

- (void)validClick:(BOOL)isValid;
- (void)reset;
- (void)setQuestion:(Question *)question;


- (void)addSelectTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
