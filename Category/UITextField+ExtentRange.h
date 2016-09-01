//
//  UITextField+ExtentRange.h
//  Dangdang
//
//  Created by Yuri on 16/5/10.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)
- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange)range;
@end
