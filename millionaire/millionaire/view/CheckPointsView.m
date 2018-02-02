//
//  CheckPoints.m
//  millionaire
//
//  Created by book on 13-8-1.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
#import "CheckPointsView.h"
#import "CommUtils.h"

@interface CheckPointsView()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *_scoreLb;
}
@property (nonatomic, assign) int score;
@end
@implementation CheckPointsView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rc = self.frame;
        rc.origin.x = 0;
        rc.origin.y = 0;
        UIImageView *imgvBg = [[UIImageView alloc] initWithFrame:rc];
        UIImage *image = [UIImage imageNamed:@"game_totalCheckPoint.png"];
        imgvBg.image = image;
        [self addSubview:imgvBg];
        [imgvBg release];
        
        UIColor *clr01 = colorRGB(0xff, 0xc0, 0x00);
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, self.frame.size.height)];
        lb.font = [UIFont systemFontOfSize:12];
        lb.backgroundColor = [UIColor clearColor];
        lb.textColor = clr01;
        lb.text = @"总金币:";
        [self addSubview:lb];
        
        
        rc.origin.x += lb.frame.size.width + 5;
        rc.size.width = self.frame.size.width - lb.frame.size.width - 10;
        _scoreLb = [[UILabel alloc] initWithFrame:rc];
        _scoreLb.backgroundColor = [UIColor clearColor];
        _scoreLb.textColor = clr01;
        _scoreLb.textAlignment = UITextAlignmentCenter;
        _scoreLb.font = [UIFont systemFontOfSize:14];
        [self addSubview:_scoreLb];
        _scoreLb.centerY = lb.centerY;
        [lb release];
        
        [[DBManager sharedInstance] getScore:^(int score){
            _scoreLb.text = IntergerToString(score);
        }];
        
    }
    
    return self;
}

- (void)addScore:(int)newScore
{
    _scoreLb.text = IntergerToString(_scoreLb.text.intValue + newScore);
}

@end


/*
 
#import "CheckPointsView.h"
#import "CheckPointsCell.h"
#import "CommUtils.h"

@interface CheckPointsView()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic, retain) NSArray * dataArray;
@end

@implementation CheckPointsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.dataArray = [NSArray arrayWithObjects:
                          @"恭喜您顺利过关",
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:15]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:14]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:13]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:12]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:11]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:10]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:9]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:8]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:7]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:6]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:5]],
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:4]],                          
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:3]],
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:2]],
                          [NSString stringWithFormat:@"%@", [CommUtils getLevels:1]],
                          @"开始",
                          nil];
        
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.image = [UIImage imageNamed:@"check_points_bg.png"];
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = NO;
        
        UIImageView *maskView = [[UIImageView alloc] initWithFrame:self.bounds];
        maskView.image = [UIImage imageNamed:@"check_points_mask.png"];
        
        UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height-31)/2, self.width, 31)];
        selectView.image = [UIImage imageNamed:@"check_points_select.png"];


        [self addSubview:bgView];
        [self addSubview:_tableView];
        [self addSubview:maskView];
        [self addSubview:selectView];
        
    }
    return self;
}

#pragma mark Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (float)81/3;
}
#pragma mark Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"check_points";
    
    CheckPointsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[CheckPointsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    };
    
    cell.titleLb.text = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)scrollToIndex:(int)index
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
@end
 */
