//
//  BaseView.m
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

@interface BaseView()
{
    UIButton *_backButton;
}

@end

@implementation BaseView

- (void)dealloc
{
    MLog(@"%@ dealloc", [self class]);
    self.bgView = nil;
    [_backButton release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        MLog(@"%@ init ", [self class]);
        
       
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

- (void)addBgView
{
    if (nil == _bgView) {
        self.bgView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        self.bgView.image = [[UIImage imageNamed:@"bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:450];
        [self addSubview:self.bgView];
        [self sendSubviewToBack:self.bgView];
    }
}

//返回按钮
- (UIButton *)addBackButton
{
    if(nil == _backButton)
    {
        CGRect rc = CGRectMake(10, 10, 56, 56);        
        _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"back_btn_nomal.png"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"back_btn_highlighted.png"] forState:UIControlStateHighlighted];
        _backButton.frame = rc;
        [self addSubview:_backButton];
    }
    
    return _backButton;
    
}
@end
