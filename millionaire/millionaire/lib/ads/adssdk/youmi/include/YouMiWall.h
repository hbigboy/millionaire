//
//  YouMiWall.h
//  YouMiSDK
//
//  Created by Layne on 12-01-05.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YouMiConfig.h"
#import "YouMiWallAppModel.h"
#import "YouMiPointsManager.h"


typedef enum {
    YouMiWallAnimationTransitionNone,  // no animation
    YouMiWallAnimationTransitionZoomIn,
    YouMiWallAnimationTransitionZoomOut,
    YouMiWallAnimationTransitionFade,
    YouMiWallAnimationTransitionPushFromBottom,
    YouMiWallAnimationTransitionPushFromTop
} YouMiWallAnimationTransition;


@interface YouMiWall : NSObject

/*! 启动有米积分墙
 */
+ (void)enable;

/*! 显示积分墙
 * \param rewarded 是不是有积分模式
 * \param didShowBlock 成功显示积分墙时执行的block
 * \param didDismissBlock 关闭积分墙后执行的block
 * \returns 是否显示积分墙成功，积分墙显示不成功并不会调用didShowBlock和didDismissBlock
 */
+ (BOOL)showOffers:(BOOL)rewarded didShowBlock:(void (^)(void))didShowBlock didDismissBlock:(void (^)(void))didDismissBlock;

/*! 获取积分墙的App广告列表
 * \param rewarded 是不是有积分模式
 * \param recievedBlock 接收广告列表的block, 其中NSArray的内容是 @[YouMiWallAppModel, YouMiWallAppModel...]; 获取列表失败, 在NSError里有记录.
 */
+ (void)requestOffersOpenData:(BOOL)rewarded revievedBlock:(void (^)(NSArray*, NSError *))recievedBlock;

/*! 安装积分墙中的APP
 * \param app 通过requestOffersOpenData获得的APP
 */
+ (void)userInstallApp:(YouMiWallAppModel *)app;


@end


