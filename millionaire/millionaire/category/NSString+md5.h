//
//  NSString+md5.h
//  millionaire
//
//  Created by book on 13-7-27.
//  Copyright (c) 2013年 爱奇艺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5)
-(NSString *) md5HexDigest;
- (NSString *)shortUrl:(NSString *)url;
@end
