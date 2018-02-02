//
//  BaseViewController.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
//  所有viewcontroller的基类，做一些统一的操作
//


#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)dealloc
{
    MLog(@"%@  dealloc", self.class);

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        MLog(@"%@  init", self.class);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    if ([UIDevice isRunningOniPhone5]) {
//        self.view.frame = CGRectMake(0, 0, 320, 460+88);
//    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MLog(@"%@  viewWillAppear", self.class);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MLog(@"%@ viewDidAppear", self.class);    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    MLog(@"%@ viewWillDisappear", self.class);

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    MLog(@"%@ viewDidDisappear", self.class);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    
}


@end
