//
//  QuestionBank.m
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "QuestionBank.h"

@implementation QuestionBank
- (void)dealloc
{
    self.qb_level_desc = nil;
    self.qb_level_title = nil;
    self.qb_type_desc = nil;
    self.qb_type_title = nil;
    self.qb_own_question_ids = nil;
    [super dealloc];
}

@end
