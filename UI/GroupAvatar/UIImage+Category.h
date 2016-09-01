//
//  UIImage+Category.h
//  joinup_iphone
//
//  Created by shen_gh on 15/4/23.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

//取颜色color背景图片
+ (UIImage *)imageFormColor:(UIColor *)color frame:(CGRect)frame;


/**
 *  带居中文字的图片
 *
 *  @param title    文字
 *  @param fontSize 文字大小
 *
 *  @return
 */
- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;


+(UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com