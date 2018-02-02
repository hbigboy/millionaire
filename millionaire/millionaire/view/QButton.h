//
//  QButton.h
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

typedef enum _qButtonType{
    qButtonTypeSucess = 0,
    qButtonTypeFail = 1,
    qButtonTypeNomal = 2,
} qButtonType;


@class Question;
@interface QButton : UIButton

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, assign) BOOL isRightAnswer;

- (void)setTitle:(NSString *)title;
- (void)setResultState:(qButtonType)type block:(void(^)(void))block;

@end
