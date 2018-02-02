//
//  RankViewCell.m
//  millionaire
//
//  Created by book on 13-8-11.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "RankViewCell.h"
#import "RankInfo.h"
#import "AppSingleton.h"
@interface RankViewCell()
{
    UILabel *_orderLb;
    UILabel *_scoreLb;
    UILabel *_meLb;
    
    UIImageView *_seperator1;
    UIImageView *_seperator2;
    UIImageView *_seperator3;
    
    UIImageView *_bgView;
    UIImageView *_meView;
}
@end

@implementation RankViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _meView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 1, 300, 38)] autorelease];
        _meView.image = [UIImage imageNamed:@"rank_currentOrder.png"];
        
        _seperator1 = [[[UIImageView alloc] initWithFrame:CGRectMake(78, 1.5, 2, 37)] autorelease];
        _seperator1.image = [UIImage imageNamed:@"seperator_icon.png"];
        
        _orderLb = [[[UILabel alloc] initWithFrame:CGRectMake(0, (40-30)/2, 78, 30)] autorelease];
        _orderLb.textAlignment = UITextAlignmentCenter;
        _orderLb.backgroundColor = [UIColor clearColor];
        _orderLb.textColor = colorRGB(252, 194, 0);
        _orderLb.font = [UIFont systemFontOfSize:20];
        
        _scoreLb = [[[UILabel alloc] initWithFrame:CGRectMake(_orderLb.right, _orderLb.top, 200, 30)] autorelease];
        _scoreLb.backgroundColor = [UIColor clearColor];
        _scoreLb.textColor = colorRGB(252, 194, 0);
        _scoreLb.font = [UIFont systemFontOfSize:20];
        _scoreLb.textAlignment = UITextAlignmentCenter;

        
        /*_meLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, 30)] autorelease];
        _meLb.textAlignment = UITextAlignmentLeft;
        _meLb.backgroundColor = [UIColor clearColor];
        _meLb.left = _orderLb.left;
        _meLb.height = 40;
        _meLb.font = [UIFont boldSystemFontOfSize:20];
        
        _meLb.textAlignment = UITextAlignmentLeft;
        _meLb.textColor = [UIColor blueColor];
        _meLb.text = @"  >>"; 
        [self.contentView addSubview:_meLb];
        _meLb.hidden = YES;
         
        */
        [self.contentView addSubview:_orderLb];
        [self.contentView addSubview:_scoreLb];
        
        [self addSubview:_seperator1];
        [self addSubview:_meView];

        
        _bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
        self.backgroundView = _bgView;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setData:(RankInfo *)rankInfo bgImage:(UIImage *)bgImage
{
    if (bgImage) {
        _orderLb.hidden = YES;
        _bgView.image = bgImage;
    }
    else
    {
        _orderLb.hidden = NO;
        _bgView.image = [UIImage imageNamed:@"rank_bg.png"];
    }
    _orderLb.text = [NSString stringWithFormat:@"%d", rankInfo.order];
    _scoreLb.text = IntergerToString(rankInfo.gold);
    
    if (rankInfo.uid == [AppSingleton sharedInstance].uid.intValue) {
        _orderLb.textColor = colorRGB(245, 213, 192);
        _scoreLb.textColor = colorRGB(245, 213, 192);
        _meView.hidden = NO;
    }
    else
    {
        _meView.hidden = YES;
        _orderLb.textColor = colorRGB(252, 194, 0);
        _scoreLb.textColor = colorRGB(252, 194, 0);
    }
}
@end
