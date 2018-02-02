//
//  DataManager.h
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class VersionInfo;
@interface DataManager : NSObject


//注册
+ (User *)registUser;

//获取用户信息
+ (User *)fetchUser:(int)user_id;

//修改用户信息
+ (int)sysUserProperty:(int)user_id value:(id)value type:(UpdateUserType)type;

//获取题目
+ (NSArray *)fectchQuestions:(int)qb_id;
+ (NSArray *)fectchQuestionsForGameCenter:(NSString *)key;
+ (BOOL)resetQuestionsForGameCenter:(NSString *)key flag:(int)flag;

//获取题库信息
+ (NSArray *)fetchQuestionBanks;


//上传答题记录
+ (BOOL)uploadQuestionRecord:(NSArray *)records;

//获取排行信息
+ (void)getRank:(void(^)(NSArray *))resultBlock;

//获取题目难度
+ (NSArray *)getQuestionDif:(NSArray *)qids;

//获取版本信息
+ (VersionInfo *)getVersion;

//获取答题扣分系数
+ (float)getGoldRatio;

//获取广告信息
+ (NSDictionary *)getAds:(NSString *)version;

+ (NSDictionary *)getInstall:(NSString *)identifier;
@end
