//
//  HelperView.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "HelperView.h"

@implementation HelperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

- (void)dealloc
{
    self.btnBack = nil;
    [super dealloc];
}

- (void)initSubviews
{
    [self addBgView];
    
    self.btnBack = [self addBackButton];
    
   
    //标题
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 111, 36)];
    imgv.center = CGPointMake(self.frame.size.width/2, self.btnBack.center.y);
    UIImage *image = [UIImage imageNamed:@"help_title.png"];
    imgv.image = image;
    [self addSubview:imgv];
    if ([UIDevice isRunningOniPhone5]) {
        imgv.top += 10;
    }
    [imgv release];
    
    int xOffset = 15;
    
    float  height = 358;
    if ([UIDevice isRunningOniPhone5]) {
        height += 68;
    }
    //文本框背景
    imgv = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 82, 320-2*xOffset, height)];
    image = [UIImage imageNamed:@"help_textview_bg.png"];
    image = [image stretchableImageWithLeftCapWidth:30 topCapHeight:27];
    imgv.image = image;
    [self addSubview:imgv];
    if ([UIDevice isRunningOniPhone5]) {
        imgv.top += 10;
    }
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 220, 28)];
    lb.textColor = [UIColor whiteColor];
    lb.font = [UIFont systemFontOfSize:18];
    lb.text = @"一站到底之百万富翁规则：";
    lb.backgroundColor = [UIColor clearColor];
    [imgv addSubview:lb];
    [lb release];
    
    imgv.userInteractionEnabled = YES;
    
    //文本框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 30, imgv.frame.size.width - 2*2, imgv.frame.size.height - 30 - 10)];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = colorRGBA(0xff, 0xff, 0xff, 0.7);
    textView.backgroundColor = [UIColor clearColor];
    //textView.text = @"123";
    textView.editable = NO;
    [imgv addSubview:textView];
    
    
    //读取帮助文件的内容
    NSString *outputFile = [[NSBundle mainBundle] pathForResource:@"gameHelp" ofType:@"txt"];
    NSString *strFileContent;
    //file exist?
    if (outputFile)
    {
        strFileContent = [NSString stringWithContentsOfFile:outputFile encoding:NSUTF8StringEncoding error:nil];
        textView.text = strFileContent;
    }
    
    [textView release];
    
    [imgv release];
}

@end
