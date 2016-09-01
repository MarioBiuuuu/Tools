//
//  NSString+SizeToFit.m
//  constellation
//
//  Created by Yuri on 15/7/21.
//  Copyright (c) 2015年 XiaofeiZhang. All rights reserved.
//

#import "NSString+SizeToFit.h"

@implementation NSString (SizeToFit)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    //返回字符串所占用的尺寸.
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}
@end
