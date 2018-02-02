//
//  HomeViewController.m
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
//#import "GADBannerView.h"

@interface HomeViewController ()
{
    HomeView    *_homeView;
}
@end

@implementation HomeViewController
-(void)dealloc
{
    [_homeView release];
    [super dealloc];
}

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
    
    _homeView = [[HomeView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_homeView];

    //- (void)getScore:(void(^)(int))resultBlock;
//    [[DBManager sharedInstance] getScore:^(int score){
//        [_homeView setCoinCount:IntergerToString(score)];
//    }];
    NSInteger score = [[[DBManager sharedInstance] getHighestScore] integerValue];
    [_homeView setCoinCount:[NSString stringWithFormat:@"最高分: %d", score]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 添加事件

- (void)addStartGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_homeView addStartGameTarget:target action:action forControlEvents:controlEvents];
}

- (void)addAboutGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_homeView addAboutGameTarget:target action:action forControlEvents:controlEvents];
}

- (void)addHelpGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_homeView addHelpGameTarget:target action:action forControlEvents:controlEvents];
}

- (void)addRaceGameTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_homeView addRaceGameTarget:target action:action forControlEvents:controlEvents];
}

- (void)showRankViewEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;
{
    [_homeView showRankViewEvent:controlEvent withBlock:action];
}
/*
-(void)startGameEvent:(ActionBlock)action;
{
    [_homeView startGameEvent:action];
}


-(void)aboutEvent:(ActionBlock)action
{
    [_homeView aboutEvent:action];

}

-(void)helpEvent:(ActionBlock)action
{
    [_homeView helpEvent:action];
}
 */
@end
