//
//  QuestionView.m
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "QuestionView.h"
#import "Question.h"
#import "QButton.h"

@interface QuestionView()
{
    UIScrollView    *_contentView;
    UILabel *_titleLb;
    UIImageView *_titleBg;
    QButton *_answerA;
    QButton *_answerB;
    QButton *_answerC;
    QButton *_answerD;
    
    UIImageView *_showResultImageView;
}
@end

@implementation QuestionView

- (void)dealloc
{
    [_titleLb release];
    [_answerA release];
    [_answerB release];
    [_answerC release];
    [_answerD release];
    [_titleBg release];
    [_contentView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //题目显示view
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];


        CGRect rc = CGRectMake(10, 10, self.width-20, 30);
        _titleBg = [[UIImageView alloc] initWithFrame:rc];
        _titleBg.image = [UIImage imageNamed:@"question_bg.png"];

        rc.origin.x += 10;
        rc.origin.y += 10;
        rc.size.width -= 20;
        rc.size.height -= 20;
        _titleLb = [[UILabel alloc] initWithFrame:rc];
        [_titleLb setFont:[UIFont boldSystemFontOfSize:20]];
        _titleLb.textColor = [UIColor whiteColor];
        
        int yGap = 5;
        int xGap = 5;
        
        rc = CGRectMake(_titleLb.left, _titleLb.bottom+yGap, 160 - _titleLb.left-5, 38);
        
        _answerA = [[QButton buttonWithType:UIButtonTypeCustom] retain];
        _answerA.frame = rc;

        rc = CGRectMake(_answerA.right+xGap, _answerA.top, _answerA.width, _answerA.height);
        _answerB = [[QButton buttonWithType:UIButtonTypeCustom] retain];
        _answerB.frame = rc;
        
        rc = CGRectMake(_answerA.left, _answerB.bottom+yGap, _answerA.width, _answerA.height);
        _answerC = [[QButton buttonWithType:UIButtonTypeCustom] retain];
        _answerC.frame = rc;
        
        rc = CGRectMake(_answerB.left, _answerC.top, _answerA.width, _answerA.height);
        _answerD = [[QButton buttonWithType:UIButtonTypeCustom] retain];
        _answerD.frame = rc;
                
            
        [_titleLb setNumberOfLines:5];
        [_titleLb setBackgroundColor:[UIColor clearColor]];

        [_contentView addSubview:_titleBg];
        [_contentView addSubview:_titleLb];
        [_contentView addSubview:_answerA];
        [_contentView addSubview:_answerB];
        [_contentView addSubview:_answerC];
        [_contentView addSubview:_answerD];
        
        CGSize size = CGSizeMake(200, 200);
        _showResultImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-size.width)/2, (self.height-size.height)/2, size.width, size.height)];
        _showResultImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showResultImageView.alpha = 0;
        
        [self addSubview:_contentView];
        [self addSubview:_showResultImageView];

    }
    return self;
}


- (void)setQuestion:(Question *)question
{
    _titleLb.text = [NSString stringWithFormat:@"%@", question.question_title];
    
    if (_titleLb.text.length >= 64 ) {
        _titleLb.font = [UIFont systemFontOfSize:16];
    } else if (_titleLb.text.length >= 56) {
        _titleLb.font = [UIFont systemFontOfSize:18];
    }
    
    
    CGRect rc = CGRectMake(10, 10, self.width-20, 120);
    
    float offset = 20;
    
    CGSize size = [_titleLb.text sizeWithFont:_titleLb.font constrainedToSize:CGSizeMake(rc.size.width-offset*2, 2000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    int yGap = 20;
    if (size.height+offset*2>rc.size.height) {
        rc.size.height = size.height+offset*2;
        yGap = 10;
    }
    
    _titleBg.frame = rc;

    rc = CGRectMake(_titleBg.left+offset, _titleBg.top+offset, _titleBg.width-offset*2, _titleBg.height-offset*2);
    
    [_titleLb setFrame:rc];
    
    _answerA.top = _titleBg.bottom+yGap;
    _answerB.top = _answerA.top;
    _answerC.top = _answerB.bottom+yGap;
    _answerD.top = _answerC.top;
    [_contentView setContentSize:CGSizeMake(self.width, _answerD.bottom)];


    [_answerA setTitle:question.question_answer_a];
    _answerA.answer = question.question_answer_a;
    [_answerB setTitle:question.question_answer_b];
    _answerB.answer = question.question_answer_b;
    [_answerC setTitle:question.question_answer_c];
    _answerC.answer = question.question_answer_c;
    [_answerD setTitle:question.question_answer_d];
    _answerD.answer = question.question_answer_d;
    
    _answerA.isRightAnswer = [question.question_correct_answer isEqualToString:_answerA.answer] ? YES : NO;
    _answerB.isRightAnswer = [question.question_correct_answer isEqualToString:_answerB.answer] ? YES : NO;
    _answerC.isRightAnswer = [question.question_correct_answer isEqualToString:_answerC.answer] ? YES : NO;
    _answerD.isRightAnswer = [question.question_correct_answer isEqualToString:_answerD.answer] ? YES : NO;
    
}

- (void)addSelectTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_answerA addTarget:target action:action forControlEvents:controlEvents];
    [_answerB addTarget:target action:action forControlEvents:controlEvents];
    [_answerC addTarget:target action:action forControlEvents:controlEvents];
    [_answerD addTarget:target action:action forControlEvents:controlEvents];
    
}


- (QButton *)rigthAnswer
{
    if (_answerA.isRightAnswer) {
        return _answerA;
    }
    if (_answerB.isRightAnswer) {
        return _answerB;
    }
    if (_answerC.isRightAnswer) {
        return _answerC;
    }
    if (_answerD.isRightAnswer) {
        return _answerD;
    }
    
    return nil;
}

- (void)validClick:(BOOL)isValid
{
    _answerA.userInteractionEnabled = isValid;
    _answerB.userInteractionEnabled = isValid;
    _answerC.userInteractionEnabled = isValid;
    _answerD.userInteractionEnabled = isValid;
    
}

- (void)reset
{
    self.alpha = 0;
    self.userInteractionEnabled = NO;
    [self validClick:YES];
    [_answerA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_answerB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_answerC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_answerD setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_answerA setResultState:qButtonTypeNomal block:^(){}];
    [_answerB setResultState:qButtonTypeNomal block:^(){}];
    [_answerC setResultState:qButtonTypeNomal block:^(){}];
    [_answerD setResultState:qButtonTypeNomal block:^(){}];
    //[self showResultView:NO];


}
/*
- (void)showResultView:(AnswerType)type completeBlock:(void(^)(QuestionView *))completeBlock
{

    if (AnswerType_Right == type) {
        _showResultImageView.image = [UIImage imageNamed:@"question_answer_right.png"];
    }
    else if(AnswerType_Fault == type)
    {
        _showResultImageView.image = [UIImage imageNamed:@"question_anwser_fault.png"];        
    }
    else
    {
        _showResultImageView.image = [UIImage imageNamed:@"question_answer_timeout.png"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _showResultImageView.alpha = 1.0;
    } completion:^(BOOL f1){
        [UIView animateWithDuration:0.3 animations:^{
            _showResultImageView.alpha = 0.1;
        } completion:^(BOOL f2){
            [UIView animateWithDuration:0.3 animations:^{
                _showResultImageView.alpha = 1.0;
            } completion:^(BOOL f3){
                completeBlock(self);
            }];
        }];
    }];
    
}


- (void)showResultView:(BOOL)flag
{
    if (flag) {
        _showResultImageView.alpha = 1;
    }
    else
    {
        _showResultImageView.alpha = 0;
    }
}*/

@end
