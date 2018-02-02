//
//  SplashViewController.m
//  millionaire
//
//  Created by book on 13-7-15.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "SplashViewController.h"
#import "SplashView.h"

@interface SplashViewController ()
{
    SplashView          *_splashView;//闪屏动画container
}
@end

@implementation SplashViewController


-(void)dealloc
{
    [_splashView release];
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
    _splashView = [[SplashView alloc] initWithFrame:self.view.bounds];
    //_splashView.top = 20;
    _splashView.bgView.image = [UIImage imageNamed:@"Default.png"];
    if ([UIDevice isRunningOniPhone5]) {
        _splashView.bgView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    [self.view addSubview:_splashView];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
