//
//  BaseView.h
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
@property (nonatomic, retain) UIImageView *bgView;
- (void)addBgView;
- (UIButton *)addBackButton;

@end
