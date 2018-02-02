//
//  User.m
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "User.h"

@implementation User
- (void)dealloc
{
    self.user_name = nil;
    self.user_pwd = nil;
    self.user_email = nil;
    self.user_udid = nil;
    self.user_head_pic = nil;
    self.user_own_question_bank_ids = nil;
    self.user_last_login_ip = nil;
    [super dealloc];
}

@end
