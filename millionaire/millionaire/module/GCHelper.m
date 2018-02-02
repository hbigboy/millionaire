//
//  GCHelper.m
//  fly
//
//  Created by liu jian on 13-8-14.
//
//

#import "GCHelper.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

#define kWinScore @"ScoreTotalID"

@implementation GCHelper
@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;
@synthesize playersDict;

static GCHelper *sharedHelper = nil;

+(GCHelper *)sharedInstance{
    if(!sharedHelper){
        sharedHelper = [[GCHelper alloc] init];
        
    }
    return sharedHelper;
}

-(BOOL)isGameCenterAvailable{
    //check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice]systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
    
    return YES;
}


-(id)init{
    if((self = [super init])){
        
        gameCenterAvailable = [self isGameCenterAvailable];
        if(gameCenterAvailable){
            
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
            
        }
    }
    return self;
}

-(BOOL)authenticationStatus
{
    return userAuthenticated;
}
-(void)authenticationChanged{
    
    if([GKLocalPlayer localPlayer].isAuthenticated&& ! userAuthenticated){
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        
    }else if(![GKLocalPlayer localPlayer].isAuthenticated&&userAuthenticated){
        NSLog(@"Authentication changed: player not authenticated..");
        userAuthenticated = FALSE;
    }
}
-(void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller
{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}

-(void)authenticateLocalUser{
    //return;
    if(!gameCenterAvailable){
        return;
    }
    
    NSLog(@"Authentication local user...");
    if([GKLocalPlayer localPlayer].authenticated == NO){
        
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
        NSLog(@"%@",error);
        NSLog(@"authentic finish.");
        }];
        
    }else{
        
        NSLog(@"Already authenticated!");
        
    }
}


-(void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate{
    
    
    if(!gameCenterAvailable){
        return;
    }
    
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;
    [presentingViewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest *request = [[[GKMatchRequest alloc]init]autorelease];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request]autorelease];
    mmvc.matchmakerDelegate = self;
    
    [presentingViewController presentModalViewController:mmvc animated:YES];
    
}

-(void)lookupPlayers{
    
    NSLog(@"Looking up %d players...",match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players,NSError *error){
        
        
        if(error != nil){
            NSLog(@"Error retrieving player info:%@",error.localizedDescription);
            matchStarted = NO;
            if (delegate) {
                [delegate matchEnded];
            }
        
        }else{
            
            //参与者所有的id集合成key
            NSString *sIds = @"";
            //Populate playersdict
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for(GKPlayer *player in players){
                NSLog(@"Found player:%@",player.alias);
                [playersDict setObject:player forKey:player.playerID];
                self.herName = player.alias;
                sIds = [sIds stringByAppendingString:player.playerID];
            }
            //Notify delegate match can begin
            matchStarted = YES;
            if (delegate) {
                [delegate matchStarted:sIds];
            }
        
        }
        
    }];
    
    
    
}

#pragma mark GKMatchmakerViewControllerDelegate

//The user has cancelled matchmaking
-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController{
    
    [presentingViewController dismissModalViewControllerAnimated:YES];
    
    //返回到主页
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    RootViewController *controller = delegate.rootViewController;
    [controller backHomeView];
}

//Matchmaking has failed with an error

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error{
    
    [presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    
    [presentingViewController dismissModalViewControllerAnimated:YES];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}


//The match received data sent from the player.
-(void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID{
    
    if(match != theMatch)
        return;
    
    [presentingViewController dismissModalViewControllerAnimated:YES];
    
    if (delegate) {
        [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
    }

}


//The player state changed(eg.connected or disconnected)
-(void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state{
    if(match != theMatch)
    return;
    
    switch (state) {
        case GKPlayerStateConnected:
            //handle a new player connection.
            NSLog(@"player connected!");
            
            if(!matchStarted&&theMatch.expectedPlayerCount == 0){
                [self lookupPlayers];
                NSLog(@"Ready to start match!");
            }
            break;
        case GKPlayerStateDisconnected:
            //a player just disconnected.
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            if (delegate) {
                [delegate matchEnded];
            }
            
            
            break;
    }
    
}


//THE MATCH WAs unable to connect with the player due to an error.

-(void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error{
    
    if(match != theMatch) return;
    
    NSLog(@"Match failed with error: %@",error.localizedDescription);
    matchStarted = NO;
    if (delegate) {
        [delegate matchEnded];
    }
}





#pragma mark For Leaderboard
-(void)showLeaderboardWithUIViewControl:(UIViewController *)viewController
{
    //ScoreTotalID
    GKLeaderboardViewController * leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    [leaderboardViewController setCategory:@"ScoreTotalID"];
    [leaderboardViewController setLeaderboardDelegate:self];
    self.presentingViewController = viewController;
    [presentingViewController presentModalViewController:leaderboardViewController  animated:YES];
    [leaderboardViewController release];
    
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [presentingViewController dismissModalViewControllerAnimated: YES];
}
+(void) reportScore: (int64_t) score forCategory: (NSString*) category
{
	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
			// handle the reporting error
			MLog(@"上传分数出错.");
			//如果网络出错，需要本地存储分数，后续尝试重传
		}else {
            MLog(@"上传分数成功");
		}
	}];
}
@end
