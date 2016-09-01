//
//  YuriSliderBar.m
//  slider
//
//  Created by 张晓飞 on 16/4/19.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import "YuriSliderBar.h"
#import "YuriSlideBarItem.h"

#define kDEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define kDEFAULT_SLIDER_COLOR [UIColor orangeColor]
#define kSLIDER_VIEW_HEIGHT 2

@interface YuriSliderBar () <YuriSlideBarItemDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) YuriSlideBarItem *selectedItem;
@property (nonatomic, copy) YuriSliderBarSelectItemBlock callback;

@end

@implementation YuriSliderBar

#pragma mark - Lifecircle

- (instancetype)init {
    CGRect frame = CGRectMake(0, 20, kDEVICE_WIDTH, 46);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _items = [NSMutableArray array];
        [self initScrollView];
        [self initSliderView];
    }
    return self;
}

- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = itemsTitle;
    [self setupItems];
}

- (void)setItemColor:(UIColor *)itemColor {
    for (YuriSlideBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    for (YuriSlideBarItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}

- (void)setSelectedItem:(YuriSlideBarItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
}


#pragma - mark Private

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    [self addSubview:_scrollView];
}

- (void)initSliderView {
    _sliderView = [[UIView alloc] init];
    _sliderColor = kDEFAULT_SLIDER_COLOR;
    _sliderView.backgroundColor = _sliderColor;
    [_scrollView addSubview:_sliderView];
}

- (void)setupItems {
    CGFloat itemX = 0;
    CGFloat maxItemW = 0;
    for (NSInteger i = 0;i<_itemsTitle.count;i++) {
        NSString *title = _itemsTitle[i];
        YuriSlideBarItem *item = [[YuriSlideBarItem alloc] init];
        item.delegate = self;
        
        CGFloat itemW = [YuriSlideBarItem widthForTitle:title];
        maxItemW = maxItemW > itemW ? maxItemW : itemW;
        item.frame = CGRectMake(itemX+15, 0, itemW, CGRectGetHeight(_scrollView.frame));
        [item setItemTitle:title];
        [_items addObject:item];
        
        [_scrollView addSubview:item];
        
        // Caculate the origin.x of the next item
        itemX = CGRectGetMaxX(item.frame);
    }
    
    CGFloat SW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat destW = SW / (_itemsTitle.count);
    
    if (destW > maxItemW) {
        itemX = 0;
        for (YuriSlideBarItem *item in _items) {
            item.frame = CGRectMake(itemX, item.frame.origin.y, destW, item.frame.size.height);
            itemX = CGRectGetMaxX(item.frame);
        }
    }
    
    _scrollView.contentSize = CGSizeMake(itemX+15, CGRectGetHeight(_scrollView.frame));
    
    YuriSlideBarItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    if (destW > maxItemW) {
        _sliderView.frame = CGRectMake(0, self.frame.size.height - kSLIDER_VIEW_HEIGHT, firstItem.frame.size.width, kSLIDER_VIEW_HEIGHT);
    } else {
        _sliderView.frame = CGRectMake(15, self.frame.size.height - kSLIDER_VIEW_HEIGHT, firstItem.frame.size.width, kSLIDER_VIEW_HEIGHT);
    }
    
}

- (void)scrollToVisibleItem:(YuriSlideBarItem *)item {
    NSInteger selectedItemIndex = [self.items indexOfObject:_selectedItem];
    NSInteger visibleItemIndex = [self.items indexOfObject:item];
    
    if (selectedItemIndex == visibleItemIndex) {
        return;
    }
    
    CGPoint offset = _scrollView.contentOffset;
    
    if (CGRectGetMinX(item.frame) >= offset.x && CGRectGetMaxX(item.frame) <= (offset.x + CGRectGetWidth(_scrollView.frame))) {
        return;
    }
    
    if (selectedItemIndex < visibleItemIndex) {
        if (CGRectGetMaxX(_selectedItem.frame) < offset.x) {
            offset.x = CGRectGetMinX(item.frame);
        } else {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        }
    } else {
        if (CGRectGetMinX(_selectedItem.frame) > (offset.x + CGRectGetWidth(_scrollView.frame))) {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        } else {
            offset.x = CGRectGetMinX(item.frame);
        }
    }
    _scrollView.contentOffset = offset;
}

- (void)addAnimationWithSelectedItem:(YuriSlideBarItem *)item {
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.bounds));
    boundsAnimation.toValue = @(CGRectGetWidth(item.frame));
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, boundsAnimation];
    animationGroup.duration = 0.2;
    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.bounds;
    rect.size.width = CGRectGetWidth(item.frame);
    _sliderView.layer.bounds = rect;
}

- (void)sliderBarSelectItem:(YuriSliderBarSelectItemBlock)callback {
    _callback = callback;
}

- (void)selectItemAtIndex:(NSUInteger)index {
    YuriSlideBarItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem) {
        return;
    }
    
    item.selected = YES;
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;
}


- (void)slideBarItemSelected:(YuriSlideBarItem *)item {
    if (item == _selectedItem) {
        return;
    }
    
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;
    _callback([self.items indexOfObject:item]);
}

@end
