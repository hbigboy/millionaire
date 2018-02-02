//
//  WaitingView.m
//  millionaire
//
//  Created by book on 13-7-21.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "WaitingView.h"

@implementation WaitingView

- (void)dealloc
{
    [_goLabel release];
    [_waitingLabel release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rc = self.bounds;
        rc.size.height = 217;
        _waitingLabel = [[UIImageView alloc] initWithFrame:rc];
        _waitingLabel.contentMode = UIViewContentModeScaleAspectFit;        
        _waitingLabel.image = [UIImage imageNamed:@"question_wating.png"];
        [self addSubview:_waitingLabel];

        _goLabel = [[UIImageView alloc] initWithFrame:rc];
        _goLabel.contentMode = UIViewContentModeScaleAspectFit;                
        _goLabel.image = [UIImage imageNamed:@"question_go.png"];                
        
        [self addSubview:_goLabel];
        [self resetReadyGoLabel];
    }
    return self;
}


- (void)resetReadyGoLabel
{
    _goLabel.alpha = 0;;
    _goLabel.frame = CGRectMake(-60, -60, self.width+120, self.height+120);
    _waitingLabel.alpha = 1.0;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)readyGo:(void(^)(void))block
{
    //
    [UIView animateWithDuration:0.1 animations:^{
        _waitingLabel.alpha = 0;

    } completion:^(BOOL f){
        CGRect rc = CGRectMake((self.width-100)/2, (self.height-100)/2, 100, 100);
        
        [UIView animateWithDuration:0.1 animations:^{
            _goLabel.alpha = 1.0;
            
        } completion:^(BOOL f2){
            //
            [UIView animateWithDuration:.8 animations:^{
                _goLabel.frame = rc;
            } completion:^(BOOL f3){
                _goLabel.alpha = 0;
                block();
            }];
        }];

    }];
    
}

@end
