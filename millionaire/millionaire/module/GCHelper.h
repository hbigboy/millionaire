//
//  GCHelper.h
//  fly
//
//  Created by liu jian on 13-8-14.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
//#import "GKMatchmakerViewController_LandscapeOnly.h"
//#import "flyAppDelegate.h"

@protocol GCHelperDelegate

-(void)matchStarted:(NSString *)matchIDs; //开始匹配对手
-(void)matchEnded;  //匹配结束
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;

@end



@interface GCHelper : NSObject <GKLeaderboardViewControllerDelegate,GKMatchmakerViewControllerDelegate,GKMatchDelegate>
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    id<GCHelperDelegate> delegate;
    
    NSMutableDictionary *playersDict;
}
@property(assign,readonly) BOOL userAuthenticated;
@property(assign,readonly) BOOL gameCenterAvailable;
@property(retain) NSMutableDictionary *playersDict;

@property(retain) UIViewController *presentingViewController;
@property(retain) GKMatch *match;
@property(assign) id<GCHelperDelegate> delegate;
@property(retain) NSString* herName;

+(GCHelper*)sharedInstance;
-(void)authenticateLocalUser;
-(BOOL)authenticationStatus;

-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                viewController:(UIViewController *)viewController
                      delegate:(id<GCHelperDelegate>)theDelegate;

-(void)showLeaderboardWithUIViewControl:(UIViewController *)viewController;
+(void) reportScore: (int64_t) score forCategory: (NSString*) category;

@end


