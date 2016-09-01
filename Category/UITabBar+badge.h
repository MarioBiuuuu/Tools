//
//  UITabBar+badge.h
//  Dangdang
//
//  Created by Eric MiAo on 16/6/3.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   

- (void)hideBadgeOnItemIndex:(int)index;

@end
