//
//  NSString+md5.m
//  millionaire
//
//  Created by book on 13-7-27.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (md5)
- (NSString *) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    MLog(@"lowercaseString = %@",[hash lowercaseString]);
    return [hash lowercaseString];
}

- (NSString *)shortUrl:(NSString *)url
{
    NSArray *chars = [[NSArray alloc] initWithObjects:@"a" , @"b" , @"c" , @"d" , @"e" , @"f" , @"g" , @"h" , @"i" , @"j" , @"k" , @"l" , @"m" , @"n" , @"o" , @"p" , @"q" , @"r" , @"s" , @"t" , @"u" , @"v" , @"w" , @"x" , @"y" , @"z" , @"0" , @"1" , @"2" , @"3" , @"4" , @"5" , @"6" , @"7" , @"8" , @"9" , @"A" , @"B" , @"C" , @"D" , @"E" , @"F" , @"G" , @"H" , @"I" , @"J" , @"K" , @"L" , @"M" , @"N" , @"O" , @"P" , @"Q" , @"R" , @"S" , @"T" ,@"U" , @"V" , @"W" , @"X" , @"Y" , @"Z", nil];
    MLog(@"chars = %d", [chars count]);
    NSString *key = @"xxxxxx";
    NSString *hex = [NSString stringWithFormat:@"%@",[[key stringByAppendingFormat:@"%@",url] md5HexDigest]];
    
    MLog(@"hex = %@", hex);
    NSMutableArray *resUrl = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i<4; i++) {
        // 把加密字符按照 8 位一组 16 进制与 0x3FFFFFFF 进行位与运算
        NSString *sTempSubString = [hex substringWithRange:NSMakeRange(i*8, 8)];
        
        // 这里需要使用 long 型来转换，因为 Inteper只能处理 31 位 , 首位为符号位 , 如果不用 long ，则会越界
        long longOfTemp;
        sscanf([sTempSubString cStringUsingEncoding:NSASCIIStringEncoding], "%lx", &longOfTemp);
        long lHexLong = 0x3FFFFFFF & longOfTemp;
        NSString *outChars = @"";
        for (int j=0; j<6; j++) {
            // 把得到的值与 0x0000003D 进行位与运算，取得字符数组 chars 索引
            long index = 0x0000003D & lHexLong;
            // 把取得的字符相加
            outChars = [outChars stringByAppendingFormat:@"%@",[chars objectAtIndex:(int)index]];
            // 每次循环按位右移 5 位
            lHexLong = lHexLong >> 5;
        }
        // 把字符串存入对应索引的输出数组
        [resUrl insertObject:outChars atIndex:i];
    }
    return [resUrl objectAtIndex:0];//这里可以返回任意一个元素作为短链接（0，1，2，3）
}


@end
