//
//  Question.m
//  millionaire
//
//  Created by book on 13-7-17.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "Question.h"
//@property (nonatomic, copy) NSString *question_title;
//@property (nonatomic, copy) NSString *question_answer_a;
//@property (nonatomic, copy) NSString *question_answer_b;
//@property (nonatomic, copy) NSString *question_answer_c;
//@property (nonatomic, copy) NSString *question_answer_d;
//@property (nonatomic, copy) NSString *question_correct_answer;

@implementation Question
- (void)dealloc
{
    self.question_title = nil;
    self.question_answer_a = nil;
    self.question_answer_b = nil;
    self.question_answer_c = nil;
    self.question_answer_d = nil;
    self.question_correct_answer = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d,%@,%@,%@,%@,%@",_question_id, _question_title, _question_answer_a, _question_answer_b, _question_answer_c, _question_answer_d];
}

//@property (nonatomic, retain)  id question_title;
//@property (nonatomic, retain) id question_answer_a;
//@property (nonatomic, retain) id question_answer_b;
//@property (nonatomic, retain) id question_answer_c;
//@property (nonatomic, retain) id question_answer_d;
//@property (nonatomic, retain) id question_correct_answer;



@end
