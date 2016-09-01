//
//  YuriSlideBarItem.m
//  slider
//
//  Created by 张晓飞 on 16/4/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "YuriSlideBarItem.h"

#define kDEFAULT_TITLE_FONTSIZE 16
#define kDEFAULT_TITLE_SELECTED_FONTSIZE 17
#define kDEFAULT_TITLE_COLOR [UIColor blackColor]
#define kDEFAULT_TITLE_SELECTED_COLOR [UIColor orangeColor]

#define kHORIZONTAL_MARGIN 10

@interface YuriSlideBarItem ()

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat selectedFontSize;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *selectedColor;

@end

@implementation YuriSlideBarItem

#pragma mark - Lifecircle

- (instancetype) init {
    if (self = [super init]) {
        _fontSize = kDEFAULT_TITLE_FONTSIZE;
        _selectedFontSize = kDEFAULT_TITLE_SELECTED_FONTSIZE;
        _color = kDEFAULT_TITLE_COLOR;
        _selectedColor = kDEFAULT_TITLE_SELECTED_COLOR;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat titleX = (CGRectGetWidth(self.frame) - [self titleSize].width) * 0.5;
    CGFloat titleY = (CGRectGetHeight(self.frame) - [self titleSize].height) * 0.5;
    
    CGRect titleRect = CGRectMake(titleX, titleY, [self titleSize].width, [self titleSize].height);
    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont], NSForegroundColorAttributeName : [self titleColor]};
    [_title drawInRect:titleRect withAttributes:attributes];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setItemTitle:(NSString *)title {
    _title = title;
    [self setNeedsDisplay];
}

- (void)setItemTitleFont:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemSelectedTileFont:(CGFloat)fontSize {
    _selectedFontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemTitleColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setItemSelectedTitleColor:(UIColor *)color {
    _selectedColor = color;
    [self setNeedsDisplay];
}

- (CGSize)titleSize {
    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont]};
    CGSize size = [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (UIFont *)titleFont {
    UIFont *font;
    if (_selected) {
//        font = [UIFont boldSystemFontOfSize:_selectedFontSize];
        font = [UIFont boldSystemFontOfSize:_fontSize];
    } else {
        font = [UIFont systemFontOfSize:_fontSize];
    }
    return font;
}

- (UIColor *)titleColor {
    UIColor *color;
    if (_selected) {
        color = _selectedColor;
    } else {
        color = _color;
    }
    return color;
}

+ (CGFloat)widthForTitle:(NSString *)title {
   // NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:kDEFAULT_TITLE_FONTSIZE]};
    //CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    //size.width = ceil(size.width)+ kHORIZONTAL_MARGIN * 2;
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kDEFAULT_TITLE_FONTSIZE]}];
    return size.width;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideBarItemSelected:)]) {
        [self.delegate slideBarItemSelected:self];
    }
}

@end
