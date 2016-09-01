//
//  YuriSlideBarItem.h
//  slider
//
//  Created by 张晓飞 on 16/4/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YuriSlideBarItem;
@protocol YuriSlideBarItemDelegate <NSObject>

- (void)slideBarItemSelected:(YuriSlideBarItem *)item;

@end

@interface YuriSlideBarItem : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id<YuriSlideBarItemDelegate> delegate;

- (void)setItemTitle:(NSString *)title;
- (void)setItemTitleFont:(CGFloat)fontSize;
- (void)setItemTitleColor:(UIColor *)color;
- (void)setItemSelectedTileFont:(CGFloat)fontSize;
- (void)setItemSelectedTitleColor:(UIColor *)color;

+ (CGFloat)widthForTitle:(NSString *)title;

@end

