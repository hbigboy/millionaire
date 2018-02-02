//
//  HelperViewController.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "HelperViewController.h"
#import "HelperView.h"
#import "RootViewController.h"

@interface HelperViewController ()

@end

@implementation HelperViewController

- (void)dealloc
{
    [_helperView release];
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
    _helperView = [[HelperView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_helperView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
    [_helperView.btnBack addTarget:target action:action forControlEvents:controlEvents];
}

@end
