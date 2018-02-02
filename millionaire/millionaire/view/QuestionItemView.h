//
//  QuestionItemView.h
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@class Question;
@interface QuestionItemView : BaseView
{
    UILabel *_titleLb;
    UIButton *_answerA;
    UIButton *_answerB;
    UIButton *_answerC;
    UIButton *_answerD;
    
    UIActivityIndicatorView *_activityIndicator;
}

- (void)setQuestion:(Question *)question;
@end
