//
//  QButton.m
//  millionaire
//
//  Created by book on 13-7-20.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "QButton.h"
#import <QuartzCore/QuartzCore.h>

@interface QButton()
{
    UILabel  *_titleLb;
}
@end

@implementation QButton

- (void)dealloc
{
    [_titleLb release];
    self.answer = nil;
    [super dealloc];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect rc = CGRectMake(0, 0, self.width, self.height);
    _titleLb.frame = rc;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.adjustsImageWhenHighlighted = NO;
        [self setExclusiveTouch:YES];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.0f;
        //self.layer.borderColor = [[UIColor blueColor] CGColor];
        //self.layer.borderWidth = 3.0f;
                
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLb.textAlignment = UITextAlignmentCenter;
        _titleLb.backgroundColor = [UIColor clearColor];
        _titleLb.font = [UIFont systemFontOfSize:20];
        [self addSubview:_titleLb];
        
                
    }
    return self;
}

- (UIImage *)getImage:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
}

- (void)setTitle:(NSString *)title
{
    int fontSize = 12;
    if ([title length] <= 5) {
        fontSize = 15;
    }
    _titleLb.font = [UIFont systemFontOfSize:fontSize];

    _titleLb.text = title;
    
    [self setBackgroundImage:[self getImage:@"button_blank_normal.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[self getImage:@"button_blank_press.png"] forState:UIControlStateHighlighted];
}

- (void)setResultState:(qButtonType)type block:(void(^)(void))block
{
    if (qButtonTypeSucess == type) {
       
        [self setBackgroundImage:[self getImage:@"button_blank_normal_green.png"] forState:UIControlStateNormal];
    }
    else if (qButtonTypeFail == type)
    {
        [self setBackgroundImage:[self getImage:@"button_blank_normal_red.png"] forState:UIControlStateNormal];
        
    }
    else if (qButtonTypeNomal == type)
    {
        [self setBackgroundImage:[self getImage:@"button_blank_normal.png"] forState:UIControlStateNormal];
        return; //为选中状态不闪烁
    }
    
    //闪烁
    [CommUtils twinklAnimation:self block:^(){
        block();
    }];

}


/*
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [super addTarget:target action:action forControlEvents:controlEvents];
    
    [_icon addTarget:target action:action forControlEvents:controlEvents];
}
*/

@end
