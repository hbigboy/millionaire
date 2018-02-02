//
//  RankModel.h
//  millionaire
//
//  Created by book on 13-8-2.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankInfo : NSObject
@property (nonatomic, assign) int       gold;//金币数目
@property (nonatomic, assign) int       uid;//用户id
@property (nonatomic, copy) NSString    *uname;//用户名字
@property (nonatomic, copy) NSString    *upic;//用户名字
@property (nonatomic, assign) int       order;//用户排序
@end
