//
//  showMessage.h
//  renrenxing
//
//  Created by chenjianhui on 15/7/29.
//  Copyright (c) 2015年 ControlStrength. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKShowMessage : NSObject

+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message inView:(UIView *)view;

+ (void)showMessageInKeyWindow:(NSString *)message;

@end
