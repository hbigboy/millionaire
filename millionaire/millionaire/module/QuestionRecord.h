//
//  QuestionRecord.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-18.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionRecord : NSObject

@property (nonatomic, assign) int   uid;
@property (nonatomic, assign) int   qid;
@property (nonatomic, assign) BOOL  isPass;
@property (nonatomic, assign) BOOL  ar_is_used;
@property (nonatomic, assign) double    createTime;
@property (nonatomic, copy) NSString      *answer;

- (NSDictionary *)getRecords;
@end
