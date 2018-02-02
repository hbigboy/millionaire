//
//  ScoreView.h
//  millionaire
//
//  Created by book on 13-7-30.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "BaseView.h"

@interface ScoreView : BaseView
//- (void)setScore:(int)score;
- (void)setTimerViewScore:(int)score timeFireBlock:(void(^)(void))timeFireBlock timeoutBlock:(void(^)(void))timeoutBlock;
- (NSInteger)getScore;

- (void)startTimer;
- (void)stopTimer;
@end
