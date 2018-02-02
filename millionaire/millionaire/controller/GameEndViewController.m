//
//  GameOverViewController.m
//  millionaire
//
//  Created by zizhu on 13-7-30.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "GameEndViewController.h"
#import "GameEndView.h"
//#import "GADBannerView.h"
#import "GADBannerView+Preload.h"
#import "BaiduMobStat.h"
#import "WXApiObject.h"

@interface GameEndViewController ()
{
    //GameEndView *_gameEndView;
}
@property (nonatomic, retain) GADBannerView *adView;
@property (nonatomic, retain) UIImage *image;
@end

@implementation GameEndViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //一开始就加入页面，因为上层调用了设置gameendview的属性
        self.gameEndView = [[[GameEndView alloc] initWithFrame:self.view.bounds] autorelease];
        [self.view addSubview:self.gameEndView];
        
        __block typeof (self)bself = self;
        [_gameEndView setCallBack:^(int type) {
            [bself shareAction:type];
        }];
        
        //#warning 测试广告
        GADBannerView *adView = [GADBannerView sharedInstance];
//        GADBannerView *adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        adView.rootViewController = self;
//        adView.adUnitID = @"ca-app-pub-3842315164413649/4955727815";
//        //adView.center = CGPointMake(320/2, 480/2-100);
        [self.view addSubview:adView];
//        GADRequest *req = [GADRequest request];
//        [req setLocationWithLatitude:40.0 longitude:117.0 accuracy:100]; //北京的经纬度
//        [adView loadRequest:req];
//        self.adView = adView;
//        [adView release];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[BaiduMobStat defaultStat] logEvent:@"结束页面" eventLabel:@"结束页面展现次数"];
    [self.gameEndView.btnToMainView addTarget:self action:@selector(buttonActionShare:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.gameEndView = nil;
    //self.adView = nil;
    [super dealloc];
}

- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.gameEndView.btnToMainView addTarget:target action:action forControlEvents:controlEvents];
}

- (void)newGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.gameEndView.btnRetryAgain addTarget:target action:action forControlEvents:controlEvents];
}


- (void)buttonActionShare:(id)sender
{
    [self shareAction:0];
}

- (void)shareAction:(int)type
{
    if(nil == _image)
    {
        return;
    }

    if (0 == type) {
        [CommUtils sendImageContent:[NSDictionary dictionaryWithObjectsAndKeys:@"猜中领红包", @"content", _image, @"image", nil] scene:WXSceneSession];
    }
    
    if (1 == type) {
        [CommUtils sendImageContent:[NSDictionary dictionaryWithObjectsAndKeys:@"猜中领红包", @"content", _image, @"image", nil] scene:WXSceneTimeline];
    }
}

- (void)setShareImage:(UIImage *)image
{
    self.image = image;
}
@end
