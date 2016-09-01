//
//  LKDateCompare.m
//  Dangdang
//
//  Created by Yuri on 16/4/21.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "LKDateCompare.h"

@implementation DateCompare
+ (NSString *)compareCurrentTime:(NSString *)compareDate {
    if (compareDate.length == 0 || [compareDate isEqualToString:@""] || [compareDate isEqualToString:@"0"]) {
        return @"";
    }
    double unixTimeStamp = compareDate.length >= 13? [[compareDate substringToIndex:compareDate.length -3 ]  doubleValue]: [compareDate doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *_date=[_formatter stringFromDate:date];
    NSDate * newdate = [_formatter dateFromString:_date];
    //    ////NSLog(@"输入的时间%@",_date);
    NSTimeInterval  timeInterval = [newdate timeIntervalSinceNow];  //当前时间与获取时间的值
    
    timeInterval = -timeInterval;
    long temp = 0;
    
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if((temp = temp/60) <=24 ){
        result =[self isToday:date]?[NSString stringWithFormat:@"%ld小时前",temp]:[self compareDate:newdate];
    } else if((temp = temp/24 ) <30){
        result = [self compareDate:newdate];
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+ (NSString *)compareDate:(NSString *)dateStr {
    double unixTimeStamp = compareDate.length >= 13? [[compareDate substringToIndex:compareDate.length -3 ]  doubleValue]: [compareDate doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *destDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate * localeDate = [date1  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
    [_formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *today =localeDate;
    
    NSDate *tomorrow, *yesterday,*qiantianDaty;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    qiantianDaty = [today dateByAddingTimeInterval:-2*secondsPerDay];
    
    
    
    NSString * todayString = [[_formatter1 stringFromDate:today] substringToIndex:10];

    NSString * dateString = [[_formatter1 stringFromDate:destDate] substringToIndex:10];//接收得时间
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"HH:mm"];
    
    if ([dateString isEqualToString:todayString]) {
        [_formatter setDateFormat:@"HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    } else if ([[dateString substringToIndex:4] isEqualToString:[todayString substringToIndex:4]]) {
        [_formatter setDateFormat:@"MM/dd HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    } else {
        [_formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    }
    
}

+ (BOOL)isToday:(NSDate *)date {
    
    NSRange range;
    range.length = 10;
    range.location = 0;
    NSString *timeStr = [BTCommonTool getCurrentDateString];
    NSTimeInterval _interval=[timeStr.length >= 13 ? [timeStr substringToIndex:10]:timeStr doubleValue];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:timeZone];
    NSString *dateNewString = [formatter stringFromDate:nowDate];
    NSString *dateOldString = [formatter stringFromDate:date];
    if ([[dateNewString substringWithRange:range] isEqualToString:[dateOldString substringWithRange:range]]) {
        return YES;
    }
    return NO;
    
}

+ (BOOL)isThisYear {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}
+ (BOOL)isYesterday {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    NSDate *selfDate = [formatter dateFromString:[formatter stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:selfDate toDate:nowDate options:kNilOptions];
    
    return  components.year == 0 && components.month == 0 && components.day == 1;
}

@end
