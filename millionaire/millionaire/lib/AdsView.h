//
//  AdsView.h
//  millionaire
//
//  Created by zizhu on 13-9-7.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsView : UIView

//Youmi Ads
- (void)initYoumi;
- (void)addYouMiView:(UIView *)view;
- (BOOL)showYoumi:(void (^)())dismiss;
//Ads
@end
