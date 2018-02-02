//
//  UIImage+ImageClipboard.h
//  zxl
//
//  Created by zxl on 12-9-11.
//  Copyright (c) 2012年 zxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageClipboard)

- (UIImage *)drawInSize:(CGSize)size;

- (UIImage *)cropToSquare;
- (UIImage *)rescaleImageInSize:(CGSize)size;
- (UIImage *)cropImageInSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

//获得以Y轴为对称轴的映射图片
- (UIImage *)replicateImageWithYaxis;
- (UIImage *)replicateImageWithXaxis;

+ (UIImage *)copyPixels:(UIImage *)targetImage sourceImage:(UIImage *)sourceImage sourceRect:(CGRect)sourceRect destPoint:(CGPoint)destPoint;
+(UIImage *)getImageFromView:(UIView *)orgView;
+(UIImage*)fullScreenshot;
+ (UIImage *)shadowGradientImage:(CGSize)size;
@end
