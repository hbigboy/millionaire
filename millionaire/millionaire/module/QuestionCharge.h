//
//  QuestionCharge.h
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionCharge : NSObject
@property (nonatomic, assign) int qc_id;
@property (nonatomic, assign) float qc_price;
@property (nonatomic, assign) BOOL qc_is_vip_free;
@property (nonatomic, assign) double qc_create_time;
@property (nonatomic, assign) double qc_alter_time;

@end
