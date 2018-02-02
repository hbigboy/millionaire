//
//  DataManager.m
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "DataManager.h"
#import "QuestionBank.h"
#import "Question.h"
#import "User.h"
#import "RankInfo.h"
#import "QuestionDif.h"
#import "AppSingleton.h"
#import "VersionInfo.h"
@implementation DataManager



+ (User *)registUser
{
    NSString *uuid = [[UUID sharedUUID] UUIDString];

    NSString *uname = [NSString stringWithFormat:@"name_%@", [uuid shortUrl:uuid]];
//    NSString *upwd = [NSString stringWithFormat:@"pwd_%@", [uuid shortUrl:uuid]];
//    NSString *uname = @"bw_user";
    NSString *upwd = @"bw_123456";
    NSString *url = [NSString stringWithFormat:@"%@udid=%@&uname=%@&upwd=%@", regist_user_url, uuid, uname, upwd];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    User *user = nil;
    if (!request.error) {
        
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            user = [[[User alloc] init] autorelease];
            user.user_udid = uuid;
            user.user_name = uname;
            user.user_pwd = upwd;
            NSDictionary *user_info = [dict objectForKey:@"data"];
            user.user_id = [[user_info objectForKey:@"uid"] intValue];
            }
            
    }
    return user;
}

/*
 *
 *@brief 更新用户信息
 *
 *@return: nil 请求失败
 *
 */
+ (User *)fetchUser:(int)user_id
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_user_url(user_id, [CommUtils getLocalVersion])]];
    [request startSynchronous];
    User *user = nil;
    if (!request.error) {
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *user_infos = [dict objectForKey:@"data"];
            if (user_infos.count > 0) {
                NSDictionary *user_info = [user_infos objectAtIndex:0];
                if (user_id == [[user_info objectForKey:@"uid"] intValue]) {
                    user = [[[User alloc] init] autorelease];
                    user.user_id = user_id;
                    user.user_name = [user_info objectForKey:@"name"];
                    user.user_email = [user_info objectForKey:@"email"];
                    user.user_udid = [user_info objectForKey:@"udid"];
                    user.user_head_pic = [user_info objectForKey:@"pic"];
                    user.user_pass_count = [[user_info objectForKey:@"finish_num"] intValue];
                    user.user_gold_num = [[user_info objectForKey:@"gold"] intValue];
                    user.user_bw_money_num = [[user_info objectForKey:@"bw_money"] intValue];
                    user.user_exp = [[user_info objectForKey:@"exp"] intValue];
                    user.user_grade = [[user_info objectForKey:@"grade"] intValue];
                    user.user_own_question_bank_ids = [user_info objectForKey:@"own_qbids"];
                }

            }
        }
        
    }
    return user;
}

/*
 *
 *@brief 更新用户部分 信息
 *
 *@return: -1 请求失败
 *参数：uid必传，gold为金币数，exp为经验值，qbids拥有题库信息（逗号隔开），grade为等级，fnum为完成次数
 */
+ (int)sysUserProperty:(int)user_id value:(id)value type:(UpdateUserType)type
{
    
    NSString *param = nil;
    switch (type) {
        case UpdateUserOwnBanks:
            param = [NSString stringWithFormat:@"qbids=%@", value];
            break;
        case UpdateUserTypeExpCount:
            param = [NSString stringWithFormat:@"exp=%@", value];
            break;
        case UpdateUserTypeGoldCount:
            param = [NSString stringWithFormat:@"gold=%@", value];
            break;
        case UpdateUserTypeGradeCount:
            param = [NSString stringWithFormat:@"grade=%@", value];
            break;
        case UpdateUserTypePassCount:
            param = [NSString stringWithFormat:@"fnum=%@", value];
            break;
        default:
            break;
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@?uid=%d&%@", update_user_info, user_id, param];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request startSynchronous];
    if (!request.error) {
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            return YES;
        }
    };
    return NO;
}


/*
 *
 *@brief 根据题库id获取题目数据
 *
 *@return: 
 *
 */
+ (NSArray *)fectchQuestions:(int)qb_id
{
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_question_url(qb_id)]];
    [request startSynchronous];
    if (!request.error) {
        
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *question_infos = [dict objectForKey:@"data"];
            if (question_infos.count > 0) {
                NSMutableArray *questions = [NSMutableArray arrayWithCapacity:question_infos.count];
                for (NSDictionary *question_info in question_infos) {
                    Question *question = [[Question alloc] init];
                    question.question_id = [[question_info objectForKey:@"id"] intValue];
                    question.question_title = [question_info objectForKey:@"title"];
                    question.question_answer_a = [question_info objectForKey:@"a"];
                    question.question_answer_b = [question_info objectForKey:@"b"];
                    question.question_answer_c = [question_info objectForKey:@"c"];
                    question.question_answer_d = [question_info objectForKey:@"d"];
                    question.question_correct_answer = [question_info objectForKey:@"answer"];
                    question.question_difficulty = [[question_info objectForKey:@"dif"] floatValue];
                    question.question_create_time = [[NSDate date] timeIntervalSince1970];
                    question.question_alter_time = [[NSDate date] timeIntervalSince1970];
                    question.question_is_use = YES;
                    [questions addObject:question];
                    [question release];
                }
                return questions;
                
            }
            
        }
        
    }
    
    
    return nil;
}
//
/*
 *
 *@brief 获取题目数据
 *
 *@return:
 *
 */
+ (NSArray *)fectchQuestionsForGameCenter:(NSString *)key
{
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_question_ForGameCenter(key, 0)]];
    [request startSynchronous];
    if (!request.error) {
        
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *question_infos = [dict objectForKey:@"data"];
            if (question_infos.count > 0) {
                NSMutableArray *questions = [NSMutableArray arrayWithCapacity:question_infos.count];
                for (NSDictionary *question_info in question_infos) {
                    Question *question = nil;
                                                              
                    NSString *a = [question_info objectForKey:@"a"];
                    NSString *b = [question_info objectForKey:@"b"];
                    NSString *c = [question_info objectForKey:@"c"];
                    NSString *d = [question_info objectForKey:@"d"];
                    
                    NSString *answer = [question_info objectForKey:@"answer"];
                    
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
                        
                        question.question_id = [[question_info objectForKey:@"id"] intValue];
                        question.question_title = [question_info objectForKey:@"title"];
                        question.question_difficulty = [[question_info objectForKey:@"dif"] floatValue];
                        question.question_create_time = [[NSDate date] timeIntervalSince1970];
                        question.question_alter_time = [[NSDate date] timeIntervalSince1970];
                        question.question_is_use = YES;

                        
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
                        
                        [questions addObject:question];
                    }
                    
                }
                return questions;
                
            }
            
        }
        
    }
    
    
    return nil;
}


//
/*
 *
 *@brief 获取题目数据
 *
 *@return:
 *
 */
+ (BOOL)resetQuestionsForGameCenter:(NSString *)key flag:(int)flag
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_question_ForGameCenter(key, flag)]];

    [request startSynchronous];
    if (!request.error) {
        
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            
                return YES;
        }
        
    }
    
    
    return NO;
}

/*
 *
 *@brief 获取题库信息
 *
 *@return:
 *
 */
+ (NSArray *)fetchQuestionBanks
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_question_banks_url]];
    [request startSynchronous];
    if (!request.error) {
//        NSDictionary *dict = [request.responseString objectFromJSONString];
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];

        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *bank_infos = [dict objectForKey:@"data"];
            if (bank_infos.count > 0) {
                NSMutableArray *banks = [NSMutableArray arrayWithCapacity:bank_infos.count];
                for (NSDictionary *bank_info in bank_infos) {
                    QuestionBank *bank = [[QuestionBank alloc] init];
                    bank.qb_id = [[bank_info objectForKey:@"id"] intValue];
                    bank.qb_question_num = [[bank_info objectForKey:@"num"] intValue];
                    bank.qb_price = [[bank_info objectForKey:@"price"] floatValue];
                    bank.qb_is_vip_free = [[bank_info objectForKey:@"vip_free"] boolValue];
                    bank.qb_type_title = [bank_info objectForKey:@"type_title"];
                    bank.qb_type_desc = [bank_info objectForKey:@"type_desc"];
                    bank.qb_level_title = [bank_info objectForKey:@"level_title"];
                    bank.qb_level_desc = [bank_info objectForKey:@"level_desc"];
                    bank.qb_create_time = [[NSDate date] timeIntervalSince1970];
                    bank.qb_is_use = YES;
                    bank.qb_is_fetched = NO;
                    [banks addObject:bank];
                    [bank release];
                }
                
                return banks;
                
            }
            
        }
    
    }
    
    return nil;
}

/*
 *
 *@brief 上传答题记录
 *
 *@return:
 *
 */
+ (BOOL)uploadQuestionRecord:(NSArray *)records
{
    if (nil == records || records.count == 0) {
        return NO;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:[AppSingleton sharedInstance].uid forKey:@"uid"];
    [dict setObject:records forKey:@"data"];

    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:upload_question_record_url]];
    //[request setPostBody:[NSMutableData dataWithData:[dict JSONData]]];
    [request setPostValue:[dict JSONString] forKey:@"data"];
    [request startSynchronous];
    if (!request.error) {
//        NSDictionary *dict = [request.responseString objectFromJSONString];
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        
        if ([[dict objectForKey:@"code"] isEqualToString:@"BW0001"]) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}


+ (NSArray *)parseRank:(NSData *)data
{
    NSMutableArray *ranks = nil;
    
    NSString *retString = [CommUtils uzip:data];
    NSDictionary *dict = [retString objectFromJSONString];

    NSString *code = [dict objectForKey:@"code"];
    if ([code isEqualToString:@"BW0001"]) {
        ranks = [NSMutableArray array];
        
        NSArray *rank_infos = [dict objectForKey:@"data"];
        if (rank_infos.count > 0) {
            
            for (NSDictionary *rank_info in rank_infos) {
                RankInfo *rankInfo = [[[RankInfo alloc] init] autorelease];
                rankInfo.gold = [[rank_info objectForKey:@"gold"] intValue];
                rankInfo.uid = [[rank_info objectForKey:@"id"] intValue];
                rankInfo.uname = [rank_info objectForKey:@"name"];
                rankInfo.upic = [rank_info objectForKey:@"pic"];
                rankInfo.order = [[rank_info objectForKey:@"no"] intValue];
                [ranks addObject:rankInfo];
            }
        }
    }
    return ranks;
}

- (NSComparisonResult)compareRank:(RankInfo *)rank
{
    RankInfo *rank1 = (RankInfo *)self;
    
    NSComparisonResult result = [[NSNumber numberWithInt:rank1.gold] compare:[NSNumber numberWithInt:rank.gold]];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
}

/*
 *
 *@brief 获取排行信息
 *
 *@return: nil 请求失败
 *
 */
+ (void)getRank:(void(^)(NSArray *))resultBlock
{
    NSMutableArray *ranks = [NSMutableArray array];
    
    NSData *data2 = nil;
    int timeInterval = [[NSDate date] timeIntervalSince1970] - [[CommUtils getLocalData:@"rank_list_2_time"] intValue];
    
    if (timeInterval < CacheTime) {
        
        data2 = [CommUtils getLocalData:@"rank_list_2"];
    }
    else
    {
        if ([CommUtils checkNetWork] == NotReachable) {
            data2 = [CommUtils getLocalData:@"rank_list_2"];
        }
    }
    
    timeInterval = [[NSDate date] timeIntervalSince1970] - [[CommUtils getLocalData:@"rank_list_1_time"] intValue];

    NSData *data1 = nil;
    if (timeInterval < CacheTime && [CommUtils checkNetWork] != NotReachable) {
        data1 = [CommUtils getLocalData:@"rank_list_1"];
    }
    else
    {
        if ([CommUtils checkNetWork] == NotReachable) {
            data1 = [CommUtils getLocalData:@"rank_list_1"];
        }

    }
    

    if (nil == data2) {
        //获取前三名
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_rank_self_url([AppSingleton sharedInstance].uid.intValue, 500)]];
        [request startSynchronous];
        
        if (!request.error) {
            data2 = request.responseData;
            [CommUtils setLocalData:data2 key:@"rank_list_2"];
            [CommUtils setLocalData:[NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]] key:@"rank_list_2_time"];
        }
    }

    if (nil == data1) {
        //获取排名包含自己的名次
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_rank_url(1, 3)]];
        [request startSynchronous];
        
        if (!request.error) {
            data1 = request.responseData;
            [CommUtils setLocalData:data1 key:@"rank_list_1"];
            [CommUtils setLocalData:[NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]] key:@"rank_list_1_time"];

        }
    }
    
    if (data2) {
        NSArray *rankinfos = [DataManager parseRank:data2];
        if (rankinfos) {
            [ranks addObjectsFromArray:rankinfos];
        }
    }
    
    
    if (data1) {
        NSArray *rankinfos = [DataManager parseRank:data1];
        if (rankinfos) {
            for (RankInfo *rankInfo in rankinfos) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %d", rankInfo.uid];
                NSArray *results = [ranks filteredArrayUsingPredicate:predicate];
                if (results.count == 0) {
                    [ranks addObject:rankInfo];
                }
                
            }
        }
        
    }
    
    if (data1 && data2) {
        dispatch_async([DBManager sharedInstance].dbQueue, ^{
            id value = [[DBManager sharedInstance] getUserProperty:[AppSingleton sharedInstance].uid.intValue type:UpdateUserTypeGoldCount];
            for (RankInfo *rankInfo in ranks) {
                if (rankInfo.uid == [AppSingleton sharedInstance].uid.integerValue) {
                    rankInfo.gold = [value intValue];
                    break;
                }
            }
            
            NSArray *ranks_ = [ranks sortedArrayUsingComparator:^NSComparisonResult(RankInfo *obj1, RankInfo *obj2) {
                NSNumber *number1 = [NSNumber numberWithInt:obj1.gold];
                NSNumber *number2 = [NSNumber numberWithInt:obj2.gold];
                
                NSComparisonResult result = [number1 compare:number2];
                
                //return result == NSOrderedDescending; // 升序
                return result == NSOrderedAscending;  // 降序
                
            }];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            int myIndex = -1;
            for (int i = 0; i < ranks_.count; i++) {
                RankInfo * rank = [ranks_ objectAtIndex:i];
                if (rank.uid == [AppSingleton sharedInstance].uid.intValue) {
                    myIndex = i;
                    break;
                }
            }
            
            for (int i = 0; i < 3; i++) {
                [arr addObject:[ranks_ objectAtIndex:i]];
            }
            
            for (int i = myIndex - 3; i <= myIndex + 3; i ++) {
                if (i >= 3 && i < ranks_.count) {//去掉前三名
                    [arr addObject:[ranks_ objectAtIndex:i]];
                }

            }
            
            NSArray *arr_ = [arr sortedArrayUsingComparator:^NSComparisonResult(RankInfo *obj1, RankInfo *obj2) {
                NSNumber *number1 = [NSNumber numberWithInt:obj1.gold];
                NSNumber *number2 = [NSNumber numberWithInt:obj2.gold];
                
                NSComparisonResult result = [number1 compare:number2];
                
                //return result == NSOrderedDescending; // 升序
                return result == NSOrderedAscending;  // 降序
                
            }];
            
            RankInfo *myRank = nil;
            int nextIndex = -1;
            for (int i = 0; i < arr_.count; i++) {
                RankInfo * rank = [arr_ objectAtIndex:i];
                if (rank.uid == [AppSingleton sharedInstance].uid.intValue) {
                    myRank = rank;
                    
                    nextIndex = i+1;
                    
                    break;
                }
            }
            
            RankInfo *nextRank = nil;
            if (nextIndex < ranks.count) {
                nextRank = [arr_ objectAtIndex:nextIndex];
            }
            
            if (nextRank) {
                myRank.order = nextRank.order-1;
            }
            
            resultBlock(arr_);
        });
    }
}


/*
 *
 *@brief 获取题目难度
 *
 *@return: nil 请求失败
 *
 */
+ (NSArray *)getQuestionDif:(NSArray *)qids
{
    if (nil == qids || qids.count == 0) {
        return nil;
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_question_dif_url([qids componentsJoinedByString:@","])]];
    [request startSynchronous];
    if (!request.error) {
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *question_difs = [dict objectForKey:@"data"];
            if (question_difs.count > 0) {
                NSMutableArray *questionDifs = [NSMutableArray arrayWithCapacity:question_difs.count];
                for (NSDictionary *question_dif in question_difs) {
                    QuestionDif *questionDif = [[[QuestionDif alloc] init] autorelease];
                    questionDif.qid = [[question_dif objectForKey:@"qid"] intValue];
                    questionDif.qDif = [[question_dif objectForKey:@"dif"] floatValue];
                    [questionDifs addObject:questionDif];
                }
                return questionDifs;
            }
        }
        
    }
    return nil;
}

+ (VersionInfo *)parserVersion:(NSData *)data
{
    NSString *retString = [CommUtils uzip:data];
    NSDictionary *dict = [retString objectFromJSONString];
    NSString *code = [dict objectForKey:@"code"];
    if ([code isEqualToString:@"BW0001"]) {
        NSArray *version_infos = [dict objectForKey:@"data"];
        if (version_infos.count > 0) {
            NSDictionary *version_info = [version_infos objectAtIndex:0];
            VersionInfo *appVersion = [[[VersionInfo alloc] init] autorelease];
            appVersion.appVersion = [version_info objectForKey:@"version"];
            appVersion.appstoreUrl = [version_info objectForKey:@"url"];
            appVersion.forceUpdate = [[version_info objectForKey:@"force"] intValue];
            return appVersion;
        }
        
    }

    return nil;
}
/*
 *
 *@brief 获取版本信息
 *
 *@return: nil 请求失败
 *
 */
+ (VersionInfo *)getVersion
{    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?version=%@", get_version_url, [CommUtils getLocalVersion]]]];
    [request startSynchronous];
    if (!request.error) {
        
        VersionInfo *ver = [DataManager parserVersion:request.responseData];
        if (ver) {            
            [CommUtils setCacheTime:VersionInfoKey];
            [CommUtils setLocalData:request.responseData key:VersionInfoDataKey];

            return ver;
        }
        /*
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *version_infos = [dict objectForKey:@"data"];
            if (version_infos.count > 0) {
                [CommUtils setCacheTime:VersionInfoKey];
                [CommUtils setLocalData:dict key:VersionInfoDataKey];
                NSDictionary *version_info = [version_infos objectAtIndex:0];
                VersionInfo *appVersion = [[[VersionInfo alloc] init] autorelease];
                appVersion.appVersion = [version_info objectForKey:@"version"];
                appVersion.appstoreUrl = [version_info objectForKey:@"url"];
                return appVersion;
            }
            
        }*/
        
    }
    return nil;
}


/*
 *
 *@brief 获取答题系数
 *
 *@return: nil 请求失败
 *
 */
+ (float)getGoldRatio
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_gold_ratio_url]];
    [request startSynchronous];
    if (!request.error) {
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *ratio_infos = [dict objectForKey:@"data"];
            
            if (ratio_infos.count > 0) {
                return [[[ratio_infos objectAtIndex:0] objectForKey:@"ratio"] floatValue];
            }

        }
        
    }
    return 0;
}

+ (NSDictionary *)getAds:(NSString *)version
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_ads(version)]];
    [request startSynchronous];
    if (!request.error) {
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *adsInfo = [dict objectForKey:@"data"];
            
            if (adsInfo.count > 0) {
                return [adsInfo lastObject];
            }
            
        }
        
    }
    return nil;

}


+ (NSDictionary *)getInstall:(NSString *)version
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:get_install(version)]];
    [request startSynchronous];
    if (!request.error) {
        NSString *retString = [CommUtils uzip:request.responseData];
        NSDictionary *dict = [retString objectFromJSONString];
        NSString *code = [dict objectForKey:@"code"];
        if ([code isEqualToString:@"BW0001"]) {
            NSArray *installDicts = [dict objectForKey:@"data"];
            
            if (installDicts.count > 0) {
                return [installDicts lastObject];
            }
            
        }
        
    }
    return nil;
    
}

@end
