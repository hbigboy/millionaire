//
//  AboutView.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface AboutView : BaseView

- (void)setCallback:(void (^)(UIButton*))callback backBlock:(void (^)(void))backBlock;

- (void)enableUpdateButton:(BOOL)enable;//设置可点
@end
