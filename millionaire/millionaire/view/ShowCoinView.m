//
//  ShowCoinView.m
//  millionaire
//
//  Created by book on 13-7-21.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "ShowCoinView.h"

@implementation ShowCoinView

- (void)dealloc
{

    [_scoreLb release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGSize size = CGSizeMake(200, 60);
        _scoreLb = [[UILabel alloc] initWithFrame:CGRectMake((self.width-size.width)/2, (self.height-size.height)/2, size.width, size.height)];
        _scoreLb.backgroundColor = [UIColor clearColor];
        _scoreLb.text = @"您当前总金币数：6666";
        [self addSubview:_scoreLb];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showView:(BOOL)flag
{
    if (flag) {
        self.alpha = 1.0;
    }
    else
    {
        self.alpha = 0.0;
    }

}

@end
