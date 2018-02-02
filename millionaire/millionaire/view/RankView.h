//
//  RankView.h
//  millionaire
//
//  Created by zizhu on 13-8-7.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface RankView : BaseView
@property (nonatomic, retain) UIButton      *btnBack;
@property (nonatomic, retain) UITableView   *tableView;
@property (nonatomic, retain) NSArray       *dataArray;
@property (nonatomic, retain) UILabel       *lbRankOrder;


- (void)refreshRankOrder;
@end
