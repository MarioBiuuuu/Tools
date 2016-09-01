//
//  NSString+FilePath.h
//  Dangdang
//
//  Created by 杨浩 on 16/3/17.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)
//获取主目录
+ (NSString *)getHomeDir;
//获取Documents目录
+ (NSString *)getDocumentsDir;
//获取Caches目录
+ (NSString *)getCachesDir;
//获取tmp目录
+ (NSString *)getTmpDir;

@end
