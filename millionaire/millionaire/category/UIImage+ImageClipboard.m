//
//  UIImage+ImageClipboard.m
//  Yichu
//
//  Created by wang animeng on 12-9-11.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import "UIImage+ImageClipboard.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+GeometryAddition.h"

@implementation UIImage (ImageClipboard)

- (UIImage *)drawInSize:(CGSize)size {
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2);
    else{
        UIGraphicsBeginImageContext(rect.size);
    }
    
	[self drawInRect:rect];
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

- (UIImage *)cropToSquare{
    if (self.size.width != self.size.height) {
        CGRect destRect;
        
        //center
        if (self.size.height > self.size.width) {
            destRect = CGRectMake(0, (self.size.height-self.size.width)/2.0, self.size.width, self.size.width);
        }
        else  {
            destRect = CGRectMake((self.size.width-self.size.height)/2.0, 0,self.size.height, self.size.height);
        }
        
        CGImageRef newImageRef = CGImageCreateWithImageInRect([self CGImage],destRect);
        UIImage *_newIamge =  [UIImage imageWithCGImage:newImageRef];
        CGImageRelease(newImageRef);
        
        return _newIamge;
    }
    else{
        return self;
    }
}


- (UIImage *)rescaleImageInSize:(CGSize)size
{
	CGSize originSize = self.size;
	CGSize destSize = size;
	if (originSize.height>originSize.width*(size.height/size.width)) //height benchmark
	{
		destSize.width = size.height*(originSize.width/originSize.height);
	}
	else {
		destSize.height = size.width*(originSize.height/originSize.width);
	}
    
	return [self drawInSize:destSize];
    
}

- (UIImage *)cropImageInSize:(CGSize)size
{
	CGSize originSize = self.size;
	CGSize destSize = size;
	if (originSize.height>originSize.width*(size.height/size.width)) //height benchmark
	{
		destSize.height = size.width*(originSize.height/originSize.width);
        
		destSize.width = size.width;
	}
	else {
		destSize.height = destSize.height;
		
		destSize.width = size.height*(originSize.width/originSize.height);
	}
	UIImage * secondImage = [self rescaleImageInSize:destSize];
	
    //crop to center
	CGImageRef imgref = CGImageCreateWithImageInRect([secondImage CGImage],
                                                     CGRectMake((destSize.width-size.width)/2.0, (destSize.height-size.height)/2.0, size.width,size.height ));
    
    UIImage *_newImage = [UIImage imageWithCGImage:imgref];
    CGImageRelease(imgref);
    
	return _newImage;
    
}


- (UIImage *)cropImageToRect:(CGRect)cropRect {
    
    //开始创建自己的一个绘图上下文。根据屏幕的分辨率大小选择不同的图形上下文开创函数。
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(cropRect.size, NO, 2);
    else{
        UIGraphicsBeginImageContext(cropRect.size);
    }
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox {

	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize {
	UIImage *scaledImage = [self drawInSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}

- (UIImage *)replicateImageWithYaxis
{
    CGSize size = self.size;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, -1.0, 1.0);
    transform = CGAffineTransformTranslate(transform, -size.width, 0);
    CGContextConcatCTM(context, transform);
    [self drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

- (UIImage *)replicateImageWithXaxis
{
    CGSize size = self.size;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    transform = CGAffineTransformTranslate(transform, 0, -size.height);
    CGContextConcatCTM(context, transform);
    [self drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}



+ (UIImage *)copyPixels:(UIImage *)targetImage sourceImage:(UIImage *)sourceImage sourceRect:(CGRect)sourceRect destPoint:(CGPoint)destPoint
{
	CGImageRef tempImage = CGImageCreateWithImageInRect(sourceImage.CGImage, sourceRect);
	int tw = targetImage.size.width;
	int th = targetImage.size.height;
	int tempw = CGImageGetWidth(tempImage);
    int temph = CGImageGetHeight(tempImage);
	
	UIGraphicsBeginImageContext(CGSizeMake(tw, th));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(ctx, 0, th);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGContextDrawImage(ctx, CGRectMake(0, 0, tw, th), targetImage.CGImage);
	CGContextClipToRect(ctx, CGRectMake(destPoint.x, th - temph -destPoint.y, tempw, temph));
	CGContextDrawImage(ctx, CGRectMake(destPoint.x, th - temph -destPoint.y, tempw, temph), tempImage);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    //tempImage = NULL;
    CGImageRelease(tempImage); //fix mem bug by lxb;
    return newImage;
}

+(UIImage *)getImageFromView:(UIView *)orgView{
    
    //开始创建自己的一个绘图上下文。根据屏幕的分辨率大小选择不同的图形上下文开创函数。
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 2);
    else{
        UIGraphicsBeginImageContext(orgView.bounds.size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, orgView.width/2, orgView.height/2);
    CGContextConcatCTM(context, [orgView transform]);
    CGContextTranslateCTM(context,
                          -[orgView bounds].size.width * [[orgView layer] anchorPoint].x,
                          -[orgView bounds].size.height * [[orgView layer] anchorPoint].y);
    
    [[orgView layer] renderInContext:context];
    CGContextRestoreGState(context);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
    
}

+(UIImage*)fullScreenshot
{
    //开始创建自己的一个绘图上下文。根据屏幕的分辨率大小选择不同的图形上下文开创函数。
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 2);
    else{
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            //-renderIncontext方法的坐标系和graphics context的坐标系不一样，要进行转换
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)shadowGradientImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    static const CGFloat colors[] = {
        0.0f, 0.0f, 0.0f, 0.4f,
        0.0f, 0.0f, 0.0f, 0.0f
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGFloat horizontalCenter = size.width/2;
    CGPoint startPoint = CGPointMake(horizontalCenter, 0);
    CGPoint endPoint = CGPointMake(horizontalCenter,size.height);
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient), gradient = NULL;
    UIImage *rendition = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rendition;
}




@end
