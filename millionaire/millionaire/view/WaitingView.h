//
//  WaitingView.h
//  millionaire
//
//  Created by book on 13-7-21.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

@interface WaitingView : BaseView
{
    UIImageView *_waitingLabel;
    UIImageView *_goLabel;
}
- (void)readyGo:(void(^)(void))block;
- (void)resetReadyGoLabel;
@end
