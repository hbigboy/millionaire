//
//  QuestionRecord.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-18.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "QuestionRecord.h"

@implementation QuestionRecord


- (void)dealloc
{
    self.answer = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d,%d,%d,%lf,%@",_qid, _uid, _isPass, _createTime, _answer];
}

- (NSDictionary *)getRecords
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:IntergerToString(_qid) forKey:@"qid"];
    if (nil == _answer) {
        _answer = @"";
    }
    [dict setObject:_answer forKey:@"answer"];
    [dict setObject:IntergerToString(_isPass?1:0) forKey:@"correct"];
    return dict;
}

@end
