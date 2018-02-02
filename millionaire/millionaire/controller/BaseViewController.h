//
//  BaseViewController.h
//  millionaire
//
//  Created by 爱奇艺 on 13-7-16.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//
//   所有viewcontroller的父类

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


- (void)addBackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
