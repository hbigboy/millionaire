//
//  ShowCoinView.h
//  millionaire
//
//  Created by book on 13-7-21.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

@interface ShowCoinView : BaseView
{
    UILabel *_scoreLb;
}

- (void)showView:(BOOL)flag;
@end
