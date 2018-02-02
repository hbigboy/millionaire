//
//  ProgressView.m
//  millionaire
//
//  Created by book on 13-7-29.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "TimerProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimerProgressView

- (void)dealloc
{
    [_trackView release];
    [_progressView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGSize size = self.frame.size;
                
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _trackView.image = [[UIImage imageNamed:@"track_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];//进度未填充部分显示的图像
        [self addSubview:_trackView];
        
        _progressView = [[UIImageView alloc] init];
        _progressView.image = [[UIImage imageNamed:@"progress_bg.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:0];//进度填充部分显示的图像
        
        [self setProgress:1];//设置进度
        
        UIView *progressViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        //当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
        progressViewBg.clipsToBounds = YES;
        
        [self addSubview:progressViewBg];
        [progressViewBg addSubview:_progressView];
        [progressViewBg release];
                

    }
    return self;
}


-(void)setProgress:(float)fProgress
{
    CGSize size = self.frame.size;
    _progressView.frame = CGRectMake(0, 0, size.width*fProgress, size.height);
//    _progressView.frame = CGRectMake(size.width * (fProgress - 1), 0, size.width, size.height);//image的宽和高不变，将x轴的坐标根据progress的大小左右移动即可显示出进度的大小，progress的值介于0.0至1.0之间。因为_progressView的父级view上clipsToBounds属性为YES，所以当_progressView的frame出界后不会被显示出来。
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
