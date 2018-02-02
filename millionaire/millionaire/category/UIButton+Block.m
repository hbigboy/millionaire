//
//  UIButton+Block.m
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "UIButton+Block.h"
static char overviewKey;

@implementation UIButton (Block)
@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(self);
    }
}
@end
