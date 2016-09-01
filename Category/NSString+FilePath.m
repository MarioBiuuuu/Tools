//
//  NSString+FilePath.m
//  Dangdang
//
//  Created by 杨浩 on 16/3/17.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

+ (NSString *)getHomeDir {
    return NSHomeDirectory();
}

+ (NSString *)getDocumentsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getCachesDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getTmpDir {
    return NSTemporaryDirectory();
}

@end
