//
//  CheckPointsCell.m
//  millionaire
//
//  Created by book on 13-8-1.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "CheckPointsCell.h"

@implementation CheckPointsCell

- (void)dealloc
{
    self.titleLb = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 183-20, 27)];
        _titleLb.backgroundColor = [UIColor clearColor];
        _titleLb.textAlignment = UITextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:_titleLb];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
