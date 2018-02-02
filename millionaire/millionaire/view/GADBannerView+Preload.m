//
//  NtAdBannelView.m
//  millionaire
//
//  Created by HuangZizhu on 2/13/15.
//  Copyright (c) 2015 爱奇艺. All rights reserved.
//

#import "GADBannerView.h"

static GADBannerView *_bannerView = nil;

@implementation GADBannerView (preload)
+ (GADBannerView *)sharedInstance {
    
    GADBannerView *adView = nil;
    
    if (!_bannerView) {
        adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _bannerView = adView;
    }
    
    return _bannerView;
}
- (void)loadAd {
    
    _bannerView.adUnitID = @"ca-app-pub-3842315164413649/4955727815";
    GADRequest *req = [GADRequest request];
    [req setLocationWithLatitude:40.0 longitude:117.0 accuracy:100]; //北京的经纬度
    [_bannerView loadRequest:req];

}
@end
