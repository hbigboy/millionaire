//
//  RankViewController.m
//  millionaire
//
//  Created by zizhu on 13-8-7.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RankViewController.h"
#import "RankView.h"
#import "CommUtils.h"

@interface RankViewController ()
{
    RankView *_rankView;
}
@end

@implementation RankViewController

- (void)dealloc
{
    [_rankView release];
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
    
    _rankView = [[RankView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_rankView];
    
    /*NetworkStatus reachbility = [CommUtils checkNetWork];
    if (reachbility == NotReachable) {
        UIAlertView *alrt = [[[UIAlertView alloc] initWithTitle:@"网络连接错误" message:@"获取排名失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        alrt.tag = UpdateAlertViewTag;
        [alrt show];
    }*/
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[DBManager sharedInstance] getRank:^(NSArray *ranks) {
            _rankView.dataArray = ranks;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //获取到排名数据
                [_rankView.tableView reloadData];
                //设置排名
                [_rankView refreshRankOrder];
                
            });
        }];
       
    });

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
    [_rankView.btnBack addTarget:target action:action forControlEvents:controlEvents];
}


@end
