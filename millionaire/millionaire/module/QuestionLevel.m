//
//  QuestionLevel.m
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "QuestionLevel.h"

@implementation QuestionLevel
- (void)dealloc
{
    self.ql_title = nil;
    self.ql_desc = nil;
    [super dealloc];
}
@end
