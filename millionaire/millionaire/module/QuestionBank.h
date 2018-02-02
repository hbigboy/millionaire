//
//  QuestionBank.h
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionBank : NSObject

@property (nonatomic, assign) int qb_id;
@property (nonatomic, copy) NSString *qb_own_question_ids;
@property (nonatomic, assign) int qb_question_num;
@property (nonatomic, assign) float qb_price;
@property (nonatomic, assign) BOOL qb_is_vip_free;
@property (nonatomic, copy) NSString * qb_type_title;
@property (nonatomic, copy) NSString *qb_type_desc;
@property (nonatomic, copy) NSString *qb_level_title;
@property (nonatomic, copy) NSString *qb_level_desc;
@property (nonatomic, assign) double qb_create_time;
@property (nonatomic, assign) BOOL qb_is_use;
@property (nonatomic, assign) BOOL qb_is_fetched;
@end
//qb_id, qb_own_question_ids, qb_question_num, qb_price, qb_is_vip_free, qb_type_title, qb_type_desc, qb_level_title, qb_level_desc, qb_create_time, qb_is_use