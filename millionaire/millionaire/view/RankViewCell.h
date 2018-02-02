//
//  RankViewCell.h
//  millionaire
//
//  Created by book on 13-8-11.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RankInfo;
@interface RankViewCell : UITableViewCell
- (void)setData:(RankInfo *)rankInfo bgImage:(UIImage *)bgImage;
@end
