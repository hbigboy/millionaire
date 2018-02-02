//
//  Constants.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//



#ifndef millionaire_Constants_h
#define millionaire_Constants_h


#define MDebug 1

#if MDebug
#define MLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#else
#define MLog(format, ...)
#endif


#define host_url  @"http://www.baiwangame.com/millionaire/api/"

#define regist_user_url [NSString stringWithFormat:@"%@register.php?", host_url]
#define get_user_url(id, version) [NSString stringWithFormat:@"%@getUserInfo.php?uid=%d&version=%@", host_url, (id), (version)]
#define get_question_banks_url [NSString stringWithFormat:@"%@getQuestionBank.php", host_url]
#define get_question_url(id) [NSString stringWithFormat:@"%@getQuestion.php?qbid=%d", host_url,(id)]
#define get_question_ForGameCenter(key, flag) [NSString stringWithFormat:@"%@getQuestionForGameCenter.php?key=%@&flag=%d", host_url,(key), (flag)]

#define upload_question_record_url [NSString stringWithFormat:@"%@upAnswerRecord.php", host_url]
#define update_user_info [NSString stringWithFormat:@"%@updateUserInfo.php", host_url]
#define get_rank_url(a, b) [NSString stringWithFormat:@"%@getRank.php?mode=all&begin=%d&end=%d", host_url, a, b]
#define get_rank_self_url(a, b) [NSString stringWithFormat:@"%@getRank.php?mode=self&uid=%d&around=%d", host_url, a, b]
#define get_question_dif_url(id) [NSString stringWithFormat:@"%@getQuestionDif.php?qids=%@", host_url,(id)]
#define get_version_url [NSString stringWithFormat:@"%@getAppVersion.php", host_url]
#define get_gold_ratio_url [NSString stringWithFormat:@"%@getGoldRatio.php", host_url]
#define get_ads(version) [NSString stringWithFormat:@"%@getAds.php?version=%@", host_url, (version)]
#define get_install(app_identifier) [NSString stringWithFormat:@"%@getInstall.php?app_identifier=%@", host_url, (app_identifier)]
//ttp://www.baiwangame.com/plane/api/getInstall.php
//ttp://baiwangame.com/millionaire/api/getAds.php?version=1.0.2
//ttp://www.baiwangame.com/millionaire/api/getGoldRatio.php
//ttp://www.baiwangame.com/millionaire/api/getAppVersion.php
//ttp://www.baiwangame.com/millionaire/api/getQuestionDif.php?qids=

#define test_url  @"http://www.baiwangame.com/millionaire/api/test.php"




#define colorRGB(r,g,b) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(1)]
#define colorRGBA(r,g,b,a) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:(a)]
#define boldFont(s) [UIFont boldSystemFontOfSize:(s)]
#define UserPassCountKey @"user_pass_count"
#define UserGoldCountKey @"user_gold_num"
#define UserExpCountKey @"user_exp"
#define UserMoneyCountKey @"user_bw_money_num"
#define UserGradeCountKey @"user_grade"
#define UserOwnBanksKey @"user_own_question_bank_ids"

//key
#define UserIDKey @"user_id_key"
#define EncryptKey @"millionaire_question_test"
//
#define IntergerToString(num) [NSString stringWithFormat:@"%d", (num)]
//alertViewTage
#define RegistAlertViewTag 0x00001
#define UpdateAlertViewTag 0x00002

//
#define CacheTime 60*60*1
//
#define SynQuestionRecordTimeInterval   60*60*1
#define SynQuestionRecordKey            @"sysn_question_record"
//
#define SynQuestionDiffTimeInterval   60*60*1
#define SynQuestionDiffKey            @"sysn_question_diff"
//
//#define AddScoreTimeInterval   60*60*2
//#define AddScoreKey            @"add_score"
//
#define PassGateTimeInterval   60*60*1
#define PassGateKey            @"sysn_pass_gate"
//
#define SysnUserPropertyTimeInterval    60*60*1
#define SysnUserPropertyKey(num)          [NSString stringWithFormat:@"sysn_user_property_%d", (num)]
//
#define UserInfoTimeInterval   60*60*1
#define UserInfoKey            @"sysn_user_info"
//
#define VersionInfoTimeInterval   60*5*1
#define VersionInfoKey            @"sysn_version_info"
#define VersionInfoDataKey        @"version_data_info"

#define KHIGHESTSCORE @"highestScore"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SAFE_RELEASE(__POINTER) { if(__POINTER)[__POINTER release];__POINTER = nil;}

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]




typedef enum _updateUserType{
    UpdateUserTypePassCount,
    UpdateUserTypeGoldCount,
    UpdateUserTypeExpCount,
    UpdateUserTypeMoneyCount,
    UpdateUserTypeGradeCount,
    UpdateUserOwnBanks
}UpdateUserType;


typedef enum _bwErrType{
    LoginSucess,
    UpdateUserError,
    RegistUserError,
    NetWorkError
}BWErrType;



#import "NSString+url.h"
#import "NSString+md5.h"
#import "UUID.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIDataDecompressor.h"
#import "ASIDataCompressor.h"
#import "JSONKit.h"
#import "UIView+GeometryAddition.h"
#import "UIButton+Block.h"
#import "FMDatabase.h"
#import "DBManager.h"
#import "CommUtils.h"
#import "ASIFormDataRequest.h"
#import "NSData+AES.h"
#import "UIDevice+Resolutions.h"
#endif
