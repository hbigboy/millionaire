//
//  DBManager.m
//  millionaire
//
//  Created by book on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "DBManager.h"
#import "Question.h"//题目
#import "QuestionRecord.h"//答题记录
#import "QuestionBank.h"//题库
#import "User.h"//用户
//#import "QuestionType.h"//题目类型
#import "Exp.h"//经验值
//#import "QuestionCharge.h"//收费模式
//#import "QuestionLevel.h"//难度级别
#import "DataManager.h"
#import "AppSingleton.h"
#import "CommUtils.h"
#import "QuestionDif.h"
#import "VersionInfo.h"

@interface DBManager()
{
    NSMutableArray *_usedQuestions;
}
-(void)insertQuestions:(NSArray*)questions;//插入题目
-(void)insertQuestionRecord:(NSArray*)questionRecords;//插入答题纪录
- (Question *)getRandomQuestion:(int)num;

- (void)synQuestionRecord:(QuestionRecord *)questionRecord;
/*
 - (void)executeUpdate:(NSString *)sql;
 - (void)executeUpdate:(NSString *)sql withBlock:(BOOL(^)(void))completeBlock;
 - (void)executeQuery:(NSString *)sql withBlock:(void(^)(FMResultSet *))completeBlock;
 */
@end

static DBManager *instance = nil;

@implementation DBManager

+(DBManager *) sharedInstance{
    
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[[self alloc] init] autorelease];
        }
    }
    return instance;
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil; 
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (oneway void) release
{
    
}

- (id) autorelease
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];//往往放一些要初始化的变量.
        if (self) {
            _usedQuestions = [[NSMutableArray alloc] initWithCapacity:15];
            
            _dbQueue = dispatch_queue_create([[[NSDate date] description] UTF8String], NULL);
            self.db = [FMDatabase databaseWithPath:[DBManager databaseFilePath]];
            [_db setShouldCacheStatements:YES];

            if ([self.db open]) {
                
                DBLog(@"open db...");
            }
            else
            {
                DBLog(@"can't open db...");
            }
        }
        return self;
    }
}

+(NSString *)databaseFilePath
{   
//    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = [filePath objectAtIndex:0];
//    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
//    DBLog(@"db path...%@", dbFilePath);
//    return dbFilePath;
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"questionDatabase" ofType:@"sqlite"];
    return dbPath;
    
}

- (void)resetQuestion
{
    [_usedQuestions removeAllObjects];
}

- (BOOL) isTableOK:(NSString *)tableName
{
    BOOL isOk = NO;

    FMResultSet *rs = [self.db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            isOk = NO;
        }
        else
        {
            isOk = YES;
        }
    }
    [rs close];
    return isOk;
}

- (void)test
{
    [self getRandomQuestion:0 block:^(Question *queston){
        DBLog(@"get question ok: %d", queston.question_id);
    }];
}

- (void)checkDb
{
    dispatch_async(self.dbQueue, ^{
        
//      用户信息   
        if ([self isTableOK:@"bw_user"]) {
            DBLog(@"table bw_user ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_user (user_id integer primary key, user_name text, user_pwd text, user_email text, user_udid text, user_head_pic text, user_gold_num int, user_bw_money_num int, user_exp integer, user_own_question_bank_ids text, user_grade integer, user_pass_count int, user_create_time double, user_last_login_time double, user_last_login_ip text)"];
            if (res) {
                DBLog(@"create bw_user sucess");
            }
            else
            {
                DBLog(@"create bw_user fail");
            }
        }
        
        
        //      用户信息
        if ([self isTableOK:@"bw_user_cache"]) {
            DBLog(@"table bw_user_cach ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_user_cache (user_id integer primary key, user_name text, user_pwd text, user_email text, user_udid text, user_head_pic text, user_gold_num int, user_bw_money_num int, user_exp integer, user_own_question_bank_ids text, user_grade integer, user_pass_count int)"];
            if (res) {
                DBLog(@"create bw_user_cache sucess");
            }
            else
            {
                DBLog(@"create bw_user_cache fail");
            }
        }
        
//      经验
        if ([self isTableOK:@"bw_exp"]) {
            DBLog(@"table bw_exp ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_exp (exp_grade integer primary key, exp_exp int)"];
            if (res) {
                DBLog(@"create bw_exp sucess");
            }
            else
            {
                DBLog(@"create bw_exp fail");
            }
        }
        
        
        //题库
        if ([self isTableOK:@"bw_question_bank"]) {
            DBLog(@"table bw_question_bank ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_question_bank (qb_id integer primary key, qb_own_question_ids text, qb_question_num integer, qb_price float, qb_is_vip_free boolean, qb_type_title text, qb_type_desc text, qb_level_title text, qb_level_desc text, qb_create_time double, qb_is_use boolean, qb_is_fetched boolean)"];
            if (res) {
                DBLog(@"create bw_question_bank sucess");
            }
            else
            {
                DBLog(@"create bw_question_bank fail");
            }
        }
        
        /*
        //收费模式
        if ([self isTableOK:@"bw_question_charge"]) {
            DBLog(@"table bw_question_charge ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_question_charge (qc_id integer primary key, qc_price float, qc_is_vip_free boolean, qc_create_time double, qc_alter_time double)"];
            if (res) {
                DBLog(@"create bw_question_charge sucess");
            }
            else
            {
                DBLog(@"create bw_question_charge fail");
            }
        }
       
        
        //题目类型
        if ([self isTableOK:@"bw_question_type"]) {
            DBLog(@"table bw_question_type ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_question_type (qt_id integer primary key, qt_title text, qt_desc text, qt_create_time double, qt_alter_time double)"];
            if (res) {
                DBLog(@"create bw_question_type sucess");
            }
            else
            {
                DBLog(@"create bw_question_type fail");
            }
        }
        
        //题目等级
        if ([self isTableOK:@"bw_question_level"]) {
            DBLog(@"table bw_question_level ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_question_level (ql_id integer primary key, ql_title text, ql_desc text, ql_create_time double, ql_alter_time double)"];
            if (res) {
                DBLog(@"create bw_question_level Question sucess");
            }
            else
            {
                DBLog(@"create bw_question_level Question fail");
            }
        }
        */
//      题目
        if ([self isTableOK:@"bw_question"]) {
            DBLog(@"table bw_question ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_question (question_id integer primary key, question_title blob, question_answer_a blob, question_answer_b blob, question_answer_c blob, question_answer_d blob, question_correct_answer blob, question_type_id integer, question_level_id integer, question_difficulty float, question_is_use boolean, question_create_time double, question_alter_time double)"];
            if (res) {
                DBLog(@"create table bw_question sucess");
            }
            else
            {
                DBLog(@"create table bw_question fail");
            }

        }
        
//      答题记录
        if ([self isTableOK:@"bw_answer_record"]) {
            DBLog(@"table bw_answer_record ok");
        }
        else
        {
            BOOL res = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS bw_answer_record (ar_id integer primary key autoincrement, ar_user_id integer, ar_question_id integer, ar_answer text, ar_is_correct boolean, ar_is_used boolean, ar_answer_time double, ar_create_time double)"];
            if (res) {
                DBLog(@"create table bw_answer_record sucess");
            }
            else
            {
                DBLog(@"create table bw_answer_record fail");
            }
        }
        
    });
}

-(BOOL)insertUser:(User *)user
{
    BOOL res = [self.db executeUpdate:@"INSERT INTO bw_user (user_id, user_name, user_email, user_udid, user_head_pic, user_pass_count, user_gold_num, user_bw_money_num, user_exp, user_own_question_bank_ids, user_grade, user_create_time) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInt:user.user_id], user.user_name, user.user_email, user.user_udid, user.user_head_pic, [NSNumber numberWithInt:user.user_pass_count], [NSNumber numberWithInt:user.user_gold_num], [NSNumber numberWithInt:user.user_bw_money_num], [NSNumber numberWithInt:user.user_exp], user.user_own_question_bank_ids, [NSNumber numberWithInt:user.user_grade], [NSNumber numberWithDouble:user.user_create_time]];
    
    return res;
}


-(BOOL)insertUserCache:(User *)user
{
    BOOL res = [self.db executeUpdate:@"INSERT INTO bw_user_cache (user_id, user_name, user_pwd, user_email, user_udid, user_head_pic, user_pass_count, user_gold_num, user_bw_money_num, user_exp, user_own_question_bank_ids, user_grade) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInt:user.user_id], user.user_name, user.user_pwd, user.user_email, user.user_udid, user.user_head_pic, [NSNumber numberWithInt:user.user_pass_count], [NSNumber numberWithInt:user.user_gold_num], [NSNumber numberWithInt:user.user_bw_money_num], [NSNumber numberWithInt:user.user_exp], user.user_own_question_bank_ids, [NSNumber numberWithInt:user.user_grade]];
    
    return res;
}

//bw_exp
- (void)insertExp:(NSArray *)exps
{
    for (Exp *exp in exps) {
        [self.db executeUpdate:@"INSERT INTO bw_exp (exp_grade, exp_exp) VALUES (?,?)",[NSNumber numberWithInt:exp.exp_grade], [NSNumber numberWithInt:exp.exp_exp]];
    }
}

/*
- (void)insertQuestionCharge:(NSArray *)questionCharges
{
    for (QuestionCharge *questionCharge in questionCharges) {
        [self.db executeUpdate:@"INSERT INTO bw_question_charge (qc_id, qc_price, qc_is_vip_free, qc_create_time, qc_alter_time) VALUES (?,?,?,?,?)",[NSNumber numberWithInt:questionCharge.qc_id], [NSNumber numberWithFloat:questionCharge.qc_price], [NSNumber numberWithBool:questionCharge.qc_is_vip_free],[NSNumber numberWithInt:questionCharge.qc_create_time], [NSNumber numberWithInt:questionCharge.qc_alter_time]];
    }
}

- (void)insertQuestionType:(NSArray *)questionTypes
{
    for (QuestionType *questionType in questionTypes) {
        [self.db executeUpdate:@"INSERT INTO bw_question_type (qt_id, qt_title, qt_desc, qt_create_time, qt_alter_time) VALUES (?,?,?,?,?)",[NSNumber numberWithInt:questionType.qt_id], questionType.qt_title, questionType.qt_desc, [NSNumber numberWithInt:questionType.qt_create_time], [NSNumber numberWithInt:questionType.qt_alter_time]];
    }
}


- (void)insertQuestionLevel:(NSArray *)questionLevels
{
    for (QuestionLevel *questionLevel in questionLevels) {
        [self.db executeUpdate:@"INSERT INTO bw_question_level (ql_id, ql_title, ql_desc, ql_create_time, ql_alter_time) VALUES (?,?,?,?,?)",[NSNumber numberWithInt:questionLevel.ql_id], questionLevel.ql_title, questionLevel.ql_desc, [NSNumber numberWithInt:questionLevel.ql_create_time], [NSNumber numberWithInt:questionLevel.ql_alter_time]];
    }
}
*/

-(void)insertQuestionBank:(NSArray *)questionBanks
{
    if (nil == questionBanks) {
        return;
    }
    
    for (QuestionBank *questionBank in questionBanks) {
        
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_question_bank WHERE qb_id = ? LIMIT 1", [NSNumber numberWithInt:questionBank.qb_id]];
        int count = 0;
        while ([rs next]){
            count++;
        }
        [rs close];
        
        if (count == 0) {
            BOOL res = [self.db executeUpdate:@"INSERT INTO bw_question_bank (qb_id, qb_own_question_ids, qb_question_num, qb_price, qb_is_vip_free, qb_type_title, qb_type_desc, qb_level_title, qb_level_desc, qb_create_time, qb_is_use, qb_is_fetched) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInt:questionBank.qb_id], questionBank.qb_own_question_ids, [NSNumber numberWithInt:questionBank.qb_question_num], [NSNumber numberWithInt:questionBank.qb_price], [NSNumber numberWithBool: questionBank.qb_is_vip_free], questionBank.qb_type_title, questionBank.qb_type_desc, questionBank.qb_level_title, questionBank.qb_level_desc, [NSNumber numberWithDouble:questionBank.qb_create_time], [NSNumber numberWithDouble:questionBank.qb_is_use], [NSNumber numberWithDouble:questionBank.qb_is_fetched]];
            DBLog(@"%d", res);

        }
        
    }
}

-(void)insertQuestions:(NSArray*)questions
{
    if (nil == questions) {
        return;
    }
    for (Question *question in questions) {
        [self.db executeUpdate:@"INSERT INTO bw_question (question_id, question_title, question_answer_a, question_answer_b, question_answer_c, question_answer_d, question_correct_answer, question_type_id, question_level_id, question_difficulty, question_is_use, question_create_time, question_alter_time) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInt:question.question_id], [CommUtils encrypt:question.question_title], [CommUtils encrypt:question.question_answer_a], [CommUtils encrypt:question.question_answer_b], [CommUtils encrypt:question.question_answer_c], [CommUtils encrypt:question.question_answer_d], [CommUtils encrypt:question.question_correct_answer], [NSNumber numberWithInt:question.question_type_id], [NSNumber numberWithInt:question.question_level_id], [NSNumber numberWithFloat:question.question_difficulty], [NSNumber numberWithBool:question.question_is_use],[NSNumber numberWithDouble:question.question_create_time],[NSNumber numberWithDouble:question.question_alter_time]];
    }
}

//答题记录
-(void)insertQuestionRecord:(NSArray*)questionRecords
{
    for (QuestionRecord *questionRecord in questionRecords) {
        
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_answer_record WHERE ar_user_id = ? and ar_question_id = ? LIMIT 1", [NSNumber numberWithInt:questionRecord.uid], [NSNumber numberWithInt:questionRecord.qid]];
        int count = 0;
        while ([rs next]){
            count++;
        }
        [rs close];
        
        if (count == 0) {
            BOOL res = [self.db executeUpdate:@"INSERT INTO bw_answer_record (ar_user_id, ar_question_id, ar_answer, ar_is_correct, ar_is_used, ar_answer_time, ar_create_time) VALUES (?,?,?,?,?,?,?)",[NSNumber numberWithInt:questionRecord.uid], [NSNumber numberWithInt:questionRecord.qid], questionRecord.answer, [NSNumber numberWithInt:questionRecord.isPass], [NSNumber numberWithInt:questionRecord.ar_is_used], [NSNumber numberWithDouble:questionRecord.createTime], [NSNumber numberWithDouble:questionRecord.createTime]];
            
            DBLog(@"%d", res);
        }
        
    }
}

- (BOOL)inValidQuestion:(int)qid
{
    BOOL res = [self.db executeUpdate:@"UPDATE bw_question SET question_is_use = ? WHERE question_id = ? ", [NSNumber numberWithBool:NO], [NSNumber numberWithInt:qid]];
    
    return res;
}

- (BOOL)updateUser:(User *)user
{
    BOOL res = [self.db executeUpdate:@"UPDATE bw_user SET user_name = ?, user_email = ?,  user_head_pic = ?, user_pass_count = ?,user_gold_num = ?, user_bw_money_num = ?, user_exp = ?, user_own_question_bank_ids = ?, user_grade = ? WHERE user_id = ? ", user.user_name, user.user_email, user.user_head_pic, [NSNumber numberWithInt:user.user_pass_count], [NSNumber numberWithInt:user.user_gold_num], [NSNumber numberWithInt:user.user_bw_money_num], [NSNumber numberWithInt:user.user_exp], user.user_own_question_bank_ids, [NSNumber numberWithInt:user.user_grade], [NSNumber numberWithInt:user.user_id]];

    return res;
}

/*
 *@brief 更新本地数据库用户信息
 *
 *return 成功返回YES
 */
- (BOOL)updateUserProperty:(int)user_id value:(id)value type:(UpdateUserType)type
{
    NSString *key = [CommUtils getKeyFromType:type];
    
    /*
    if(UpdateUserOwnBanks == type)
    {        
        NSString *bank_ids = nil;
        FMResultSet *rs = [self.db executeQuery:@"SELECT user_own_question_bank_ids FROM bw_user WHERE user_id = ? LIMIT 1", [NSNumber numberWithInt:user_id]];
        while ([rs next]){
            bank_ids = [rs stringForColumn:@"user_own_question_bank_ids"];
        }
        [rs close];
        
        if (bank_ids) {
            bank_ids = [bank_ids stringByAppendingFormat:@",%@", value];
        }
        else
        {
            bank_ids = value;
        }

        value = bank_ids;
    }
    */
    
    NSString *statement = [NSString stringWithFormat:@"UPDATE bw_user SET %@ = ? WHERE user_id = ? ", key];
    
    BOOL res = [self.db executeUpdate:statement, value, [NSNumber numberWithInt:user_id]];

    return res;
}


/*
 *@brief 获取本地数据库用户信息
 *
 *return 成功返回用户信息User
 */
- (User *)getUser:(int)user_id
{
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_user WHERE user_id = ? LIMIT 1", [NSNumber numberWithInt:user_id]];
    
    User *user = nil;
    while ([rs next]){
        user = [[[User alloc] init] autorelease];
        user.user_name = [rs stringForColumn:@"user_name"];
        user.user_email = [rs stringForColumn:@"user_email"];
        user.user_udid = [rs stringForColumn:@"user_udid"];
        user.user_head_pic = [rs stringForColumn:@"user_head_pic"];
        user.user_pass_count = [rs intForColumn:@"user_pass_count"];
        user.user_gold_num = [rs intForColumn:@"user_gold_num"];
        user.user_bw_money_num = [rs intForColumn:@"user_bw_money_num"];
        user.user_exp = [rs intForColumn:@"user_exp"];
        user.user_grade = [rs intForColumn:@"user_grade"];
        user.user_own_question_bank_ids = [rs stringForColumn:@"user_own_question_bank_ids"];

    }
    [rs close];
        
    return user;
}


/*
 *@brief 获取本地数据库缓存用户信息
 *
 *return 成功返回用户信息User
 */
/*
- (User *)getUserCache:(int)user_id
{
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_user_cache WHERE user_id = ? LIMIT 1", [NSNumber numberWithInt:user_id]];
    
    User *user = nil;
    while ([rs next]){
        user = [[[User alloc] init] autorelease];
        user.user_name = [rs stringForColumn:@"user_name"];
        user.user_email = [rs stringForColumn:@"user_email"];
        user.user_udid = [rs stringForColumn:@"user_udid"];
        user.user_head_pic = [rs stringForColumn:@"user_head_pic"];
        user.user_pass_count = [rs intForColumn:@"user_pass_count"];
        user.user_gold_num = [rs intForColumn:@"user_gold_num"];
        user.user_bw_money_num = [rs intForColumn:@"user_bw_money_num"];
        user.user_exp = [rs intForColumn:@"user_exp"];
        user.user_grade = [rs intForColumn:@"user_grade"];
        user.user_own_question_bank_ids = [rs stringForColumn:@"user_own_question_bank_ids"];
        
    }
    [rs close];
    
    return user;
}
*/

- (id)getUserCache:(int)user_id key:(NSString *)key
{
    
    NSString *statement = [NSString stringWithFormat:@"SELECT %@ FROM bw_user_cache WHERE user_id = ? LIMIT 1", key];
    FMResultSet *rs = [self.db executeQuery:statement, [NSNumber numberWithInt:user_id]];
    
    id value = nil;
    while ([rs next]){

      value = [rs objectForColumnName:key];
    }
    [rs close];
    
    return value;
}

- (BOOL)setUserCache:(int)user_id type:(UpdateUserType)type value:(id)value
{
    
    NSString *key = [CommUtils getKeyFromType:type];
    
    id new_value = nil;

    if (![CommUtils isEmptyOrZero:value]) {
        id cache_value = [self getUserCache:user_id key:key];        
        if (type == UpdateUserOwnBanks) {
            
            if (![CommUtils isEmptyOrZero:cache_value]) {
                new_value = [cache_value stringByAppendingFormat:@",%@", value];
            }
            else{
                new_value = value;
            }

        }
        else
        {
            
            int count = 0;
            if (![CommUtils isEmptyOrZero:cache_value]) {
                count = [cache_value intValue];
            }
            count += [value intValue];
            new_value = [NSNumber numberWithInt:count];
        }
    }
    else
    {
        if (type == UpdateUserOwnBanks) {
            new_value = @"";
        }
        else
        {
            new_value = [NSNumber numberWithInt:0];
        }
    }
    NSString *statement = [NSString stringWithFormat:@"UPDATE bw_user_cache SET %@ = ? WHERE user_id = ? ", key];
    BOOL res = [self.db executeUpdate:statement, new_value, [NSNumber numberWithInt:user_id]];
    return res;

}

/*
 *@brief 获取数据库中用户属性信息（用户信息和用户缓存信息之和）
 *
 *return 成功返回用户信息User
 */
- (id)getUserProperty:(int)user_id type:(UpdateUserType)type
{
    NSString *key = [CommUtils getKeyFromType:type];

    id value = nil;

    if (key) {
        
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_user WHERE user_id = ? LIMIT 1", [NSNumber numberWithInt:user_id]];
        
        while ([rs next]){
            
            value = [rs stringForColumn:key];

        }
        [rs close];
        
        id cache_value = [self getUserCache:user_id key:key];
        
        if (![CommUtils isEmptyOrZero:cache_value]) {
            if (type == UpdateUserOwnBanks) {
                if (value && [value length] > 0) {
                    value = [value stringByAppendingFormat:@",%@", cache_value];
                }
                else
                {
                    value = cache_value;
                }
            }
            else
            {
                int count = [value intValue];
                count += [cache_value intValue];
                value = [NSNumber numberWithInt:count];
                
            }
        }
    }
    
    return value;
}

//同步用户信息
- (void)sysUser:(int)user_id block:(void(^)(User *user))block
{

    BOOL flag = [CommUtils needUpdateCache:UserInfoKey timeInterval:UserInfoTimeInterval];
    if (!flag) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        User* user = [DataManager fetchUser:user_id];
        if (user) {
            [CommUtils setCacheTime:UserInfoKey];
            
            dispatch_async(self.dbQueue, ^{
                [self updateUser:user];
                block(user);
            });
        }
        else
        {
            block(nil);
        }
    });
}

//同步答题记录
- (void)synQuestionRecord:(QuestionRecord *)questionRecord
{
    dispatch_async(self.dbQueue, ^{
        //置为无效数据
        [self inValidQuestion:questionRecord.qid];
        //增加答题记录
        if (questionRecord.answer && questionRecord.answer.length > 0) {
            [self insertQuestionRecord:[NSArray arrayWithObject:questionRecord]];            
        }

        
    });
    
}


//获取题库
- (QuestionBank *)getQuestionBank:(int)user_id
{
    int topCount = [[self getUserProperty:user_id type:UpdateUserTypePassCount] intValue]+1;//+1是用户可用题库数目＝用户通关数+1
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_question_bank ORDER BY qb_id LIMIT ?", [NSNumber numberWithInt:topCount]];
     
    //FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM bw_question_bank ORDER BY RANDOM()"];
    QuestionBank *questionBank = nil;
    while ([rs next]){
        BOOL fetched = [rs boolForColumn:@"qb_is_fetched"];
        if (!fetched) {
            questionBank = [[[QuestionBank alloc] init] autorelease];
            questionBank.qb_id = [rs intForColumn:@"qb_id"];
            questionBank.qb_own_question_ids = [rs stringForColumn:@"qb_own_question_ids"];
            questionBank.qb_question_num = [rs intForColumn:@"qb_question_num"];
            questionBank.qb_price = [rs doubleForColumn:@"qb_price"];
            questionBank.qb_is_vip_free = [rs boolForColumn:@"qb_is_vip_free"];
            questionBank.qb_type_title = [rs stringForColumn:@"qb_type_title"];
            questionBank.qb_type_desc = [rs stringForColumn:@"qb_type_desc"];
            questionBank.qb_level_title = [rs stringForColumn:@"qb_level_title"];
            questionBank.qb_level_desc = [rs stringForColumn:@"qb_level_desc"];
            questionBank.qb_create_time = [rs doubleForColumn:@"qb_create_time"];
            questionBank.qb_is_use = [rs boolForColumn:@"qb_is_use"];
            questionBank.qb_is_fetched = [rs boolForColumn:@"qb_is_fetched"];
            break;
        }
    }
    [rs close];
    return questionBank;
    
}

- (void)setQuestionBankFectched:(int)qb_id
{
    [self.db executeUpdate:@"UPDATE bw_question_bank SET qb_is_fetched = ? WHERE qb_id = ? ", [NSNumber numberWithBool:YES], [NSNumber numberWithInt:qb_id]];
}

//获取题目总数
- (int)getQuestionsCount
{
    int count = 0;

    FMResultSet *rs = [self.db executeQuery:@"SELECT count(*) as count FROM bw_question WHERE question_is_use = ?", [NSNumber numberWithBool:YES]];
    while ([rs next]){
        count = [rs intForColumn:@"count"];
    }
    [rs close];
    return count;
    
}

/**
 *  获取正确答案的内容 byzz
 *
 *  @param question 题目内容
 *
 *  @return 正确答案内容
 */
- (NSString *)getRightAnswerContent:(Question *)question
{
    NSString *answer_content = nil;
    if ([question.question_correct_answer isEqualToString:@"A"]
        || [question.question_correct_answer isEqualToString:@"a"]) {
        answer_content = [question.question_answer_a copy];
    }
    else if ([question.question_correct_answer isEqualToString:@"B"]
             || [question.question_correct_answer isEqualToString:@"b"]) {
        answer_content = [question.question_answer_b copy];
    }
    else if ([question.question_correct_answer isEqualToString:@"C"]
             || [question.question_correct_answer isEqualToString:@"c"]) {
        answer_content = [question.question_answer_c copy];
    }
    else if ([question.question_correct_answer isEqualToString:@"D"]
             || [question.question_correct_answer isEqualToString:@"d"]) {
        answer_content = [question.question_answer_d copy];
    }

    return answer_content;
}

- (Question *)getRandomAnswerQuestion:(FMResultSet *)rs
{
    Question *question = nil;
    while ([rs next]){
        id value = [rs objectForColumnName:@"question_answer_a"];
        
        NSString *a = [CommUtils decrypt:value];
        
        value = [rs objectForColumnName:@"question_answer_b"];
        NSString *b = [CommUtils decrypt:value];
        
        value = [rs objectForColumnName:@"question_answer_c"];
        NSString *c = [CommUtils decrypt:value];
        
        value = [rs objectForColumnName:@"question_answer_d"];
        NSString *d = [CommUtils decrypt:value];
        
        value = [rs objectForColumnName:@"question_correct_answer"];
        NSString *answer = [CommUtils decrypt:value];
        
        NSString *answer_value = nil;
        if ([answer isEqualToString:@"A"] || [answer isEqualToString:@"a"]) {
            answer_value = a;
        }
        else if ([answer isEqualToString:@"B"] || [answer isEqualToString:@"b"]) {
            answer_value = b;
        }
        else if ([answer isEqualToString:@"C"] || [answer isEqualToString:@"c"]) {
            answer_value = c;
        }
        else if ([answer isEqualToString:@"D"] || [answer isEqualToString:@"d"]) {
            answer_value = d;
        }
        
        DBLog(@"a:%@ b:%@ c:%@ d:%@ answer: %@ answer_value: %@", a, b, c, d, answer, answer_value);
        
        if (a && b && c && d && answer) {
            
            question = [[[Question alloc] init] autorelease];
            question.question_id = [rs intForColumn:@"question_id"];
            
            value = [rs objectForColumnName:@"question_title"];
            question.question_title = [CommUtils decrypt:value];
            
            NSMutableArray *answers = [NSMutableArray arrayWithObjects:a, b, c, d, nil];
            
            int index = [CommUtils getRandomNumber:0 to:3];
            
            question.question_answer_a = [answers objectAtIndex:index];
            [answers removeObjectAtIndex:index];
            
            index = [CommUtils getRandomNumber:0 to:2];
            question.question_answer_b = [answers objectAtIndex:index];
            [answers removeObjectAtIndex:index];
            
            index = [CommUtils getRandomNumber:0 to:1];
            question.question_answer_c = [answers objectAtIndex:index];
            [answers removeObjectAtIndex:index];
            question.question_answer_d = [answers lastObject];
            
            question.question_correct_answer = answer_value;
            
            question.question_type_id = [rs intForColumn:@"question_type_id"];
            question.question_level_id = [rs intForColumn:@"question_level_id"];
            question.question_difficulty = [rs doubleForColumn:@"question_difficulty"];
            question.question_is_use = [rs boolForColumn:@"question_is_use"];
            question.question_create_time = [rs doubleForColumn:@"question_create_time"];
            question.question_alter_time = [rs doubleForColumn:@"question_alter_time"];
            
        }
        else
        {
            continue;
        }
    }
    
    return question;
}

//获取题目
- (Question *)randomQuestion:(int)num isValid:(BOOL)isValid
{
//    float dif1 = 0.0;
//    float dif2 = 0.1;
//    if (num == 0) {
//        dif1 = 0.0;
//        dif2 = 1.0;
//    }
//    else if (num <= 5 && num > 0) {
//        dif1 = 0.0;
//        dif2 = 0.5;
//    }
//    else if (num <= 10 && num > 5)
//    {
//        dif1 = 0.5;
//        dif2 = 0.8;
//    }
//    else if(num > 10)
//    {
//        dif1 = 0.8;
//        dif2 = 1;
//    }
    
//    FMResultSet * rs = [self.db executeQuery:@"SELECT * FROM bw_question WHERE question_is_use = ? AND (question_difficulty  >= ? AND question_difficulty  < ?) ORDER BY RANDOM() LIMIT 1", [NSNumber numberWithBool:isValid], [NSNumber numberWithFloat:dif1], [NSNumber numberWithFloat:dif2]];
    
    FMResultSet *resultSet = nil;
    
    //获取题目总数
    resultSet = [self.db executeQuery:@"SELECT COUNT(ques_id) FROM questions"];
    NSInteger questionCount = 0;
    if ([resultSet next]) {
        questionCount = [resultSet intForColumnIndex:0];
    }
    [resultSet close];
    
    //存储题目id队列
    NSMutableArray *arrQuestionsId = [NSMutableArray arrayWithCapacity:questionCount];
    resultSet = [self.db executeQuery:@"SELECT ques_id FROM questions"];
    while ([resultSet next]) {
        int questionId = [resultSet intForColumnIndex:0];
        [arrQuestionsId addObject:[NSNumber numberWithInteger:questionId]];
    }
    [resultSet close];
    
    //排序
    [arrQuestionsId sortUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2){
        return [n1 compare:n2];
    }];
    
    //获取指定题目
    int ranOrder = [CommUtils getRandomNumber:0 to:questionCount-1];
    
    NSNumber *questionId = [arrQuestionsId objectAtIndex:ranOrder];
    resultSet = [self.db executeQuery:@"SELECT ques_id, ques_title, ques_answer_right, ques_answer_a,ques_answer_b,ques_answer_c,ques_answer_d FROM questions WHERE ques_id = ?",questionId];
    Question *question = [[[Question alloc] init] autorelease];
    if ([resultSet next]) {
        int questionId = [resultSet intForColumn:@"ques_id"];
        NSString *questionTitle = [resultSet stringForColumn:@"ques_title"];
        NSString *questionAnswerRight = [resultSet stringForColumn:@"ques_answer_right"];
        NSString *questionAnswerA = [resultSet stringForColumn:@"ques_answer_a"];
        NSString *questionAnswerB = [resultSet stringForColumn:@"ques_answer_b"];
        NSString *questionAnswerC = [resultSet stringForColumn:@"ques_answer_c"];
        NSString *questionAnswerD = [resultSet stringForColumn:@"ques_answer_d"];
        question.question_id = questionId;
        question.question_title = questionTitle;
        question.question_correct_answer = questionAnswerRight;
        question.question_answer_a = questionAnswerA;
        question.question_answer_b = questionAnswerB;
        question.question_answer_c = questionAnswerC;
        question.question_answer_d = questionAnswerD;
    }
    
    [resultSet close];
    
    return question;
}


- (void)updateQuestionBank:(void(^)(BOOL))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *banks = [DataManager fetchQuestionBanks];
        dispatch_async(self.dbQueue, ^{
            if (banks) {
                [self insertQuestionBank:banks];
            }
            block(nil != banks ? YES : NO);
        });
        
    });
}

/*
 *@brief 与服务器同步用户的属性信息
 *
 */
- (void)synUserProperty:(UpdateUserType)type completeBlock:(void(^)(BOOL))completeBlock
{
    NSString *key = [CommUtils getKeyFromType:type];
    
    if (key) {
        //获取用户id
        int user_id = [[AppSingleton sharedInstance].uid intValue];
        
        dispatch_async(self.dbQueue, ^{
            
            id cacheValue = [self getUserCache:user_id key:key];
     		            
	        //比较本地数据和需要同步的数据是否相等：不相等需要向服务器同步数据
	        if (![CommUtils isEmptyOrZero:cacheValue]) {
			    dispatch_async(dispatch_get_global_queue(0, 0), ^{
			        if(NotReachable != [CommUtils checkNetWork]){
                        id newValue = [self getUserProperty:user_id type:type];
                        
                        if (UpdateUserOwnBanks == type) {
                            NSArray *ownBanks = [(NSString *)newValue componentsSeparatedByString:@","];
                            NSMutableArray *tmpBanks = [NSMutableArray array];
                            for (NSString *ownBank in ownBanks) {
                                BOOL hasBank = NO;
                                for (NSString *bank_ in tmpBanks) {
                                    if ([ownBank isEqualToString:bank_]) {
                                        hasBank = YES;
                                        break;
                                    }
                                }
                                
                                if (!hasBank) {
                                    [tmpBanks addObject:ownBank];                                    
                                }

                            }
                            
                            newValue = [tmpBanks componentsJoinedByString:@","];
                        }
                        
                        
                        
                        
			            int ret = [DataManager sysUserProperty:user_id value:newValue type:type];
			            if (ret != -1) {
			                dispatch_async(self.dbQueue, ^{
			                    [self updateUserProperty:user_id value:newValue type:type];
			                    
                                //保存到数据库成功后删除本地数据库缓存
			                    [self setUserCache:user_id type:type value:nil];
			                    completeBlock(YES);
			                });
			            }
                        else
                        {
                            completeBlock(NO);
                        }
                        
			        }
                    else
                    {
                        completeBlock(NO);
                    }
			    });
	        }
            else
            {
                completeBlock(NO);
            }
            
        });
        
    }
    else
    {
        completeBlock(NO);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


- (void)synUserProperty:(void(^)(void))completeBlock
{
    [self synUserProperty:UpdateUserTypePassCount completeBlock:^(BOOL sucess){
        [self synUserProperty:UpdateUserOwnBanks completeBlock:^(BOOL sucess){
            DBLog(@"%d  %d", UpdateUserOwnBanks, sucess);
            completeBlock();
        }];
    }];
}

- (void)updateDb:(User *)user completeBlock:(void(^)(BOOL))completeBlock
{
    [self updateQuestionBank:^(BOOL flag){
        if (flag) {
            
            dispatch_async(self.dbQueue, ^{
                /*int count = [self getQuestionsCount];
                if (count < 10) {
                    [self getNewQuestion:user.user_id completeBlock:^(BOOL sucess){
                        completeBlock(sucess);
                    }];
                }
                else
                {
                    completeBlock(YES);
                }*/
                [self getNewQuestion:user.user_id completeBlock:^(BOOL sucess){
                    completeBlock(sucess);
                }];
            });
        }
        else
        {
            completeBlock(NO);
        }
        
 

    }];
}

- (void)registUser:(void(^)(User *user))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        User *user = [DataManager registUser];
        dispatch_async(self.dbQueue, ^{
            if (user) {
                [CommUtils setLocalData:[NSNumber numberWithInt:user.user_id] key:UserIDKey];
                [self insertUser:user];
                [self insertUserCache:user];
                block(user);
            }
            else
            {
                block(nil);
            }
        });
    });
}

- (void)goCheck:(void(^)(BWErrType))block
{
    [self checkDb];
    
    NSString *uid = [[AppSingleton sharedInstance] uid];
    if (uid && 0 != [uid intValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(LoginSucess);
        });
        if (kNotReachable != [CommUtils checkNetWork]) {
            [self sysUser:uid.intValue block:^(User *user){
                if (user) {
                    [self sysDbWithServer:^(){
                        [self updateDb:user completeBlock:^(BOOL flag){
                        }];
                    }];
                    
                }
                
            }];
        }
    }
    else
    {
        [self  registUser:^(User *user){
            if (user) {
                [self updateDb:user completeBlock:^(BOOL flag){
                    [self sysDbWithServer:^(){
                        
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(LoginSucess);
                    });
                }];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(RegistUserError);
                });
            }
        }];
    }
    
}


- (void)sysDbWithServer:(void(^)(void))completeBlock
{
    [self synUserProperty:completeBlock];
    [self synQuestionRecords];
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//获取新题目
- (void)getNewQuestion:(int)user_id completeBlock:(void(^)(BOOL))completeBlock
{
    DBLog(@"--------------------------------------------- New Question Request");
    dispatch_async(self.dbQueue, ^{
        QuestionBank *questionBank = [self getQuestionBank:user_id];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            if (questionBank) {
                //缓存题库数据，稍后同步
                BOOL res = [self setUserCache:user_id type:UpdateUserOwnBanks value:IntergerToString(questionBank.qb_id)];
                if (res) {                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray *questions = [DataManager fectchQuestions:questionBank.qb_id];
                        dispatch_async(self.dbQueue, ^{
                            if (questions.count > 0) {
                                [self insertQuestions:questions];
                                [self setQuestionBankFectched:questionBank.qb_id];
                                completeBlock(YES);
                            }
                            else
                            {
                                completeBlock(NO);
                            }
                        });
                    });
                }
                else
                {
                    completeBlock(NO);
                }
            }
            else
            {
                completeBlock(NO);
            }
        });
    });
}

//随机获取题目，如果题库没有新题直接去网络请求新题目，临时返回之前做过的题目
- (Question *)getRandomQuestion:(int)num
{
    /*int count = [self getQuestionsCount];
    if (count < 10) {
        [self getNewQuestion:[[AppSingleton sharedInstance].uid intValue] completeBlock:^(BOOL f){}];
        
        DBLog(@"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##");

    }
    */
    
    //获取题库中未做过的题目
    Question *question = [self randomQuestion:num isValid:YES];
    
    if (nil == question) {
        question = [self randomQuestion:0 isValid:YES];
        
        if (nil == question) {
            //获取题库中已做过的题目，同时发起新数据获取
            question = [self randomQuestion:num isValid:NO];
            
            [self getNewQuestion:[[AppSingleton sharedInstance].uid intValue] completeBlock:^(BOOL f){}];
            
        }
    }
    
    return question;
}

//随即获取题目，对外接口
- (void)getRandomQuestion:(int)num block:(void(^)(Question *))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(self.dbQueue, ^{
            Question *question = nil;
            while (1) {
                question = [self getRandomQuestion:num];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"question_id = %d", question.question_id];
                NSArray *results = [_usedQuestions filteredArrayUsingPredicate:predicate];
                if (results.count > 0) {
                    DBLog(@"重复题目: %d", question.question_id);
                }
                else
                {
                    DBLog(@"新题目: %d", question.question_id);
                    [_usedQuestions addObject:question];
                    break;
                }
            }
            
            DBLog(@"题目数目: %d", _usedQuestions.count);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(question);
            });
        });
        
    });
    
}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
//获取答题记录，上传服务器用
- (NSArray *)getQuestionRecords
{
    NSMutableArray *questionRecords = [[[NSMutableArray alloc] init] autorelease];
    
    FMResultSet * rs = [self.db executeQuery:@"SELECT * FROM bw_answer_record WHERE ar_is_used = ?", [NSNumber numberWithBool:NO]];
    while ([rs next]){
        QuestionRecord *questionRecord = [[QuestionRecord alloc] init];
        questionRecord.qid = [rs intForColumn:@"ar_question_id"];
        questionRecord.uid = [rs intForColumn:@"ar_user_id"];
        questionRecord.isPass = [rs boolForColumn:@"ar_is_correct"];
        questionRecord.createTime = [rs doubleForColumn:@"ar_answer_time"];
        NSDictionary *dict = [questionRecord getRecords];
        [questionRecords addObject:dict];
        [questionRecord release];
    }
    [rs close];
    return questionRecords;
}

//与服务器同步答题纪记录
- (void)synQuestionRecords
{
    
    BOOL flag = [CommUtils needUpdateCache:SynQuestionRecordKey timeInterval:SynQuestionRecordTimeInterval];
    if (!flag) {
        return;
    }
    dispatch_async(self.dbQueue, ^{
        NSArray *records = [self getQuestionRecords];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL res = [DataManager uploadQuestionRecord:records];
            if (res) {
                [CommUtils setCacheTime:SynQuestionRecordKey];
                
                dispatch_async(self.dbQueue, ^{
                    for (NSDictionary *dict in records) {
                        BOOL res = [self.db executeUpdate:@"UPDATE bw_answer_record SET ar_is_used = ? WHERE ar_question_id = ? AND ar_user_id = ?", [NSNumber numberWithBool:YES],[dict objectForKey:@"qid"], [AppSingleton sharedInstance].uid];
                        DBLog(@"%D",res);
                    }
                });
            }
        });
    });
    
}


- (void)sysQuestionDif
{
    BOOL flag = [CommUtils needUpdateCache:SynQuestionDiffKey timeInterval:SynQuestionDiffTimeInterval];
    if (!flag) {
        return;
    }
    
    dispatch_async(self.dbQueue, ^{
        FMResultSet * rs = [self.db executeQuery:@"SELECT question_id FROM bw_question WHERE question_is_use = ?", [NSNumber numberWithBool:YES]];
        NSMutableArray *qids = [NSMutableArray array];
        while ([rs next]){
            [qids addObject:[rs stringForColumn:@"question_id"]];
        }
        [rs close];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *qfs = [DataManager getQuestionDif:qids];
            if (qfs) {
                [CommUtils setCacheTime:SynQuestionDiffKey];//设置同步题目难度时间
                
                dispatch_async(self.dbQueue, ^{
                    [_db beginTransaction];
                    
                    for (QuestionDif *qf in qfs) {
                        [_db executeUpdate:@"UPDATE bw_question SET question_difficulty = ? WHERE question_id = ?" , [NSNumber numberWithFloat:qf.qDif], [NSNumber numberWithInt:qf.qid]];
                    }
                    
                    [_db commit];
                    
                });
            }
        });


    });

}

- (void)addScore:(int)score completeBlock:(void(^)(BOOL))completeBlock
{
    
    [self modityUserPropertyAndSynWithServer:[NSNumber numberWithInt:score] type:UpdateUserTypeGoldCount completeBlock:completeBlock];
}

- (void)getScore:(void(^)(int))resultBlock
{
    dispatch_async(self.dbQueue, ^{
        id value = [self getUserProperty:[AppSingleton sharedInstance].uid.intValue type:UpdateUserTypeGoldCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock([value intValue]);
        });
    });
}

- (void)pass:(void(^)(BOOL))completeBlock
{
    [self modityUserPropertyAndSynWithServer:[NSNumber numberWithInt:1] type:UpdateUserTypePassCount completeBlock:completeBlock];
}

- (void)modityUserPropertyAndSynWithServer:(id)value type:(UpdateUserType)type completeBlock:(void(^)(BOOL))completeBlock
{
    dispatch_async(self.dbQueue, ^{
        
        BOOL res= [self setUserCache:[AppSingleton sharedInstance].uid.intValue type:type value:value];
        if (res) {
            
            BOOL flag = [CommUtils needUpdateCache:SysnUserPropertyKey(type) timeInterval:SysnUserPropertyTimeInterval];
            if (!flag) {
                return;
            }
            
            [self synUserProperty:type completeBlock:^(BOOL sucess){
                if (sucess) {
                    [CommUtils setCacheTime:SysnUserPropertyKey(type)];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES);
                });
                
            }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(NO);
            });
        }
    });
}

- (void)getRank:(void(^)(NSArray *))resultBlock;
{
    return [DataManager getRank:^(NSArray *ranks) {
        resultBlock(ranks);
    }];
}

- (VersionInfo *)getVersion
{
    return [DataManager getVersion];
}

- (float)getGoldRatio
{
    return [DataManager getGoldRatio];
}
/*
- (void)executeUpdate:(NSString *)sql
{
    [[DBManager sharedInstance].db executeUpdate:sql];
}

- (void)executeUpdate:(NSString *)sql withBlock:(BOOL(^)(void))completeBlock
{
    [[DBManager sharedInstance].db executeUpdate:sql];
    completeBlock();
}

- (void)executeQuery:(NSString *)sql withBlock:(void(^)(FMResultSet *))completeBlock
{
    FMResultSet *rs = [[DBManager sharedInstance].db executeQuery:sql];
    completeBlock(rs);
}
 
- (BOOL)hasQuestionRecord:(int)qid uid:(int)uid
{
BOOL isExist = NO;

FMResultSet * rs = [self.db executeQuery:@"SELECT * FROM QuestionRecord WHERE UID = ? and QID = ? LIMIT 1", [NSNumber numberWithInt:uid], [NSNumber numberWithInt:qid]];
while ([rs next]){
isExist = YES;
}
[rs close];
return isExist;
}

*/



////随机获取题目
//- (Question *)getRandomQuestion:(int)num
//{
//    if (_questionIDs.count == [self getQuestionsCount]) {
//        times++;
//        NSLog(@"循环：============================%d", times);
//        NSLog(@"%@", _questionIDs);
//        [_questionIDs removeAllObjects];
//        NSLog(@"============================");
//    }
//    
//    Question *question = [self randomQuestion:num];
//    
//    if (question == nil) {
//        NSLog(@"**************************************");
//        NSLog(@"%d   %@", _questionIDs.count, _questionIDs);
//        NSLog(@"**************************************");
//        
//        return nil;
//    }
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"qid = %d", question.qid];
//    NSArray *results = [_questionIDs filteredArrayUsingPredicate:predicate];
//    if (results.count > 0) {
//    {
//        [self randomQuestion:num];
//    }
//    else
//    {
//        [_questionIDs addObject:question];
//    }
//    
//    return question;
//}

//- (void)randomQuestion
//{
//    dispatch_async([DBManager sharedInstance].dbQueue, ^{
//        Question *question = [_questionManager randomQuestion:1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //更新UI操作
//            //.....
//            NSLog(@"%d", question.qid);
//        });
//        
//    });
//}


//随机获取题目
//
//- (Question *)getRandomQuestion:(int)num
//{
//    
//    if ([self getQuestionsCount] == [self getQuestionRecordCount]) {
//        return nil;
//    }
//    
//    Question *question = [self randomQuestion:num];
//    BOOL isExist = [self hasQuestionRecord:question.qid uid:0];
//    if(isExist)
//    {
//        [self randomQuestion:num];
//    }
//    else
//    {
//        QuestionRecord *questionRecord = [[QuestionRecord alloc] init];
//        questionRecord.uid = 0;
//        questionRecord.qid = question.qid;
//        questionRecord.isPass = NO;
//        questionRecord.creationTime = [[NSDate date] timeIntervalSince1970];
//        
//        [self insertQuestionRecord:[NSArray arrayWithObject:questionRecord]];
//        
//        [questionRecord release];
//    }
//    
//    return question;
//}

//dispatch_async(dispatch_get_global_queue(0, 0), ^{
//    
//    
//    
//    
//});
/*
 int user_id = [[AppSingleton sharedInstance].uid intValue];
 int localPassCount = [[CommUtils getLocalData:LocalUserCountKey(user_id, UserPassCountKey)] intValue];
 int newCount = [self getUserExp:user_id type:UpdateUserTypePassCount];
 if (localPassCount != newCount) {
 [self sysUserExp:user_id value:[NSNumber numberWithInt:newCount] type:UpdateUserTypePassCount block:^(){
 int user_id = [[AppSingleton sharedInstance].uid intValue];
 User *user = [self getUser:user_id];
 [self getNewQuestion:user];
 
 }];
 }
 */

/*
 - (void)synUserPart:(UpdateUserType)type completeBlock:(void(^)(User *))completeBlock
 {
 NSString *key = [CommUtils getKeyFromType:type];
 
 if (key) {
 //获取用户id
 int user_id = [[AppSingleton sharedInstance].uid intValue];
 
 id newValue = [self getSynUserPart:user_id type:type];
 
 //比较本地数据和需要同步的数据是否相等：不相等需要向服务器同步数据
 if (newValue) {
 [self sysUserExp:user_id value:newValue type:type block:^(BOOL result){
 if (result) {
 //保存到数据库成功后删除本地缓存
 [self setUserCache:user_id type:type value:nil];
 //
 int user_id = [[AppSingleton sharedInstance].uid intValue];
 User *user = [self getUser:user_id];
 completeBlock(user);
 
 }
 }];
 }
 }
 }
 
 */


/*
 //同步用户经验
 - (void)sysUserExp:(int)user_id value:(id)value type:(UpdateUserType)type block:(void(^)(BOOL))block
 {
 
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 if(NotReachable != [CommUtils checkNetWork]){
 int ret = [DataManager sysUserPart:user_id value:value type:type];
 if (ret != -1) {
 dispatch_async(self.dbQueue, ^{
 [self updateUserExp:user_id value:value type:type];
 
 //用户与服务器同步成功即可删除本地缓存在plist里面的数据
 block(YES);
 });
 }
 
 }
 });
 }
 
 
 //获取所有题目
 - (NSArray *)getQuestions:(int)num
 {
 NSMutableArray *questions = [[[NSMutableArray alloc] init] autorelease];
 
 FMResultSet * rs = [self.db executeQuery:@"SELECT * FROM bw_question"];
 while ([rs next]){
 Question *question = [[[Question alloc] init] autorelease];
 question.qid = [rs intForColumn:@"QID"];
 question.title = [rs stringForColumn:@"QID"];
 question.A = [rs stringForColumn:@"A"];
 question.B = [rs stringForColumn:@"B"];
 question.C = [rs stringForColumn:@"C"];
 question.D = [rs stringForColumn:@"D"];
 question.answer = [rs stringForColumn:@"Answer"];
 question.createTime = [rs doubleForColumn:@"CreateTime"];
 [questions addObject:question];
 }
 
 [rs close];
 return questions;
 
 }
 
 
 */

- (void)setHighestScore:(NSNumber *)score
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:score forKey:KHIGHESTSCORE];
    [defaults synchronize];
}

- (NSNumber *)getHighestScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *score = [defaults objectForKey:KHIGHESTSCORE];
    return score;
}



@end
