//
//  LKDateCompare.h
//  Dangdang
//
//  Created by Yuri on 16/4/21.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKDateCompare : NSObject

/**
 *  与当前时间比较格式化返回，例如：刚刚，5分钟前等
 *
 *  @param compareDate 待比对的时间字符串
 *
 *  @return 比对结果
 */
+ (NSString *)compareCurrentTime:(NSString *)compareDate;

/**
 *  与当前时间比较格式化返回，例如：08：56，2016/08/30 08：56等
 *
 *  @param dateStr 待比对的时间字符串
 *
 *  @return 比对结果
 */
+ (NSString *)compareDate:(NSString *)dateStr;

/**
 *  判断是不是今天
 *
 *  @param date 带比对时间
 *
 *  @return BOOL值 0/1
 */
+ (BOOL)isToday:(NSDate *)date;

/**
 *  判断是不是今年
 *
 *  @param date 带比对时间
 *
 *  @return BOOL值 0/1
 */
+ (BOOL)isThisYear

/**
 *  判断是不是昨天
 *
 *  @param date 带比对时间
 *
 *  @return BOOL值 0/1
 */
+ (BOOL)isYesterday

@end
