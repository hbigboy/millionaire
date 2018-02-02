//
//  Question.h
//  millionaire
//
//  Created by book on 13-7-17.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property (nonatomic, assign) int question_id;
@property (nonatomic, retain)  id question_title;
@property (nonatomic, retain) id question_answer_a;
@property (nonatomic, retain) id question_answer_b;
@property (nonatomic, retain) id question_answer_c;
@property (nonatomic, retain) id question_answer_d;
@property (nonatomic, retain) id question_correct_answer;
@property (nonatomic, assign) int question_type_id;
@property (nonatomic, assign) int question_level_id;
@property (nonatomic, assign) BOOL question_is_use;
@property (nonatomic, assign) float question_difficulty;
@property (nonatomic, assign) double question_create_time;
@property (nonatomic, assign) double question_alter_time;
@end
