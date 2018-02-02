//
//  AboutViewController.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutView.h"
#import "RootViewController.h"
#import "VersionInfo.h"
@interface AboutViewController ()<UIAlertViewDelegate>
{
    AboutView *_aboutView;
}
@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, retain) VersionInfo *version;
@end

@implementation AboutViewController

-(void)dealloc
{
    self.version = nil;
    self.backBlock = nil;
    [_aboutView release];
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
    _aboutView = [[AboutView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_aboutView];
    
    [_aboutView setCallback:^(UIButton* btn){
        //[self getVersion:btn];
    } backBlock:^{
        if (_backBlock) {
            _backBlock();
        }
    }];
    
    
    //[self getVersion:nil];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVersion:(id)sender
{
    [_aboutView enableUpdateButton:NO];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        VersionInfo *versionInfo = [[DBManager sharedInstance] getVersion];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_aboutView enableUpdateButton:YES];
            if ((versionInfo.appstoreUrl && versionInfo.appstoreUrl.length > 0) && [CommUtils isUpdate:versionInfo.appVersion]) {
                if (sender) {
                    self.version = versionInfo;
                    UIAlertView *alrt = [[[UIAlertView alloc] initWithTitle:@"升级提示" message:[NSString stringWithFormat:@"是否更新到新版本(v%@)?", versionInfo.appVersion] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil] autorelease];
                    alrt.tag = UpdateAlertViewTag;
                    [alrt show];
                }
            }
            else
            {
                if (sender) {
                    UIAlertView *alrt = [[[UIAlertView alloc] initWithTitle:@"升级提示" message:@"已经是最新版本" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] autorelease];
                    [alrt show];
                }                
            }
        });
    });

}

- (void)setCallback:(void (^)(void))callback
{
    self.backBlock = callback;
}


#pragma mark AlertViewDelagate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (UpdateAlertViewTag == alertView.tag) {
        if (0 == buttonIndex) {
            [CommUtils updateApp:_version.appstoreUrl];
        }
    }
}
@end
