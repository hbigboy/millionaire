//
//  DBManager.h
//  millionaire
//
//  Created by book on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

#define DBDebug 0

#if DBDebug
#define DBLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#else
#define DBLog(format, ...)
#endif


@class Question;
@class QuestionRecord;
@class VersionInfo;
@interface DBManager : NSObject

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, assign) dispatch_queue_t dbQueue;//FIFO队列标志
+ (NSString *)databaseFilePath;//数据库存放路径
+ (DBManager *) sharedInstance;//数据库管理单例


- (void)goCheck:(void(^)(BWErrType))block;//数据库检测、升级

//重置下一关答题记录
- (void)resetQuestion;

//获取一个题目正确答案的文本内容
- (NSString *)getRightAnswerContent:(Question *)question;

//获取随机的题目
- (void)getRandomQuestion:(int)num block:(void(^)(Question *))block;

//添加答题记录到本地
- (void)synQuestionRecord:(QuestionRecord *)questionRecord;

//增加用户属性信息本地缓存
- (BOOL)setUserCache:(int)user_id type:(UpdateUserType)type value:(id)value;

//获取用户属性信息（包括本地数据库和本地缓存数据）
- (id)getUserProperty:(int)user_id type:(UpdateUserType)type;

//获取当前登陆用户金币数目
- (void)getScore:(void(^)(int))resultBlock;

//获取排行信息／4小时更新一次
- (void)getRank:(void(^)(NSArray *))resultBlock;

//获取服务器最新版本实时
- (VersionInfo *)getVersion;

//获取答题扣分系数
//- (float)getGoldRatio;

//上传答题记录
- (void)synQuestionRecords;

//同步题目难度
- (void)sysQuestionDif;

//增加金币数
- (void)addScore:(int)score completeBlock:(void(^)(BOOL))completeBlock;

//通关
- (void)pass:(void(^)(BOOL))completeBlock;

//设置最高得分

- (void)setHighestScore:(NSNumber *)score;
//获取最高得分
- (NSNumber *)getHighestScore;

@end
