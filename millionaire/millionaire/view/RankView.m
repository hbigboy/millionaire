//
//  RankView.m
//  millionaire
//
//  Created by zizhu on 13-8-7.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RankView.h"
#import "RankViewCell.h"
#import "AppSingleton.h"
#import "RankInfo.h"
@interface RankView()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation RankView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self iniSubviews];
        
        self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped] autorelease];
        _tableView.top = 100;
        if ([UIDevice isRunningOniPhone5]) {
            _tableView.top = 130;
        }
        _tableView.height = self.height - _tableView.top;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        
        UIImageView *titleLb = [[UIImageView alloc] initWithFrame:CGRectMake((320-100)/2, _btnBack.top, 86, 37)];
        titleLb.image = [UIImage imageNamed:@"rank_title.png"];
        titleLb.centerY = _btnBack.centerY;
        [self addSubview:titleLb];
        if ([UIDevice isRunningOniPhone5]) {
            titleLb.centerY+=10;
        }

        UILabel *lbOrder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        CGPoint p = titleLb.center;
        p.y += 40;
        p.x += 16;
        lbOrder.center = p;
        lbOrder.textAlignment = UITextAlignmentCenter;
        lbOrder.backgroundColor = [UIColor clearColor];
        lbOrder.font = [UIFont boldSystemFontOfSize:15];
        lbOrder.textColor = colorRGB(104, 69, 13);
        //lbOrder.text = @"当前排名： 1233456789";
        self.lbRankOrder = lbOrder;
        [self addSubview:lbOrder];
        
        if ([UIDevice isRunningOniPhone5]) {
            self.lbRankOrder.centerY += 10;
        }
        
        UIImageView *orderIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(70, _btnBack.top, 31, 31)] autorelease];
        orderIcon.image = [UIImage imageNamed:@"my_rank_icon.png"];
        orderIcon.centerY = lbOrder.centerY;
        [self addSubview:orderIcon];
        
        [titleLb release];
        [lbOrder release];
        

    }
    return self;
}

- (void)dealloc
{
    self.btnBack = nil;
    self.tableView = nil;
    self.dataArray = nil;
    self.lbRankOrder = nil;
    
    [super dealloc];
}

- (void)iniSubviews
{
    [self addBgView];
    self.btnBack = [self addBackButton];
}

- (void)refreshRankOrder
{
    //设置排名
    for (RankInfo *rankInfo in self.dataArray) {
        if (rankInfo.uid == [AppSingleton sharedInstance].uid.intValue) {
            NSString *strOrder = [NSString stringWithFormat:@"当前排名:   第%d名", rankInfo.order];
            self.lbRankOrder.text = strOrder;
        }
    }
}


#pragma mark  UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_section_1.png"]] autorelease];
    imageView.frame = CGRectMake(0, 0, 320, 14.5);
    
    return imageView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    /*if (section == 0) {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_section_2.png"]] autorelease];
        imageView.frame = CGRectMake(0, 0, 320, 14.5);
        
        return imageView;
    }
    else
    {
        return nil;
    }*/
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_section_2.png"]] autorelease];
    imageView.frame = CGRectMake(0, 0, 320, 14.5);
    
    return imageView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count > 3) {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        if (_dataArray.count >= 3) {
            return 3;
        }
        else
        {
            return _dataArray.count;
        }
    }
    else if(1 == section)
    {
        if (_dataArray.count > 3) {
            return _dataArray.count-3;
        }
        else
        {
            return 0;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    RankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[RankViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (0 == indexPath.section) {
        
        NSString *imageName = [NSString stringWithFormat:@"rank_%i", indexPath.row+1];
        
        [cell setData:[_dataArray objectAtIndex:indexPath.row] bgImage:[UIImage imageNamed:imageName]];
    }
    else if(1 == indexPath.section)
    {
        [cell setData:[_dataArray objectAtIndex:indexPath.row+3] bgImage:nil];
    }

    return cell;
}

@end
