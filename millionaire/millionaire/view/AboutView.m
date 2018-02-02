//
//  AboutView.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "AboutView.h"
#import "CommUtils.h"

@interface AboutView ()
{
    UIImageView *_imgvLogo;
    UIButton    *_updateButton;
    UIActivityIndicatorView *_activity;
}
@property (nonatomic, retain) UIButton *btnBack;
@property (nonatomic, copy) void(^versionBlock)(UIButton*);
@property (nonatomic, copy) void(^backBlock)(void);
@end

@implementation AboutView

- (void)dealloc
{
    [_activity release];
    self.backBlock = nil;
    self.versionBlock = nil;
    [_imgvLogo release];
    self.btnBack = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self iniSubviews];
        [self initLogoImage];
        
        UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake((320-85)/2, _imgvLogo.bottom + 18, 85, 30)] autorelease];
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @"百万富翁";
        label1.font = [UIFont boldSystemFontOfSize:19];
        label1.textColor = colorRGB(102, 78, 14);
        label1.textAlignment = UITextAlignmentCenter;
        [self addSubview:label1];
        
        UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake((320-85)/2, label1.bottom, 85, 30)] autorelease];
        label2.backgroundColor = [UIColor clearColor];
        label2.text = [NSString stringWithFormat:@"iOS%@版", [CommUtils getLocalVersion]];
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont boldSystemFontOfSize:13];
        label2.textColor = colorRGB(121, 101, 33);
        label2.textAlignment = UITextAlignmentCenter;
        [self addSubview:label2];
        
        
        
        CGSize size = CGSizeMake(73.5*4/3, 23*4/3);
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateButton.frame = CGRectMake((320-size.width)/2, label2.bottom + 2, size.width, size.height);
        [_updateButton setImage:[UIImage imageNamed:@"update_icon.png"] forState:UIControlStateNormal];
        //[_updateButton addTarget:self action:@selector(getVersion) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:_updateButton];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.frame = CGRectMake((_updateButton.width-20)/2, (_updateButton.height-20)/2, 20, 20);
        [_updateButton addSubview:_activity];
        
        UILabel *netAddress = [[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 30)] autorelease];
        netAddress.bottom = self.height - 45;
        netAddress.alpha = 0.3;
        netAddress.lineBreakMode = UILineBreakModeWordWrap;
        netAddress.numberOfLines = 2;
        netAddress.text = @"www.baiwangame.com\n323宿舍";
        netAddress.shadowOffset = CGSizeMake(-1, -1);
        netAddress.backgroundColor = [UIColor clearColor];
        netAddress.font = [UIFont boldSystemFontOfSize:12];
        netAddress.textColor = colorRGB(166, 89, 21);
        netAddress.textAlignment = UITextAlignmentCenter;
        [self addSubview:netAddress];
    }
    return self;
}

- (void)iniSubviews
{
    [self addBgView];
    self.btnBack = [self addBackButton];
    [_btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initLogoImage
{
    CGRect rect;
    rect.origin.x = (320-135)/2;
    rect.origin.y = 85;
    rect.size.width = 135;
    rect.size.height = 150.5;
    
    _imgvLogo = [[UIImageView alloc] initWithFrame:rect];
    _imgvLogo.contentMode = UIViewContentModeScaleAspectFit;
    [_imgvLogo setImage:[UIImage imageNamed:@"bw_logo.png"]];
    [self addSubview:_imgvLogo];
}

- (void)getVersion
{
    if (_versionBlock) {
        _versionBlock(self.btnBack);
    }
}

- (void)backAction
{
    if (_backBlock) {
        _backBlock();
    }
}

- (void)setCallback:(void (^)(UIButton*))callback backBlock:(void (^)(void))backBlock
{
    self.versionBlock = callback;
    self.backBlock = backBlock;
}

- (void)enableUpdateButton:(BOOL)enable
{
    if (enable) {
        [_activity stopAnimating];
    }
    else
    {
        [_activity startAnimating];
    }
    _updateButton.enabled = enable;
}
@end