//
//  RaceViewController.m
//  millionaire
//
//  Created by HuangZizhu on 13-9-2.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RaceViewController.h"
#import "RaceView.h"
#import "QuestionView.h"
#import "QButton.h"
#import "Question.h"
#import "RootViewController.h"
#import "StepView.h"
#import "AppDelegate.h"
#import "DataManager.h"

#define kRaceWinScore       @"raceWinScore"
#define kRaceWinScoreId     @"millionaire_playScore"
#define kRaceWinScoreStep   (1)
#define kRaceFininalLevel   (15)
#define kPassMatch          (0) //跳过match对手步骤，用于调试阶段

@interface RaceViewController ()
@property (nonatomic, retain) Question *question;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *myId;
@property (nonatomic, copy) NSString *otherId;
@property (nonatomic, retain) NSArray *questions;
@end

@implementation RaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!_raceView) {
        _raceView = [[RaceView alloc] initWithFrame:self.view.bounds];
        _raceView.controller = self;
    }
    [self.view addSubview:_raceView];
    _raceView.questionView.hidden = YES;

    
#warning 测试代码，需要删除
//    //找到对手后开始游戏
//    if (kPassMatch) {
//        if (!_raceView) {
//            _raceView = [[RaceView alloc] initWithFrame:self.view.bounds];
//            _raceView.controller = self;
//        }
//        [self.view addSubview:_raceView];
//        
//        [_raceView reset];
//        self.level = 0;
//        
//        self.key = @"a,b";
//        [self getQuestionForGameCenter:^(NSArray *questions) {
//            self.questions = questions;
//            [self setQuestion];
//            _raceView.questionView.hidden = NO;
//        }];
//
//        return;
//    }
    
    //[[GCHelper sharedInstance] authenticateLocalUser];
    //AppDelegate *delegate= (AppDelegate *) [UIApplication sharedApplication].delegate;
    //[[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.rootViewController delegate:self];
    
    //game center
    BOOL isGCLogin = [[GCHelper sharedInstance] userAuthenticated];
    if (isGCLogin) {
        AppDelegate *delegate= (AppDelegate *) [UIApplication sharedApplication].delegate;
        [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.rootViewController delegate:self];
    } else {
        [[GCHelper sharedInstance] authenticateLocalUser];
    }

}

- (void)dealloc
{
    self.question = nil;
    [_raceView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_raceView.btnBack addTarget:target action:action forControlEvents:controlEvents];
}



//答题结果：正确or错误，正确进入下一题，错误等待后进入下一题
- (void)answerResult:(NSNumber *)numIsRight
{
    BOOL isRight = [numIsRight boolValue];
    if (isRight) {
        
        [self nextQuestion];
        
    } else {
        
        //暂停7秒钟
        [_raceView addLabelTip];
        [_raceView setLabelTip:@"等待解锁"];
        [self sendMyWrongData];
        NSNumber *numLockTime = [NSNumber numberWithInt:7];
        [_raceView lock:numLockTime block:^{
            MLog(@"timer finished.");
            [_raceView setLabelTip:@"请答题"];
            //self.level -= 1;
            [self nextQuestion];
        }];
    }
}

- (void)nextQuestion
{
    [_raceView reset];
    [self setQuestion];
    
    [GCHelper reportScore:400 forCategory:kRaceWinScoreId];
    AppDelegate *delegate= (AppDelegate *) [UIApplication sharedApplication].delegate;
    //[[GCHelper sharedInstance]showLeaderboardWithUIViewControl:delegate.rootViewController];
    
}

- (void)setQuestion
{
    if (self.level < 15) {
        self.level++;
    }

    [[_raceView stepView] setMyStep:self.level];
    
    //游戏结束-胜利
    if (self.level >= kRaceFininalLevel) {
        
        [self winGame];
        return;
    }
    
    [self sendMyProgressData];
    
    self.question = [_questions objectAtIndex:_level];
    
    MLog(@"答案：%@, %f", _question.question_correct_answer, _question.question_difficulty);
    
    [_raceView setQuestion:_question];
    
    [_raceView questionView].alpha = 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        [_raceView questionView].alpha = 1.0;
        [_raceView questionView].userInteractionEnabled = YES;
        [_raceView addSelectTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    /*[[DBManager sharedInstance] getRandomQuestion:self.level block:^(Question *question){
        
        MLog(@"答案：%@, %f", question.question_correct_answer, question.question_difficulty);
        
        self.question = question;
        [_raceView setQuestion:question];
        
        [_raceView questionView].alpha = 0.0;
        
        
        [UIView animateWithDuration:1.0 animations:^{
            [_raceView questionView].alpha = 1.0;
            [_raceView questionView].userInteractionEnabled = YES;
            [_raceView addSelectTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }];*/
}

//发送答题进度给其他player
- (void)sendMyProgressData
{
    Byte iData[2];
    iData[0] = 0x01;
    iData[1] = (Byte)self.level;
    
    NSData *dLevel = [NSData dataWithBytes:iData length:2];
    NSError *error;
    [[GCHelper sharedInstance].match sendDataToAllPlayers:dLevel withDataMode:GKMatchSendDataReliable error:&error];
}

- (void)sendMyWrongData
{
    Byte iData[2];
    iData[0] = 0x03;
    iData[1] = 0x00;
    
    NSData *dWrong = [NSData dataWithBytes:iData length:2];
    NSError *error;
    [[GCHelper sharedInstance].match sendDataToAllPlayers:dWrong withDataMode:GKMatchSendDataReliable error:&error];

}
- (void)sendGetMyId:(NSString *)sPid
{
    Byte iData[2];
    iData[0] = 0x04;
    iData[1] = 0x00;
    
    NSData *data = [NSData dataWithBytes:iData length:2];
    
    NSData *aData = [sPid dataUsingEncoding: NSUTF8StringEncoding];
    NSMutableData *mdata = [NSMutableData dataWithData:data];
    [mdata appendData:aData];
    
    NSError *error;
    [[GCHelper sharedInstance].match sendDataToAllPlayers:mdata withDataMode:GKMatchSendDataReliable error:&error];
}

//对战获胜
- (void)winGame
{
    [GCHelper sharedInstance].delegate = nil;

    [self sendWinGameData];
    [_raceView setLabelTip:@"胜利!"];
    
    NSNumber *number = [self addWinScore];
    if (_completeBlock) {

        [DataManager resetQuestionsForGameCenter:self.key flag:1];
        _completeBlock([NSDictionary dictionaryWithObjectsAndKeys:@"1", @"status", [NSString stringWithFormat:@"%@", number], @"sore", _image, @"image", nil]);
    }
    
}
//对战失败
- (void)lostGame
{
    [GCHelper sharedInstance].delegate = nil;

    [_raceView setLabelTip:@"失败!"];
    
    if (_completeBlock) {
        
        [DataManager resetQuestionsForGameCenter:self.key flag:1];
        _completeBlock([NSDictionary dictionaryWithObjectsAndKeys:@"0", @"status", _image, @"image", nil]);
    }
}

//对战胜利后增加分数
- (NSNumber *)addWinScore
{
    NSNumber *nScore = [CommUtils getLocalData:kRaceWinScore];
    NSInteger iScore = 0;
    if (nScore) {
        iScore = [nScore integerValue];
    }
    
    iScore += kRaceWinScoreStep;
    
    nScore = [NSNumber numberWithInteger:iScore];
    
    [CommUtils setLocalData:nScore key:kRaceWinScore];
    
    return nScore;
}
//上传分数
- (void)uploadWinScore
{
    NSNumber *nScore = [CommUtils getLocalData:kRaceWinScore];
    NSInteger iScore = 0;
    if (nScore) {
        iScore = [nScore integerValue];
    }
    
    [GCHelper reportScore:(int64_t)iScore forCategory:kRaceWinScoreId];
      
}

//发送获胜信号
- (void)sendWinGameData
{
    Byte iData[2];
    iData[0] = 0x02;
    iData[1] = 0x00;
    NSData *dWinMsg = [NSData dataWithBytes:iData length:2];
    NSError *error;
    [[GCHelper sharedInstance].match sendDataToAllPlayers:dWinMsg withDataMode:GKMatchSendDataReliable error:&error];
}

- (void)checkAnswer:(QButton *)button
{

    [[_raceView questionView] validClick:NO];
    
    qButtonType buttonType = qButtonTypeNomal; //未选中状态
    
    //AnswerType type = AnswerType_Fault;
    if ([self.question.question_correct_answer isEqualToString:button.answer])
    {
        MLog(@"%@", button.answer);
        buttonType = qButtonTypeSucess; //选择正确
        
        [[CommUtils getRootViewController] playSoundWithID:0];//音乐
    }
    else
    {
        [[CommUtils getRootViewController] playSoundWithID:3];//音乐
        
        buttonType = qButtonTypeFail;  //选择错误
        
    }
    
    //如果选择错误，则提示正确答案
    [button setResultState:buttonType block:^(){
        if (buttonType != qButtonTypeSucess) {
            QButton *qButton = [[_raceView questionView] rigthAnswer];
            [qButton setResultState:qButtonTypeSucess block:^(){
                UIImage *image = [CommUtils getNormalImage:_raceView];
                
                self.image = image;
                
                //显示答对打错
                [_raceView performSelector:@selector(showResultAnimation:) withObject:[NSNumber numberWithBool:NO] afterDelay:1.0];

            
            }];
        }
        else
        {
            UIImage *image = [CommUtils getNormalImage:_raceView];
            
            self.image = image;
            
            //显示答对打错
            [_raceView performSelector:@selector(showResultAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0];

        }
    }];

    
}

- (void)startGame:(NSString *)key
{
    _raceView.questionView.hidden = NO;
    [_raceView reset];
    self.level = 0;
    
    [self getQuestionForGameCenter:^(NSArray *questions) {
        self.questions = questions;
        [self setQuestion];
        
    }];
}

#pragma mark -
#pragma mark - game center delegate
- (void)matchStarted:(NSString *)matchIDs
{
    //找到对手后开始游戏
    [self sendGetMyId:matchIDs];
}

-(void)matchEnded
{
    [DataManager resetQuestionsForGameCenter:self.key flag:1];
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"连接结束" message:[NSString stringWithFormat:@"game center连接断开"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alrt show];
    [alrt release];
}

//接收到其他玩家的消息
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    Byte d[2];
    [data getBytes:d length:2];
    
    if (d[0] == 0x01) {
        MLog(@"enemy progress is %d", (int)d[1]);
        NSInteger iEnemyProgress = d[1];
        [[_raceView stepView] setEnemyStep:iEnemyProgress];
    }
    if (d[0] == 0x02 && d[1] == 0x00) {
        MLog(@"enemy win game.");
        
        [self lostGame];
        
        [_raceView setLabelTip:@"对方获胜"];
        [[_raceView stepView] setEnemyStep:15];
        [_raceView questionView].userInteractionEnabled = NO;
        [self lostGame];
    }
    if (d[0] == 0x03 && d[1] == 0x00) {
        MLog(@"enemy Wrong, u get one step.");
        [_raceView setLabelTip:@"免答一题"];
        [self nextQuestion];
    }
    if (d[0] == 0x04 && d[1] == 0x00) {
        NSMutableData *dataTmp = [NSMutableData dataWithData:data];
        
        Byte *bTmp = (Byte *)malloc([dataTmp length] - 2);
        
        NSRange range;
        range.location = 2;
        range.length = [dataTmp length] - 2;
        [dataTmp getBytes:bTmp range:range];
        NSString *myID = [NSString stringWithUTF8String:(const char*)bTmp];
        MLog(@"%@",myID);
        MLog(@"%@",playerID);
        free(bTmp);
        
        NSArray *myID_ = [myID componentsSeparatedByString:@":"];
        if (myID_.count == 2) {
            self.myId = [myID_ objectAtIndex:1];
        }
        
        NSArray *playerID_ = [playerID componentsSeparatedByString:@":"];
        if (playerID_.count == 2) {
            self.otherId = [playerID_ objectAtIndex:1];
        }
        
        self.key = _myId.longLongValue > _otherId.longLongValue ? [NSString stringWithFormat:@"%@%@", _myId, _otherId] : [NSString stringWithFormat:@"%@%@", _myId, _otherId];
        
        [self startGame:self.key];

    }
}

- (void)getQuestionForGameCenter:(void(^)(NSArray *))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *questions = [DataManager fectchQuestionsForGameCenter:@"a,b"];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(questions);
        });      
        
    });
}

#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [GCHelper sharedInstance].delegate = nil;
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate.rootViewController backHomeView];
    }
}

@end
