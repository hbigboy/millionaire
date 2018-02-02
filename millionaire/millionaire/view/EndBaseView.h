//
//  EndView.h
//  millionaire
//
//  Created by zizhu on 13-7-31.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface EndBaseView : BaseView
@property (nonatomic, retain) UIImageView *imgvHead;
//@property (nonatomic, retain) UILabel  *lbResult;
@property (nonatomic, retain) UIImageView *imgvResult;
//@property (nonatomic, retain) UILabel  *lbTip;
@property (nonatomic, retain) UIImageView *imgvTip;
@property (nonatomic, retain) UIImageView *imgvScore;
@property (nonatomic, retain) UILabel  *lbScore;
@property (nonatomic, retain) UIButton *btnToMainView;
@property (nonatomic, retain) UIButton *btnRetryAgain;
@end
