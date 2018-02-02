//
//  QuestionItemView.m
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "QuestionItemView.h"
#import "Question.h"
@implementation QuestionItemView
- (void)dealloc
{
    [_activityIndicator release];
    [_titleLb release];
    [_answerA release];
    [_answerB release];
    [_answerC release];
    [_answerD release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width-20, 30)];
        
        CGRect rc = CGRectMake(_titleLb.left, _titleLb.bottom+5, _titleLb.right - _titleLb.left, 30);
        _answerA = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        _answerA.frame = rc;
        
        rc = CGRectMake(_answerA.left, _answerA.bottom+5, _answerA.width, _answerA.height);
        _answerB = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        _answerB.frame = rc;
        
        rc = CGRectMake(_answerA.left, _answerB.bottom+5, _answerA.width, _answerB.height);
        _answerC = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        _answerC.frame = rc;
        
        rc = CGRectMake(_answerA.left, _answerC.bottom+5, _answerA.width, _answerA.height);
        _answerD = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        _answerD.frame = rc;
//        _answerB = [[UIButton alloc] initWithFrame:CGRectMake(_answerA.left, _answerA.bottom+5, _answerA.width, _answerA.height)];

//        _answerC = [[UIButton alloc] initWithFrame:CGRectMake(_answerA.left, _answerB.bottom+5, _answerA.width, _answerB.height)];
//        _answerD = [[UIButton alloc] initWithFrame:CGRectMake(_answerA.left, _answerC.bottom+5, _answerA.width, _answerA.height)];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.width-30)/2, (self.height-30)/2, 30, 30)];

        [_answerA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_answerB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_answerC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_answerD setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_titleLb];
        [self addSubview:_answerA];
        [self addSubview:_answerB];
        [self addSubview:_answerC];
        [self addSubview:_answerD];
        [self addSubview:_activityIndicator];
        
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_activityIndicator startAnimating];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setQuestion:(Question *)question
{
    _titleLb.text = [NSString stringWithFormat:@"题目: %@", question.title];
    [_answerA setTitle:[NSString stringWithFormat:@"A: %@", question.A] forState:UIControlStateNormal];
    [_answerB setTitle:[NSString stringWithFormat:@"B: %@", question.B] forState:UIControlStateNormal];
    [_answerC setTitle:[NSString stringWithFormat:@"C: %@", question.C] forState:UIControlStateNormal];
    [_answerD setTitle:[NSString stringWithFormat:@"D: %@", question.D] forState:UIControlStateNormal];


    
    [_activityIndicator stopAnimating];
}

@end
