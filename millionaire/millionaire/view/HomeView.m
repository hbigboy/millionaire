//
//  HomeView.m
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "HomeView.h"
#import "RootViewController.h"

@interface HomeView ()
@property (nonatomic, retain) NSTimer *shakeTimer;
@property (nonatomic, assign) BOOL      isRankBtnBig;
@property (nonatomic, assign) CGAffineTransform rankBtnTransform;
@end


@implementation HomeView

-(void)dealloc
{
    [_imgvLogo release];
    [_rankButton release];
    [_coinCountButton release];
    [_aboutButton release];
    [_helpButton release];
    [_startGameButton release];
    [_settingButton release];
    [_muteButton release];
    
    self.shakeTimer = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        [self initLogoImage];
        [self initCoinCount];
        [self initButtons];
        
        [self addBgView];
    }
    return self;
}

- (void)initLogoImage
{
    CGRect rect;
    rect.origin.x = (320-102)/2;
    rect.origin.y = 15-5;
    if ([UIDevice isRunningOniPhone5]) {
        rect.origin.y = 15-5+10;
    }

    rect.size.width = 102;
    rect.size.height = 114;
    _imgvLogo = [[UIImageView alloc] initWithFrame:rect];
    _imgvLogo.contentMode = UIViewContentModeScaleAspectFit;
    [_imgvLogo setImage:[UIImage imageNamed:@"bw_logo.png"]];
    [self addSubview:_imgvLogo];
}

- (void)initCoinCount
{
    CGRect rect;
    rect.origin.x = 24;
    rect.origin.y = _imgvLogo.bottom-10;
    if ([UIDevice isRunningOniPhone5]) {
        rect.origin.y = _imgvLogo.bottom-10+10;
    }
    rect.size.width = 192/2;
    rect.size.height = 122/2;
    
    CGPoint center = CGPointMake(100, rect.origin.y + rect.size.height/2);
    
    _coinCountButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _coinCountButton.frame = rect;
    _coinCountButton.center = center;
    [_coinCountButton setBackgroundImage:[[UIImage imageNamed:@"coin_buton_nomal.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0] forState:UIControlStateNormal];
    [_coinCountButton setBackgroundImage:[UIImage imageNamed:@"coin_buton_highlighted.png"] forState:UIControlStateHighlighted];
    [_coinCountButton setTitle:@"0" forState:UIControlStateNormal];
    [_coinCountButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 42, 0, 0)];
    _coinCountButton.userInteractionEnabled = NO;

    rect.size.width = 100;
    _rankButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _rankButton.frame = rect;
    _rankButton.right = 320-24;
    [_rankButton setBackgroundImage:[UIImage imageNamed:@"rank_btn_select.png"] forState:UIControlStateNormal];
    [_rankButton setBackgroundImage:[UIImage imageNamed:@"rank_btn_highlighted.png"] forState:UIControlStateHighlighted];
    [_rankButton setTitle:@"排行榜" forState:UIControlStateNormal];
    _rankButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_rankButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 45, 0, 0)];
    //[self addSubview:_rankButton];

    [self addSubview:_coinCountButton];
 
    
    _rankButton.exclusiveTouch = YES;
    _coinCountButton.exclusiveTouch = YES;
    
    self.rankBtnTransform = _rankButton.transform;
    [self shakeRankButton];
}

- (void)shakeRankButton
{
    self.isRankBtnBig = NO;
    NSTimer *timer01 = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(transformRankButtonToBig) userInfo:nil repeats:YES];
    
    self.shakeTimer = timer01;
    
}
- (void)transformRankButtonToBig
{
    if (self.isRankBtnBig) {
        self.isRankBtnBig = NO;
        _rankButton.transform = self.rankBtnTransform;
    } else {
        self.isRankBtnBig = YES;
        _rankButton.transform = CGAffineTransformScale(_rankButton.transform, 1.1, 1.1);
    }
    
}


- (void)setCoinCount:(NSString *)strCount
{
    int baseW = 196;
    if (strCount.intValue >= 1000000) {
        _coinCountButton.width = baseW+40;
    }
    else if (strCount.intValue >= 100000) {
        _coinCountButton.width = baseW+30;
    }
    else if (strCount.intValue >= 10000) {
        _coinCountButton.width = baseW+20;
    }
    else if (strCount.intValue >= 1000) {
        _coinCountButton.width = baseW+10;
    }
    else if (strCount.intValue < 1000) {
        _coinCountButton.width = baseW;
    }
    
    [_coinCountButton setTitle:strCount forState:UIControlStateNormal];
}

- (void)initButtons
{
    
    float offsetY = 7.5;
    if ([UIDevice isRunningOniPhone5]) {
        offsetY += 10;
    }

    CGSize size = CGSizeMake(392/2, 130/2);
    CGRect rc = CGRectMake((320-size.width)/2, _rankButton.bottom, size.width, size.height);
    
    _startGameButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _startGameButton.frame = rc;
    [_startGameButton setImage:[UIImage imageNamed:@"start_game_btn_nomal.png"] forState:UIControlStateNormal];
    [_startGameButton setImage:[UIImage imageNamed:@"start_game_btn_highlighted.png"] forState:UIControlStateHighlighted];
    
    [self addSubview:_startGameButton];
    
    if ([UIDevice isRunningOniPhone5]) {
        _startGameButton.top += 10;
    }
    rc.origin.y = _startGameButton.bottom + offsetY;
    _helpButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _helpButton.frame = rc;
    [_helpButton setImage:[UIImage imageNamed:@"help_game_btn_nomal.png"] forState:UIControlStateNormal];
    [_helpButton setImage:[UIImage imageNamed:@"help_game_btn_highlighted.png"] forState:UIControlStateHighlighted];

    [self addSubview:_helpButton];
    
    rc.origin.y = _helpButton.bottom + offsetY;
    _aboutButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _aboutButton.frame = rc;
    [_aboutButton setImage:[UIImage imageNamed:@"about_button_nomal.png"] forState:UIControlStateNormal];
    [_aboutButton setImage:[UIImage imageNamed:@"about_button_highlighted.png"] forState:UIControlStateHighlighted];

    [self addSubview:_aboutButton];

    
    rc.size = CGSizeMake(56, 56);
    rc.origin.y = _aboutButton.bottom + offsetY;
    _muteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _muteButton.frame = rc;
    [_muteButton setImage:[UIImage imageNamed:@"mute_enable_btn_namal.png"] forState:UIControlStateNormal];
    [_muteButton setImage:[UIImage imageNamed:@"mute_enable_btn_highlighted.png"] forState:UIControlStateHighlighted];
    [_muteButton addTarget:self action:@selector(mute:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_muteButton];

    

    _settingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _settingButton.frame = rc;
    _settingButton.right = _aboutButton.right;    
    [_settingButton setImage:[UIImage imageNamed:@"setting_btn_namal.png"] forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"setting_btn_highlighted.png"] forState:UIControlStateHighlighted];
    
    [self addSubview:_settingButton];

    
    _startGameButton.exclusiveTouch = YES;
    _aboutButton.exclusiveTouch = YES;
    _helpButton.exclusiveTouch = YES;

    _muteButton.exclusiveTouch = YES;
    _muteButton.frame = _settingButton.frame;
    _settingButton.hidden = YES;
    //_settingButton.exclusiveTouch = YES;
    
    
    BOOL mute = [[CommUtils getLocalData:@"mute_"] boolValue];

    if (mute) {
        [_muteButton setImage:[UIImage imageNamed:@"mute_disable_btn_namal.png"] forState:UIControlStateNormal];
        [_muteButton setImage:[UIImage imageNamed:@"mute_disable_btn_highlighted.png"] forState:UIControlStateHighlighted];
        [_muteButton setSelected:YES];
    }
}

- (void)mute:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    MLog(@"%d", btn.isSelected);

    if (btn.isSelected) {
        [_muteButton setImage:[UIImage imageNamed:@"mute_disable_btn_namal.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"mute_disable_btn_highlighted.png"] forState:UIControlStateHighlighted];
    
        
    }
    else
    {
        [_muteButton setImage:[UIImage imageNamed:@"mute_enable_btn_namal.png"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"mute_enable_btn_highlighted.png"] forState:UIControlStateHighlighted];
    }
    
    [[CommUtils getRootViewController] mute:btn.isSelected];
    
}

#pragma mark -- add target

- (void)addStartGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_startGameButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addAboutGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_aboutButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addHelpGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_helpButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addRaceGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_helpButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)showRankViewEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action
{
    [_rankButton handleControlEvent:controlEvent withBlock:action];
}
/*
-(void)startGameEvent:(ActionBlock)action
{    
    [_startGameButton handleControlEvent:UIControlEventTouchUpInside withBlock:action];
}


-(void)aboutEvent:(ActionBlock)action
{
     [_aboutButton handleControlEvent:UIControlEventTouchUpInside withBlock:action];
}

-(void)helpEvent:(ActionBlock)action
{
     [_helpButton handleControlEvent:UIControlEventTouchUpInside withBlock:action];
}
*/

@end
