//
//  CommUtils.h
//  millionaire
//
//  Created by book on 13-7-22.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@class AppDelegate;
@class RootViewController;
@class AdsView;
@interface CommUtils : NSObject

+ (BOOL)isEmptyOrZero:(id)value;
//+ (NSString *)md5:(NSString *)str;

+ (NetworkStatus)checkNetWork;

+ (id)getLocalData:(NSString *)key;
+ (void)setLocalData:(id)value key:(NSString *)key;

+ (void)twinklAnimation:(UIView *)view block:(void(^)(void))block;

+(NSString*)urlDecoded:(NSString*)str;
+(NSString *) utf8ToUnicode:(NSString *)string;

+ (NSString *)getKeyFromType:(UpdateUserType)type;


+ (NSString *)uzip:(NSData*)data;
    
// 数据压缩

+ (NSData *)compressData:(NSData*)uncompressedData;

// 数据解压缩

+ (NSData *)decompressData:(NSData *)compressedData;


+ (NSString *)decrypt:(NSData *)aData;
+ (NSData *)encrypt:(NSString *)aString;

+ (void)showConfirmAlertView:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id)target;//含有确定按钮的aleertview

+ (int)getRandomNumber:(int)from to:(int)to;

+ (NSArray *)getLevels;
+ (NSString *)getLevels:(int)level;

+ (NSString *)getLocalVersion;//获取程序本身的版本号boudle version
+ (void)updateApp:(NSString *)appUrl;//升级应用

+ (BOOL)needUpdateCache:(NSString *)key timeInterval:(float)timeInterval;//判断是否需要同步数据
+ (void)setCacheTime:(NSString *)key;//设置缓存时间

+ (RootViewController *)getRootViewController;
+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect;
+ (UIImage *)getNormalImage:(UIView *)view;////获取当前屏幕内容
+ (void) sendImageContent:(NSDictionary *)dict scene:(int)scene;//微信分享
+ (AppDelegate  *)getApp;
+ (BOOL)isUpdate:(NSString *)version;

+ (AdsView *)getAdsView;
@end
