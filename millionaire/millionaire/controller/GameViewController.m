//
//  GameViewController.m
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "QuestionView.h"
#import "Question.h"
#import "QuestionRecord.h"
#import "QButton.h"
#import "TimerView.h"
#import "WaitingView.h"
#import "WinGameView.h"
#import "AppSingleton.h"
#import "CheckPointsView.h"
#import "math.h"
#import "ScoreView.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StepView.h"
#import "BaiduMobStat.h"
#import "AppDelegate.h"
#import "RootViewController.h"

#define kTitlePayCoins @"扣取金币"
#define kMPayCoinsToPlay @"即将扣取金币数%d个，进入答题挑战"

#define STARTGAME   @"开始游戏"
#define GETREADY    @"READY!!!"
#define MESSAGEGO   @"GO"

@interface GameViewController ()
{
    GameView    *_gView;
    NSTimer     *_timer;
    NSInteger   _level;     //记录答题进度
    NSInteger   _score;     //本局累计得分
    NSInteger   _qScore;     //本关得分
    NSInteger   _minScore;  //本局保底等分
    int         _payScoreCount;
}
@property (nonatomic, copy) void(^actionBlock)(int, int, BOOL, UIImage *);
@property (nonatomic, retain) UIImage *image;//暂存题目题片
@end

@implementation GameViewController

- (void)dealloc
{
    [self stopTimer];
    
    self.image = nil;
    self.actionBlock = nil;
    self.question = nil;
    [_gView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _level = 0;  //初始级别
        _score = 0; //本局初始得分
        _minScore = 0; //本局保底得分
        _qScore = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _gView = [[GameView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_gView];
    [self initGView];//初始化gview

    
    //弹出一个alertview，点击确定扣取用户金币后显示答题页面
//    float c = 0.5;
//    int mLevel = 5;
//    int maxPayCount = [[[CommUtils getLevels] objectAtIndex:mLevel] integerValue];
//    
//    [[DBManager sharedInstance] getScore:^(int score){
//        _payScoreCount = (c * sqrt(score));
//        _payScoreCount = MIN(_payScoreCount, score); //避免扣取金币数过大
//        _payScoreCount = MIN(_payScoreCount, maxPayCount);
//        _qScore = _payScoreCount*(-1);
//        NSString *message = [NSString stringWithFormat:kMPayCoinsToPlay, _payScoreCount];
    
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STARTGAME message:GETREADY delegate:self cancelButtonTitle:MESSAGEGO otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];


//    }];
    
    [[CommUtils getRootViewController] playBackgroundMusic:@"game_bm_level_1.mp3"];
    
    
    [self randomQuestion];
    
    
}

#pragma mark -- alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLog(@"clicked alert view button");
    
    if (buttonIndex == 0) {
        
        [[CommUtils getRootViewController] playBackgroundMusic:@"game_bm_level_1.mp3"];
        
        
        [self randomQuestion];
        
        [[BaiduMobStat defaultStat] logEvent:@"游戏页面" eventLabel:@"进入按钮"];
    }
    else
    {
        _payScoreCount = 0;
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.rootViewController stopGame];
        
        [[BaiduMobStat defaultStat] logEvent:@"游戏页面" eventLabel:@"取消按钮"];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    MLog(@"test");
}

- (void)initGView
{
    [_gView reset];

    [_gView addSelectTarget:self action:@selector(checkAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)getScroeFromLevel:(NSInteger)level
{
    NSArray * levels = [CommUtils getLevels];
    return [[levels objectAtIndex:level] intValue];
}

//随机题目
- (void)randomQuestion
{
    [self prepareQuestion];
    
    
    
    [[DBManager sharedInstance] getRandomQuestion:_level block:^(Question *question){
        MLog(@"答案：%@, %f", question.question_correct_answer, question.question_difficulty);
        self.question = question;
        [_gView setQuestion:question];

        
        [UIView animateWithDuration:0.3 animations:^{
            [_gView questionView].alpha = 1.0;
        }];
        
        [[_gView waitingView] readyGo:^{
            [_gView questionView].userInteractionEnabled = YES;
            //[[_gView timerView] startTimer];
            [self startProgressTimer];

        }];
        
    }];
}

//准备题目
- (void)prepareQuestion
{
    //设置分数
    [[_gView checkPointsView] addScore:_qScore];
    
    
    [_gView reset];
    
    //  设置奖金金额
    if (_level < 15) {
        _level++;
    }
    
    if (_level > 5) {
        [[CommUtils getRootViewController] playBackgroundMusic:@"game_bm_level_2.mp3"];
    }
    _minScore = 0; //保底奖金
    
    if (_level > 10) {
        _minScore = [self getScroeFromLevel:10];
    } else if (_level > 5) {
        _minScore = [self getScroeFromLevel:5];
    } else {
        _minScore = 0;
    }
    
    [_gView.stepView setStep:_level];
    
    [_gView.lbLevel setText:[NSString stringWithFormat:@"第%d关,保底奖金￥%d",_level,_minScore]];
    
    NSInteger qScore = [[[CommUtils getLevels] objectAtIndex:_level-1] intValue];//当前题目得分
    [[_gView scoreView] setTimerViewScore:qScore timeFireBlock:^(){
        
    } timeoutBlock:^(){}];
    
    [[_gView timerView] setTimerView:15 timeOutBlock:^(){
        [[_gView questionView] validClick:NO]; //不允许点击
        [self createQuestionRecord:qButtonTypeFail answer:nil];
        NSNumber *numResult = [NSNumber numberWithInteger:answerTimeOut];
        [self performSelector:@selector(showResultView:) withObject:numResult afterDelay:1];
        
        [[CommUtils getRootViewController] playSoundWithID:2];//音乐
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_gView questionView].alpha = 0;
    }];
    
}

- (void)checkAnswer:(QButton *)button
{
    
    //[[_gView timerView] stopTimer];
    [self stopProgressTimer];
    [[_gView questionView] validClick:NO];
    
    qButtonType buttonType = qButtonTypeNomal; //未选中状态
    //AnswerType type = AnswerType_Fault;
    NSString *rightAnswerContent = [[DBManager sharedInstance] getRightAnswerContent:self.question];
    if ([rightAnswerContent isEqualToString:button.answer])
    {
        MLog(@"%@", button.answer);
        buttonType = qButtonTypeSucess; //选择正确
        //type = AnswerType_Right;
        _score += [[_gView scoreView] getScore];//[self getScroeFromLevel:_level-1];
        _qScore = [[_gView scoreView] getScore];
        
        [[CommUtils getRootViewController] playSoundWithID:0];//音乐
    }
    else
    {
        [[CommUtils getRootViewController] playSoundWithID:3];//音乐
        
        buttonType = qButtonTypeFail;  //选择错误
        //_score = _minScore;  //保底得分
        _qScore = 0;
    }

    

    //如果选择错误，则提示正确答案
    [button setResultState:buttonType block:^(){
        if (buttonType != qButtonTypeSucess) {
            QButton *qButton = [[_gView questionView] rigthAnswer];
            [qButton setResultState:qButtonTypeSucess block:^(){}];
            
            UIImage *image = [CommUtils getNormalImage:_gView];
            
            //image = [CommUtils cropImage:image rect:CGRectMake(0, 20, self.view.width, self.view.height - 20)];
            
            self.image = image;
            
        }
    }];
    
    //记录答题行为
    [self createQuestionRecord:buttonType answer:button.answer];

    // 提示答对答错
    //[self performSelector:@selector(showScoreView:) withObject:[_gView questionView] afterDelay:1];
    NSInteger iResult = (NSInteger)buttonType;
    NSNumber *numResult = [NSNumber numberWithInteger:iResult];
    [self performSelector:@selector(showResultView:) withObject:numResult afterDelay:1];

}


- (void)startProgressTimer
{
//#warning 测试代码，需要删除
    [[_gView timerView] startTimer];
    [[_gView scoreView] startTimer];
}

- (void)stopProgressTimer
{
    [[_gView timerView] stopTimer];
    [[_gView scoreView] stopTimer];
}

//显示答对答错页面
- (void)showResultView:(NSNumber *)result
{
    eAnswerResult answerResult = [result integerValue];
    BOOL isRight = (answerResult == answerRight);
        
    if (isRight && _level == 15) {
        
        //通关
        //显示挑战成功页面
        if (_actionBlock) {
            _actionBlock(_score, _payScoreCount, YES, nil);
            
        }
        
        [[BaiduMobStat defaultStat] logEvent:@"游戏页面" eventLabel:@"15关通关"];
        return;
    }
    
    //百度统计
    if (answerResult == answerRight) {
        NSString *strMsg = [NSString stringWithFormat:@"答对第%d题",_level];
        [[BaiduMobStat defaultStat] logEvent:@"游戏页面" eventLabel:strMsg];
    } else if (answerResult == answerWrong) {
        NSString *strMsg = [NSString stringWithFormat:@"答错第%d题",_level];
        [[BaiduMobStat defaultStat] logEvent:@"游戏页面" eventLabel:strMsg];
    } else if (answerResult == answerTimeOut) {
        NSString *strMsg = [NSString stringWithFormat:@"第%d题超时",_level];
        [[BaiduMobStat defaultStat] logEvent:@"游戏页面" eventLabel:strMsg];

    }
    
    if (answerResult == answerRight) {
        //[[_gView winGameView] setAnswerResultView:answerResult];
        [self randomQuestion]; //生成新的题目
        return;
    }
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [_gView winGameView].alpha = 1;
        [[_gView winGameView] showView:YES];
        //[[_gView winGameView] setLevelScore:[self getScroeFromLevel:_level-1]];
        [[_gView winGameView] setLevelScore:[[_gView scoreView] getScore]];
    } completion:^(BOOL f){
        [[_gView winGameView] startTimer:(isRight ? 1 : 1) block:^(){
            if (isRight) {
                [self randomQuestion]; //生成新的题目
            } else {
                if (_actionBlock) {
                    _actionBlock(_score, _payScoreCount, NO, _image);
                }
            }
        }];
    }];
    
}

- (void)gameOver:(void(^)(int, int, BOOL, UIImage *))actionBlock
{
    self.actionBlock = actionBlock;
}

//记录答题结果到数据库中
- (void)createQuestionRecord:(qButtonType)type answer:(NSString *)answer
{
    
    QuestionRecord *questionRecord = [[QuestionRecord alloc] init];
    questionRecord.uid = [[AppSingleton sharedInstance].uid intValue];
    questionRecord.qid = _question.question_id;
    
    if (type == qButtonTypeSucess) {
        questionRecord.isPass = YES;
    }
    else
    {
        questionRecord.isPass = NO;
    }
    
    questionRecord.answer = answer;
    questionRecord.createTime = [[NSDate date] timeIntervalSince1970];
    
    [[DBManager sharedInstance] synQuestionRecord:questionRecord];
    
    [questionRecord release];
    
}


- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_gView addBackHomeTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
    
    [_gView addBackHomeTarget:self action:@selector(scoreToDB) forControlEvents:controlEvents];

    [_gView addBackHomeTarget:target action:action forControlEvents:controlEvents];

}

- (void)stopTimer
{
    [_timer invalidate];
    [_timer release];
    _timer = nil;
    
    [self stopProgressTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

}

- (void)scoreToDB
{
    [[DBManager sharedInstance] resetQuestion];
    if (_score != 0 || _payScoreCount != 0) {
        MLog(@"add score :%d", _score);
        [[DBManager sharedInstance] addScore:(_score - _payScoreCount) completeBlock:^(BOOL ret){}];
    }
    
}





@end
