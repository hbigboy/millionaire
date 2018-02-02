//
//  QuestionType.h
//  millionaire
//
//  Created by book on 13-7-25.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionType : NSObject
@property (nonatomic, assign) int qt_id;
@property (nonatomic, copy) NSString *qt_title;
@property (nonatomic, copy) NSString *qt_desc;
@property (nonatomic, assign) double qt_create_time;
@property (nonatomic, assign) double qt_alter_time;

@end
