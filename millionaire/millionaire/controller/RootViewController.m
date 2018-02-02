//
//  RootViewController.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RootViewController.h"
#import "SplashViewController.h"
#import "HomeViewController.h"
#import "GameViewController.h"
#import "AboutViewController.h"
#import "HelperViewController.h"
#import "GameEndViewController.h"
#import "RaceViewController.h"
#import "RankViewController.h"
#import "VersionInfo.h"
#import "BaiduMobStat.h"
#import "CMOpenALSoundManager.h"
#import "DataManager.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "YouMiWall.h"

#define AnimationTime  0.3

#define DebugRace (0)

@interface RootViewController ()

@property (nonatomic, copy) NSString *appUrl;
@property (nonatomic, retain) CMOpenALSoundManager *soundMgr;
@property (nonatomic, assign) float effectVolum;
@property (nonatomic, assign) float backgroundVolum;
@property (nonatomic, retain) NSDictionary *adsDict;
@end

@implementation RootViewController

-(void)dealloc
{
    self.adsDict = nil;
    self.soundMgr = nil;
    self.currentViewController = nil;
    self.appUrl = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _soundMgr = [[CMOpenALSoundManager alloc] init];
        
        _soundMgr.soundFileNames = [NSArray arrayWithObjects:
                                    @"question_sucess.mp3",
                                    @"question_timeout_warning.mp3",
                                    @"question_timeout.mp3",
                                    @"question_fail.mp3",
                                    @"gameover_sucess.mp3",
                                    @"gameover_fail.mp3",
                                    nil];


    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];    
	// Do any additional setup after loading the view.
    self.currentViewController = [[[SplashViewController alloc] init] autorelease];
    [self.view addSubview:_currentViewController.view];
    
//    self.adsDict = [DataManager getAds:[CommUtils getLocalVersion]];
    
    
    [self playBackgroundMusic:@"backgroundLoop.mp3"];//播放背景音乐
    BOOL mute = [[CommUtils getLocalData:@"mute_"] boolValue];
    if (mute) {
        [self mute:YES];
    }
    
    [self showHomeView];//显示主页面
    
    // 监听获得积分的消息，需要在启动时[YouMiPointsManager enable]或者[YouMiPointsManager enableManually]
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];

//    [[DBManager sharedInstance] goCheck:^(BWErrType errType){
//        switch (errType) {
//            case RegistUserError:
//                MLog(@"注册失败，请检查网络后重新启动程序。");
//                [CommUtils showConfirmAlertView:@"提示" message:@"注册失败，请检查网络后重新启动程序." tag:RegistAlertViewTag delegate:self];
//                break;
//            case LoginSucess:
//            case UpdateUserError:
//            case NetWorkError:
//                
//                [self showHomeView];//显示主页面
//                
//                //[self performSelector:@selector(showHomeView) withObject:nil afterDelay:5];
//                
//                [[DBManager sharedInstance] sysQuestionDif];
//                break;
//            default:
//                break;
//        }
//    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//程序启动同步数据完成后，跳转进入主页面
-(void)showHomeView
{
    
    [self playBackgroundMusic:@"backgroundLoop.mp3"];

//  生成主界面,并初始化配置
    HomeViewController *homeViewController = [[[HomeViewController alloc] init] autorelease];
    homeViewController.view.alpha = 0;
    
    [homeViewController addStartGameTarget:self action:@selector(starGameAction) forControlEvents:UIControlEventTouchUpInside];
    
    [homeViewController addAboutGameTarget:self action:@selector(aboutGameAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (DebugRace) {
        [homeViewController addRaceGameTarget:self action:@selector(raceGameAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [homeViewController addHelpGameTarget:self action:@selector(helpGameAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    [homeViewController showRankViewEvent:UIControlEventTouchUpInside withBlock:^(UIButton *button){
//        [self gameRankAction];
//        //[self gogamecenter];
//    }];

    [self.view addSubview:homeViewController.view];
    
//  显示主界面动画
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.alpha = 0;
        homeViewController.view.alpha = 1;
    
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = homeViewController;
      
#if InstallIPAFlag
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [DataManager getInstall:@"com.baiwangame.millionaire"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[CommUtils getApp] install:dict];
            });
        });
#endif
    }];
}

- (void)playBackgroundMusic:(NSString *)file
{
    [self stopBackgroundMusic];
    
    if (file && !_soundMgr.isBackGroundMusicPlaying) {
        [_soundMgr playBackgroundMusic:file];        
    }
}


- (void)stopBackgroundMusic
{
    if (_soundMgr.isBackGroundMusicPlaying) {
        [_soundMgr stopBackgroundMusic];
    }
    
}

- (void)playSoundWithID:(int)index
{
    if (![_soundMgr isPlayingSoundWithID:index]) {
        [_soundMgr playSoundWithID:index];
    }
}

- (void)stopSoundWithID:(int)index
{
    if ([_soundMgr isPlayingSoundWithID:index]) {
        [_soundMgr stopSoundWithID:index];
    }
}

//进入游戏界面
-(void)newGameView:(int)type
{
    [self playBackgroundMusic:@"backgroundLoop.mp3"];

    float offsetX1 = 320;
    float offsetX2 = -320;
    float offsetX3 = 0;
    if (1 == type) {
        offsetX1 = -320;
        offsetX2 = 320;
        offsetX3 = 0;
    }
    
    GameViewController *gameViewController = [[[GameViewController alloc] init] autorelease];
    gameViewController.view.left = offsetX1;
    [self.view addSubview:gameViewController.view];
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.left = offsetX2;
        gameViewController.view.left = offsetX3;
        
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = gameViewController;
        
        [gameViewController addBackTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
        
        [gameViewController gameOver:^(int score, int minus, BOOL isPass, UIImage *image){
            if (score != 0 || minus != 0) {
                int newScore = score - minus;
                [[DBManager sharedInstance] addScore:newScore completeBlock:^(BOOL ret){
                    [[DBManager sharedInstance] pass:^(BOOL f){}];
                
                }];
            }
            [self gameOver:score andPassOrNot:isPass image:image];
            
            [[DBManager sharedInstance] resetQuestion];
        }];
    }];
}

//首页进入游戏界面的按钮响应
-(void)starGameAction
{
    [self newGameView:0];
    [[BaiduMobStat defaultStat] logEvent:@"首页页面" eventLabel:@"开始游戏按钮"];
    
}

//进入关于界面的按钮响应
-(void)aboutGameAction
{
    [YouMiWall showGuideMap:YES];
    [YouMiWall showOffers:YES didShowBlock:^{
        NSLog(@"有米推荐墙已显示");
    } didDismissBlock:^{
        NSLog(@"有米推荐墙已退出");
    }];
//    AboutViewController *aboutViewController = [[[AboutViewController alloc] init] autorelease];
//    [self.view addSubview:aboutViewController.view];
//    aboutViewController.view.left = 320;//CGRectMake(320, 0, 320, 460);
//    [UIView animateWithDuration:AnimationTime animations:^{
//        _currentViewController.view.left = -320;//.frame = CGRectMake(-320, 0, 320, 460);
//        aboutViewController.view.left = 0;//.frame = CGRectMake(0, 0, 320, 460);
//        
//    } completion:^(BOOL f){        
//        [_currentViewController.view removeFromSuperview];
//        self.currentViewController = aboutViewController;
//        [aboutViewController setCallback:^{
//            [self backHomeView];
//        }];
//
//    }];
    
    [[BaiduMobStat defaultStat] logEvent:@"首页页面" eventLabel:@"关于按钮"];
}

- (void)pointsGotted:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSNumber *freshPoints = [dict objectForKey:kYouMiPointsManagerFreshPointsKey];
    NSLog(@"积分信息：%@", dict);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:[NSString stringWithFormat:@"获得%@积分", freshPoints] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


//进入关于帮助界面的按钮响应
-(void)helpGameAction
{
    HelperViewController *helpViewController = [[[HelperViewController alloc] init] autorelease];
    helpViewController.view.left = 320;//.frame = CGRectMake(320, 0, 320, 460);
    [self.view addSubview:helpViewController.view];
    
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.left = -320;//.frame = CGRectMake(-320, 0, 320, 460);
        helpViewController.view.left = 0;//.frame = CGRectMake(0, 0, 320, 460);
        
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = helpViewController;
        [helpViewController addBackTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];        
    }];
    
    [[BaiduMobStat defaultStat] logEvent:@"首页页面" eventLabel:@"游戏攻略按钮"];
}

- (void)raceGameAction
{
    RaceViewController *raceViewController = [[[RaceViewController alloc] init] autorelease];
    
    [raceViewController setCompleteBlock:^(id dict) {
        if (1 == [[dict objectForKey:@"status"] intValue]) {
            [self gameOver:[[dict objectForKey:@"sore"] intValue] andPassOrNot:YES image:[dict objectForKey:@"image"]];
        }
        else if (0 == [[dict objectForKey:@"status"] intValue]) {
            [self gameOver:[[dict objectForKey:@"sore"] intValue] andPassOrNot:NO image:[dict objectForKey:@"image"]];
        }
    }];
    
    raceViewController.view.left = 320;
    [self.view addSubview:raceViewController.view];
    
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.left = -320;//.frame = CGRectMake(-320, 0, 320, 460);
        raceViewController.view.left = 0;//.frame = CGRectMake(0, 0, 320, 460);
        
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = raceViewController;
        [raceViewController addBackTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}

//进入排名界面
-(void)gameRankAction
{
    RankViewController *rankViewController = [[[RankViewController alloc] init] autorelease];
    rankViewController.view.left = 320;//.frame = CGRectMake(320, 0, 320, 460);
    [self.view addSubview:rankViewController.view];
    
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.left = -320;//.frame = CGRectMake(-320, 0, 320, 460);
        rankViewController.view.left = 0;//.frame = CGRectMake(0, 0, 320, 460);
        
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = rankViewController;
        [rankViewController addBackTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    [[BaiduMobStat defaultStat] logEvent:@"首页页面" eventLabel:@"排行榜按钮"];
}



//在其他界面返回首页时的按钮响应
- (void)backHomeView
{
    [self playBackgroundMusic:@"backgroundLoop.mp3"];
    //  生成主界面,并初始化配置
    HomeViewController *homeViewController = [[[HomeViewController alloc] init] autorelease];
    homeViewController.view.left = -320;
    [self.view addSubview:homeViewController.view];
    
    //  显示主界面动画
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.left = 320;
        homeViewController.view.left = 0;
        
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = homeViewController;
        
        [homeViewController addStartGameTarget:self action:@selector(starGameAction) forControlEvents:UIControlEventTouchUpInside];
        
        [homeViewController addAboutGameTarget:self action:@selector(aboutGameAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (DebugRace) {
            [homeViewController addRaceGameTarget:self action:@selector(raceGameAction) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [homeViewController addHelpGameTarget:self action:@selector(helpGameAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [homeViewController showRankViewEvent:UIControlEventTouchUpInside withBlock:^(UIButton *button){
            [self gameRankAction];
        }];
        
    }];
}


- (void)stopGame
{
    [self backHomeView];
    GameViewController * gameViewController = (GameViewController *)self.currentViewController;
    [gameViewController stopTimer];
    
}

//游戏界面游戏完成的动作响应
- (void)gameOver:(int)score andPassOrNot:(BOOL)isPass image:(UIImage *)image
{
    [self playBackgroundMusic:@"backgroundLoop.mp3"];
    
    
    if (isPass) {
        [self playSoundWithID:4];
    }
    else
    {
        [self playSoundWithID:5];
        
    }
    //转到结束页面
    GameEndViewController *gameEndViewController = [[[GameEndViewController alloc] init] autorelease];
    gameEndViewController.view.left = 320;//.frame = CGRectMake(320, 0, 320, 460);
    if (isPass) {
        [gameEndViewController.gameEndView setEndViewType:endViewPassThrought];
    } else {
        [gameEndViewController.gameEndView setEndViewType:endViewWrongAnswer];
    }
    [gameEndViewController setShareImage:image];
    [gameEndViewController.gameEndView setScore:score];
    [self.view addSubview:gameEndViewController.view];
    
    [UIView animateWithDuration:AnimationTime animations:^{
        _currentViewController.view.left = -320;//.frame = CGRectMake(-320, 0, 320, 460);
        gameEndViewController.view.left = 0;//.frame = CGRectMake(0, 0, 320, 460);
        
    } completion:^(BOOL f){
        [_currentViewController.view removeFromSuperview];
        self.currentViewController = gameEndViewController;
        [gameEndViewController addBackTarget:self action:@selector(gameRankAction) forControlEvents:UIControlEventTouchUpInside];
        [gameEndViewController newGameTarget:self action:@selector(newGameAction) forControlEvents:UIControlEventTouchUpInside];

    }];


}

//重新游戏是action
- (void)newGameAction
{

    [self newGameView:1];
    
    [[BaiduMobStat defaultStat] logEvent:@"结束页面" eventLabel:@"重新挑战"];

}

/*
//进入gamecenter
- (void)gogamecenter
{
    //GKLeaderboardViewController *controller = [[GKLeaderboardViewController alloc] init];
    RankViewController *controller = [[RankViewController alloc] init];
//    [controller setCategory:@"排行榜的类别"];
//    [controller setLeaderboardDelegate:self];
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

//GKLeaderboardViewControllerDelegate
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
}
*/

//获取版本信息
- (void)getVersion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        VersionInfo *ver = [[DBManager sharedInstance] getVersion];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ((ver.appstoreUrl && ver.appstoreUrl.length > 0) && [CommUtils isUpdate:ver.appVersion]){
                self.appUrl = ver.appstoreUrl;
                if (0 == ver.forceUpdate) {
                    UIAlertView *alrt = [[[UIAlertView alloc] initWithTitle:@"升级提示" message:[NSString stringWithFormat:@"有新版本了，请更新到最新版本(v%@)?", ver.appVersion] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil] autorelease];
                    alrt.tag = UpdateAlertViewTag;
                    [alrt show];

                }
                else
                {
                    UIAlertView *alrt = [[[UIAlertView alloc] initWithTitle:@"升级提示" message:[NSString stringWithFormat:@"是否更新到新版本(v%@)?", ver.appVersion] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil] autorelease];
                    alrt.tag = UpdateAlertViewTag;
                    [alrt show];

                }
            }
        });
    });
    
}


- (void)mute:(BOOL)flag
{
    
    if (flag) {
                
        if (_soundMgr.backgroundMusicVolume > 0) {
            _backgroundVolum = _soundMgr.backgroundMusicVolume;
        }

        if (_soundMgr.soundEffectsVolume > 0) {
            _effectVolum = _soundMgr.soundEffectsVolume;
        }
        
        [_soundMgr setBackgroundMusicVolume:0];
        [_soundMgr setSoundEffectsVolume:0];

    }
    else
    {

        if (_backgroundVolum == 0) {
            _backgroundVolum = 0.5;
        }
        
        if (_effectVolum == 0) {
            _effectVolum = 0.5;
        }
        
        [_soundMgr setBackgroundMusicVolume:_backgroundVolum];
        [_soundMgr setSoundEffectsVolume:_effectVolum];

    }
    [CommUtils setLocalData:[NSNumber numberWithBool:flag] key:@"mute_"];    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (RegistAlertViewTag == alertView.tag) {
        exit(0);
    }
    else if(UpdateAlertViewTag == alertView.tag)
    {
        if (0 == buttonIndex) {
            [CommUtils updateApp:_appUrl];
            exit(0);
        }
    }
}

@end
