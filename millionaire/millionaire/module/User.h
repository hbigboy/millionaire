//
//  User.h
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) int user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_pwd;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *user_udid;
@property (nonatomic, copy) NSString *user_head_pic;
@property (nonatomic, assign) int user_pass_count;
@property (nonatomic, assign) int user_gold_num;
@property (nonatomic, assign) int user_bw_money_num;
@property (nonatomic, assign) int user_exp;
@property (nonatomic, copy) NSString *user_own_question_bank_ids;
@property (nonatomic, assign) int user_grade;
@property (nonatomic, assign) double user_create_time;
@property (nonatomic, assign) double user_last_login_time;
@property (nonatomic, copy) NSString *user_last_login_ip;

@end
