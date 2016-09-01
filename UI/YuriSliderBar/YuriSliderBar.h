//
//  YuriSliderBar.h
//  slider
//
//  Created by 张晓飞 on 16/4/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YuriSliderBarSelectItemBlock)(NSUInteger idx);

@interface YuriSliderBar : UIView

/**
 *  标题数组
 */
@property (copy, nonatomic) NSArray *itemsTitle;

/**
 *  标题默认字体颜色
 */
@property (strong, nonatomic) UIColor *itemColor;

/**
 *  标题选中字体颜色
 */
@property (strong, nonatomic) UIColor *itemSelectedColor;

/**
 *  下划线颜色
 */
@property (strong, nonatomic) UIColor *sliderColor;

- (void)sliderBarSelectItem:(YuriSliderBarSelectItemBlock)callback;
- (void)selectItemAtIndex:(NSUInteger)index;

@end
