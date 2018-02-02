//
//  NtAdBannelView.h
//  millionaire
//
//  Created by HuangZizhu on 2/13/15.
//  Copyright (c) 2015 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"

@interface GADBannerView (preload)
+ (GADBannerView *)sharedInstance;
- (void)loadAd;
@end

