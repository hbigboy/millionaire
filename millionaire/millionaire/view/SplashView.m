//
//  SplashView.m
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "SplashView.h"

@interface SplashView ()

@end

@implementation SplashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
        
        [self addBgView];
        
    }
    return self;
}

- (void)initSubviews
{
    CGRect rc = self.frame;
    rc.size.height += 20;
    rc.origin.y -= 20;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rc];
    UIImage *img = [UIImage imageNamed:@"Default.png"];
    [imgv setImage:img];
    [self addSubview:imgv];
    [imgv release];
}


@end
