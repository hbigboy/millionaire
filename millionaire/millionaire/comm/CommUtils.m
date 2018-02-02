//
//  CommUtils.m
//  millionaire
//
//  Created by book on 13-7-22.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "CommUtils.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import "NSData+AES.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommUtils


+ (BOOL)isEmptyOrZero:(id)value
{
    if (nil == value || [value isKindOfClass:[NSNull class]] || ([value isKindOfClass:[NSString class]] && [value length] ==0) || ([value isKindOfClass:[NSNumber class]] && [value intValue] == 0)) {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
/*
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
*/

+ (void)setLocalData:(id)value key:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    if (key) {
        [setting setObject:value forKey:key];
    }
    else
    {
        [setting removeObjectForKey:key];
    }
    [setting synchronize];
}

+ (id)getLocalData:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    
    id data = [setting objectForKey:key];
    if (data) {
        return data;
    }
    else
    {
        return nil;        
    }

}

+ (NetworkStatus)checkNetWork
{
    Reachability *reachAble = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    NetworkStatus status = NotReachable;
    switch ([reachAble currentReachabilityStatus])
    {
        case NotReachable:
            status = NotReachable;
            break;
        case ReachableViaWWAN:
            status = ReachableViaWWAN;
            break;
        case ReachableViaWiFi:
            status = ReachableViaWiFi;
        break;
            default:
            status = NotReachable;
    }
    return status;
}
//ios设备判断
+ (bool)checkDevice:(NSString *)name {
    NSString* deviceType = [UIDevice currentDevice].model;
    MLog(@"deviceType = %@", deviceType);
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}

//按钮闪烁效果
+ (void)twinklAnimation:(UIView *)view block:(void(^)(void))block
{
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL f1){
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0.3;
        } completion:^(BOOL f2){
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 1.0;
            } completion:^(BOOL f3){
                block();
            }];
        }];
    }];

}


+(NSString*)urlEncoded:(NSString*)str {
    
    NSString *escapedUrlString = [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    return escapedUrlString;
    
}

+(NSString*)urlDecoded:(NSString*)str {
    
    NSString *cleanUrlString =  [str stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    return cleanUrlString;
    
}

//Unicode转UTF-8

+ (NSString*) replaceUnicode:(NSString*)aUnicodeString

{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                           
                                                          mutabilityOption:NSPropertyListImmutable
                           
                                                                    format:NULL
                           
                                                          errorDescription:NULL];
    
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

+(NSString *) utf8ToUnicode:(NSString *)string

{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >='0')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
        }
        
        else if(_char >='a' && _char <= 'z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
            
            
        }
        
        else if(_char >='A' && _char <= 'Z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
            
            
        }
        
        else
            
        {
            
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            
        }
        
    }
    
    return s;
    
}

+ (NSString *)getKeyFromType:(UpdateUserType)type
{
    NSString *key = nil;
    switch (type) {
        case UpdateUserTypePassCount:
            key = UserPassCountKey;
            break;
        case UpdateUserTypeGoldCount:
            key = UserGoldCountKey;
            break;
        case UpdateUserTypeExpCount:
            key = UserExpCountKey;
            break;
        case UpdateUserTypeMoneyCount:
            key = UserMoneyCountKey;
            break;
        case UpdateUserTypeGradeCount:
            key = UserGradeCountKey;
            break;
        case UpdateUserOwnBanks:
            key = UserOwnBanksKey;
            break;
        default:
            break;
    }
    
    return key;
}


+ (NSString *)uzip:(NSData*)data
{
    NSError *err = nil;
    NSData *uncompressedData = [ASIDataDecompressor uncompressData:data error:&err];
    NSString* result = [[[NSString alloc] initWithData:uncompressedData encoding:NSUTF8StringEncoding] autorelease];
    
    return result;
}

+ (NSData *)encrypt:(NSString *)aString
{
    
    NSData *aData = [aString dataUsingEncoding: NSUTF8StringEncoding];
    NSData *newData = [aData AES256EncryptWithKey:EncryptKey];

    return newData;

}

+ (NSString *)decrypt:(NSData *)aData
{
    NSData *newData = [aData AES256DecryptWithKey:EncryptKey];
    
    NSString *newString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    return newString;
}

//+ (NSData *)uncompressZippedData:(NSData *)compressedData
//{
//    
//    if ([compressedData length] == 0) return compressedData;
//    
//    unsigned full_length = [compressedData length];
//    
//    unsigned half_length = [compressedData length] / 2;
//    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
//    BOOL done = NO;
//    int status;
//    z_stream strm;
//    strm.next_in = (Bytef *)[compressedData bytes];
//    strm.avail_in = [compressedData length];
//    strm.total_out = 0;
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
//    while (!done) {
//        // Make sure we have enough room and reset the lengths.
//        if (strm.total_out >= [decompressed length]) {
//            [decompressed increaseLengthBy: half_length];
//        }
//        strm.next_out = [decompressed mutableBytes] + strm.total_out;
//        strm.avail_out = [decompressed length] - strm.total_out;
//        // Inflate another chunk.
//        status = inflate (&strm, Z_SYNC_FLUSH);
//        if (status == Z_STREAM_END) {
//            done = YES;
//        } else if (status != Z_OK) {
//            break;
//        }
//        
//    }
//    if (inflateEnd (&strm) != Z_OK) return nil;
//    // Set real length.
//    if (done) {
//        [decompressed setLength: strm.total_out];
//        return [NSData dataWithData: decompressed];
//    } else {
//        return nil;
//    }  
//}


+(NSData*) compressData: (NSData*)uncompressedData  {
    
    /*
     
     Special thanks to Robbie Hanson of Deusty Designs for sharing sample code
     
     showing how deflateInit2() can be used to make zlib generate a compressed
     
     file with gzip headers:
     
     http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html
     
     */
    
    
    
    if (!uncompressedData || [uncompressedData length] == 0)  {
        
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        
        return nil;
        
    }
    
    
    
    /* Before we can begin compressing (aka "deflating") data using the zlib
     
     functions, we must initialize zlib. Normally this is done by calling the
     
     deflateInit() function; in this case, however, we'll use deflateInit2() so
     
     that the compressed data will have gzip headers. This will make it easy to
     
     decompress the data later using a tool like gunzip, WinZip, etc.
     
     
     
     deflateInit2() accepts many parameters, the first of which is a C struct of
     
     type "z_stream" defined in zlib.h. The properties of this struct are used to
     
     control how the compression algorithms work. z_stream is also used to
     
     maintain pointers to the "input" and "output" byte buffers (next_in/out) as
     
     well as information about how many bytes have been processed, how many are
     
     left to process, etc. */
    
    z_stream zlibStreamStruct;
    
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    
    zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input bytes
    
    zlibStreamStruct.avail_in  = [uncompressedData length]; // Number of input bytes left to process
    
    
    
    /* Initialize the zlib deflation (i.e. compression) internals with deflateInit2().
     
     The parameters are as follows:
     
     
     
     z_streamp strm - Pointer to a zstream struct
     
     int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between
     
     0 and 9: 1 gives best speed, 9 gives best compression, 0 gives
     
     no compression.
     
     int method     - Compression method. Only method supported is "Z_DEFLATED".
     
     int windowBits - Base two logarithm of the maximum window size (the size of
     
     the history buffer). It should be in the range 8..15. Add
     
     16 to windowBits to write a simple gzip header and trailer
     
     around the compressed data instead of a zlib wrapper. The
     
     gzip header will have no file name, no extra data, no comment,
     
     no modification time (set to zero), no header crc, and the
     
     operating system will be set to 255 (unknown).
     
     int memLevel   - Amount of memory allocated for internal compression state.
     
     1 uses minimum memory but is slow and reduces compression
     
     ratio; 9 uses maximum memory for optimal speed. Default value
     
     is 8.
     
     int strategy   - Used to tune the compression algorithm. Use the value
     
     Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data
     
     produced by a filter (or predictor), or Z_HUFFMAN_ONLY to
     
     force Huffman encoding only (no string match) */
    
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    
    if (initError != Z_OK)
        
    {
        
        NSString *errorMsg = nil;
        
        switch (initError)
        
        {
                
            case Z_STREAM_ERROR:
                
                errorMsg = @"Invalid parameter passed in to function.";
                
                break;
                
            case Z_MEM_ERROR:
                
                errorMsg = @"Insufficient memory.";
                
                break;
                
            case Z_VERSION_ERROR:
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                
                break;
                
            default:
                
                errorMsg = @"Unknown error code.";
                
                break;
                
        }
        
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        [errorMsg release];
        
        return nil;
        
    }
    
    
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    
    NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + 12];
    
    
    
    int deflateStatus;
    
    do
        
    {
        
        // Store location where next byte should be put in next_out
        
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        
        
        // Calculate the amount of remaining free space in the output buffer
        
        // by subtracting the number of bytes that have been written so far
        
        // from the buffer's total capacity
        
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        
        
        
        /* deflate() compresses as much data as possible, and stops/returns when
         
         the input buffer becomes empty or the output buffer becomes full. If
         
         deflate() returns Z_OK, it means that there are more bytes left to
         
         compress in the input buffer but the output buffer is full; the output
         
         buffer should be expanded and deflate should be called again (i.e., the
         
         loop should continue to rune). If deflate() returns Z_STREAM_END, the
         
         end of the input stream was reached (i.e.g, all of the data has been
         
         compressed) and the loop should stop. */
        
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
        
        
    } while ( deflateStatus == Z_OK );
    
    
    
    // Check for zlib error and convert code to usable error message if appropriate
    
    if (deflateStatus != Z_STREAM_END)
        
    {
        
        NSString *errorMsg = nil;
        
        switch (deflateStatus)
        
        {
                
            case Z_ERRNO:
                
                errorMsg = @"Error occured while reading file.";
                
                break;
                
            case Z_STREAM_ERROR:
                
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                
                break;
                
            case Z_DATA_ERROR:
                
                errorMsg = @"The deflate data was invalid or incomplete.";
                
                break;
                
            case Z_MEM_ERROR:
                
                errorMsg = @"Memory could not be allocated for processing.";
                
                break;
                
            case Z_BUF_ERROR:
                
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                
                break;
                
            case Z_VERSION_ERROR:
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                
                break;
                
            default:
                
                errorMsg = @"Unknown error code.";
                
                break;
                
        }
        
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        [errorMsg release];
        
        
        
        // Free data structures that were dynamically created for the stream.
        
        deflateEnd(&zlibStreamStruct);
        
        
        
        return nil;
        
    }
    
    
    
    // Free data structures that were dynamically created for the stream.
    
    deflateEnd(&zlibStreamStruct);
    
    
    
    [compressedData setLength: zlibStreamStruct.total_out];
    
    
    
    return compressedData;
    
}


+ (NSData *)decompressData:(NSData *)compressedData {
    
    z_stream zStream;
    
    zStream.zalloc = Z_NULL;
    
    zStream.zfree = Z_NULL;
    
    zStream.opaque = Z_NULL;
    
    zStream.avail_in = 0;
    
    zStream.next_in = 0;
    
    int status = inflateInit2(&zStream, (15+32));
    
    
    
    if (status != Z_OK) {
        
        return nil;
        
    }
    
    
    
    Bytef *bytes = (Bytef *)[compressedData bytes];
    
    NSUInteger length = [compressedData length];
    
    
    
    NSUInteger halfLength = length/2;
    
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    
    
    
    zStream.next_in = bytes;
    
    zStream.avail_in = (unsigned int)length;
    
    zStream.avail_out = 0;
    
    
    
    NSInteger bytesProcessedAlready = zStream.total_out;
    
    while (zStream.avail_in != 0) {
        
        
        
        if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length]) {
            
            [uncompressedData increaseLengthBy:halfLength];
            
        }
        
        
        
        zStream.next_out = (Bytef*)[uncompressedData mutableBytes] + zStream.total_out-bytesProcessedAlready;
        
        zStream.avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out-bytesProcessedAlready));
        
        
        
        status = inflate(&zStream, Z_NO_FLUSH);
        
        
        
        if (status == Z_STREAM_END) {
            
            break;
            
        } else if (status != Z_OK) {
            
            return nil;
            
        }
        
    }
    
    
    
    status = inflateEnd(&zStream);
    
    if (status != Z_OK) {
        
        return nil;
        
    }
    
    
    
    [uncompressedData setLength: zStream.total_out-bytesProcessedAlready];  // Set real length
    
    
    return uncompressedData;    
    
}


+ (void)showConfirmAlertView:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id)target
{
    UIAlertView * alrt =  [[UIAlertView alloc] initWithTitle:title message:message delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alrt.tag = tag;
    [alrt show];
    [alrt release];
}

+ (int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

+ (NSArray *)getLevels
{
    /*NSArray * levels = [NSArray arrayWithObjects:
                        @"10", @"20", @"30",
                        @"40", @"80", @"100",
                        @"200", @"300", @"400",
                        @"600", @"800", @"1500",
                        @"2500", @"5000", @"10000", nil];*/
    NSArray * levels = [NSArray arrayWithObjects:
                        @"10", @"20", @"30",
                        @"40", @"60", @"80",
                        @"120", @"200", @"250",
                        @"300", @"350", @"400",
                        @"450", @"500", @"600", nil];
    
    return levels;
}

+ (NSString *)getLevels:(int)level
{
    NSArray *levels = [CommUtils getLevels];
    if (level > levels.count) {
        return nil;
    }

    return [NSString stringWithFormat:@"第%d关 %@个金币", level,[[CommUtils getLevels] objectAtIndex:level-1]];
    
}

+ (NSString *)getLocalVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

    return version;
}

+ (void)updateApp:(NSString *)appUrl
{
    //if (appUrl && [appUrl hasPrefix:@"itms-apps://"]) {
    if (appUrl) {    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
    }
}

+ (BOOL)needUpdateCache:(NSString *)key timeInterval:(float)timeInterval
{
    NSString *value = [CommUtils getLocalData:key];
    if (value) {
        float interval = [[NSDate date] timeIntervalSince1970] - [value intValue];
        if (interval < timeInterval) {
            return NO;
        }
    }
    return YES;
}

+ (void)setCacheTime:(NSString *)key
{
    [CommUtils setLocalData:[NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]] key:key];
}

+ (RootViewController *)getRootViewController
{
    AppDelegate  *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    RootViewController *rv = delegate.rootViewController;
    
    return rv;
}

+ (AppDelegate  *)getApp
{
    AppDelegate  *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}

//获取当前屏幕内容
+ (UIImage *)getNormalImage:(UIView *)view{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect
{
    //要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配  rect
    CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    //用完一定要释放，否则内存泄露
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (void) sendImageContent:(NSDictionary *)dict scene:(int)scene
{
    
    UIImage *image = [dict objectForKey:@"image"];
    
    //[CommUtils scaleToSize:image size:CGSizeMake(image.size.width, image.size.height-20)];
    

    WXMediaMessage *message = [WXMediaMessage message];
    
    UIImage *tImage = [CommUtils scaleToSize:image size:CGSizeMake(160, image.size.height/image.size.width * 160)];
    [message setThumbImage:tImage];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0);
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;  //选择发送到朋友圈，默认值为WXSceneSession，发送到会话
    [WXApi sendReq:req];
}

+ (BOOL)isUpdate:(NSString *)version
{
    NSString *l_version = [CommUtils getLocalVersion];
    NSArray *l_arr = [l_version componentsSeparatedByString:@"."];
    
    NSArray *s_arr = [version componentsSeparatedByString:@"."];
    
    if (l_arr.count == 3 && s_arr.count == 3) {
        if ([[s_arr objectAtIndex:0] intValue] > [[l_arr objectAtIndex:0] intValue]) {
            return YES;
        }
        if ([[s_arr objectAtIndex:1] intValue] > [[l_arr objectAtIndex:1] intValue]) {
            return YES;
        }
        if ([[s_arr objectAtIndex:2] intValue] > [[l_arr objectAtIndex:2] intValue]) {
            return YES;
        }
    }

    if (l_arr.count == 2 && s_arr.count >= 2) {
        if ([[s_arr objectAtIndex:0] intValue] > [[l_arr objectAtIndex:0] intValue]) {
            return YES;
        }
        if ([[s_arr objectAtIndex:1] intValue] > [[l_arr objectAtIndex:1] intValue]) {
            return YES;
        }
    }

    if (l_arr.count == 1 && s_arr.count >= 1) {
        if ([[s_arr objectAtIndex:0] intValue] > [[l_arr objectAtIndex:0] intValue]) {
            return YES;
        }
    }

    return NO;

}

+ (AdsView *)getAdsView
{
    return [[CommUtils getApp] adsView];
}
@end
