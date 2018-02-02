//
//  ProgressView.h
//  millionaire
//
//  Created by book on 13-7-29.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

@interface TimerProgressView : BaseView
{
    UIImageView *_trackView;
    UIImageView *_progressView;
    
}
-(void)setProgress:(float)fProgress;
@end
