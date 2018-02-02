//
//  AppDelegate.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "DataManager.h"
#import "RankInfo.h"
#import "BaiduMobStat.h"
#import "WXApi.h"
#import "GCHelper.h"
#import "GADBannerView+Preload.h"
#import "YouMiPointsManager.h"
#import "YouMiConfig.h"
#import "YouMiWall.h"

//-------------install-------@add by hqz ---- 2013/08/16 -----------
#if InstallIPAFlag
#import "IPAInstall.h"
#import "InstallMacro.h"
#endif

#define kBaiduChannelId_91 @"91zhushou"
#define kBaiduChannelId_Appstore @"苹果商店"
#define kBaiduMSId @"5bc6a95ad1"


@interface AppDelegate()<WXApiDelegate>
{
    AdsView *_adsView;
}

@end

@implementation AppDelegate

- (void)dealloc
{
    [_adsView release];
    self.rootViewController = nil;
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

#warning bundld id 需要修改为发布的id
    
    
    [WXApi registerApp:@"wxd00e7c75737fd339"];
    
    /*

    NSArray *rankInfos = [DataManager getRank];
    for (RankInfo *rankInfo in rankInfos) {
        NSLog(@"%@", rankInfo);
    }
    
    VersionInfo *version = [[DBManager sharedInstance] getVersion];
    NSLog(@"%@", version);
     
   float ratio = [[DBManager sharedInstance] getGoldRatio];
   NSLog(@"%f", ratio);

    */
    //[DataManager getQuestionDif:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil]];
    
    /*
//    {"code":"BW0001","data":[{"id":"2","num":"100","price":"0"},{"id":"3","num":"100","price":"0"}]}
 
//    NSString *str = @"{\"code\":\"BW0001\",\"data\":[{\"id\":\"2\",\"num\":\"100\",\"price\":\"0\"},{\"id\":\"3\",\"num\":\"100\",\"price\":\"0\"},{\"id\":\"4\",\"num\":\"100\",\"price\":\"0\"},{\"id\":\"5\",\"num\":\"100\",\"price\":\"0\"},{\"id\":\"6\",\"num\":\"100\",\"price\":\"0\"},{\"id\":\"7\",\"num\":\"67\",\"price\":\"0\"}]}";
    
    NSArray *keys = [NSArray arrayWithObjects:@"id", @"num", @"price", nil];
    NSArray *values = [NSArray arrayWithObjects:@"2", @"100", @"0", nil];
    NSMutableDictionary *d_ = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    NSArray *arr = [NSArray arrayWithObject:d_];
    
    NSMutableDictionary *dict =  [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:arr forKey:@"data"];    
    [dict setObject:@"BW0001" forKey:@"code"];
    
    NSString *str = [dict JSONString];
    
    str = @"{\"code\":\"BW0001\", \"data\":[{\"id\":\"2\",\"num\":\"100\",\"price\":\"0\"}]}";

    NSData *d = [ASIDataCompressor compressData:[str dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:test_url]];
    [request startSynchronous];
    
//    BOOL *dataWasCompressed = [request isResponseCompressed]; // 响应是否被gzip压缩过？
//    NSData *compressedResponse = [request rawResponseData]; // 压缩的数据
    NSData *uncompressedData = [request responseData]; // 解压缩后的数据
    
    
    uncompressedData = [CommUtils decompressData:uncompressedData];
    NSString* aStr3 = [[NSString alloc] initWithData:uncompressedData encoding:NSUTF8StringEncoding];


    
    NSString* aStr = [[NSString alloc] initWithData:uncompressedData encoding:NSASCIIStringEncoding];
    
    NSString* aStr2 = [[NSString alloc] initWithData:uncompressedData encoding:NSUnicodeStringEncoding];
*/
    
//    _adsView = [[AdsView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [_adsView initYoumi];

    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
      
    _rootViewController = [[RootViewController alloc] init];
    self.window.rootViewController = _rootViewController;

    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [_adsView addYouMiView:self.window];
    [[GADBannerView sharedInstance] loadAd];
    
    //有米积分墙
    [YouMiConfig launchWithAppID:@"ba71763c64f50979" appSecret:@"e5a2af60d44297eb"];
    // 开启积分管理[本例子使用自动管理];
    [YouMiPointsManager enable];
    // 开启积分墙
    [YouMiWall enable];
    // 设置显示积分墙的全屏UIWindow
    [YouMiConfig setFullScreenWindow:self.window];

    
    //baidu统计
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = NO;
    statTracker.sessionResumeInterval = 60;
    statTracker.channelId = kBaiduChannelId_91;
    //statTracker.channelId = @"TESTER";
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    statTracker.logSendInterval = 1;
    [statTracker startWithAppId:kBaiduMSId];
    
    //game center
    //[[GCHelper sharedInstance] authenticateLocalUser];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [_rootViewController getVersion];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void) onReq:(BaseReq*)req
{
    MLog(@"onReq");
}

- (void) onResp:(BaseResp*)resp
{
    MLog(@"onResp");
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = [NSString stringWithFormat:@"发送消息结果:%d", resp.errCode];
        MLog(@"onResp: %@", strMsg);
    }
}



#if InstallIPAFlag   //@add by hqz 2013/08/16
- (void)install:(NSDictionary *)dict_param
{
    //if (self.installAppInfo) {

    NSString *identifier = [dict_param objectForKey:@"identifier"];
    NSString *downloadPath = [dict_param objectForKey:@"download_path"];

    if ((identifier && identifier.length > 0) && (downloadPath && downloadPath.length > 0 && ([downloadPath hasPrefix:@"http://"] || [downloadPath hasPrefix:@"https://"]))) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:identifier, InstallIPANameKey, identifier, InstallIPAIdentifierKey, downloadPath, InstallIPADownLoadPathKey, nil];
        [IPAInstall addTask:dict showInView:self.window block:^BOOL{
            return YES;
        }];
    }
}

#endif


- (AdsView *)adsView
{
    return _adsView;
}
@end
