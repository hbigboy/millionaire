//
//  QuestionLevel.h
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionLevel : NSObject
@property (nonatomic, assign) int ql_id;
@property (nonatomic, copy) NSString *ql_title;
@property (nonatomic, copy) NSString *ql_desc;
@property (nonatomic, assign) double ql_create_time;
@property (nonatomic, assign) double ql_alter_time;

@end
