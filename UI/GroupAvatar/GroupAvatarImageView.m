//
//  GroupAvatarImageView.m
//  dingdingPhoto
//
//  Created by Yuri on 16/4/26.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "GroupAvatarImageView.h"

const CGFloat marginSpaceRatio = 27.0;

@interface GroupAvatarImageView ()
{
    CGFloat _cellImageViewchrSideLength;
    CGFloat _margin;
}

@end

@implementation GroupAvatarImageView

- (UIImageView *)avtarGroupOnImageView:(UIImageView *)canvasImageView subImageViews:(NSArray *)imageViews{
    _margin = canvasImageView.bounds.size.width / marginSpaceRatio;
    return [self avtarGroupOnImageView:canvasImageView subImageViews:imageViews marginValue:_margin];
}

- (UIImageView *)avtarGroupOnImageView:(UIView *)view subImageViews:(NSArray *)imageViews marginValue:(CGFloat)marginValue{
    _margin = marginValue;
    UIImageView *canvasImageView = [[UIImageView alloc] initWithFrame:view.frame];
    [self generateImageViewSideLengthWithCanvasView:canvasImageView byImageViewsCount:imageViews.count];
    
    if ([imageViews count] == 1) {
        UIImageView* imageView_1 = imageViews[0];
        imageView_1.frame = CGRectMake(0, 0, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
    }else if ([imageViews count] == 2) {
        CGFloat row_1_origin_y = (canvasImageView.frame.size.height - _cellImageViewchrSideLength) / 2;
        imageViews = [self generatorMatrix:imageViews beginOriginY:row_1_origin_y];
    }else if ([imageViews count] == 3) {
        CGFloat row_1_origin_y = (canvasImageView.frame.size.height - _cellImageViewchrSideLength * 2) / 3;
        
        UIImageView* imageView_1 = imageViews[0];
        imageView_1.frame = CGRectMake((canvasImageView.frame.size.width - _cellImageViewchrSideLength) / 2, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
        
        imageViews = [self generatorMatrix:imageViews beginOriginY:row_1_origin_y + _cellImageViewchrSideLength + _margin];
    }else if ([imageViews count] == 4) {
        CGFloat row_1_origin_y = (canvasImageView.frame.size.height - _cellImageViewchrSideLength * 2) / 3;
        imageViews = [self generatorMatrix:imageViews beginOriginY:row_1_origin_y];
    }else{
        CGFloat row_1_origin_y = (canvasImageView.frame.size.height - _cellImageViewchrSideLength * 2) / 3;
        imageViews = [self generatorMatrix:imageViews beginOriginY:row_1_origin_y];
    }
    
    for (UIImageView *imageView in imageViews) {
        [canvasImageView addSubview:imageView];
    }
    
    return canvasImageView;
}

- (NSArray *)generatorMatrix:(NSArray *)imageViews beginOriginY:(CGFloat)beginOriginY {
    NSInteger count = (NSInteger)imageViews.count;
    
    NSInteger cellCount=4;
    NSInteger maxRow=2;
    NSInteger maxColumn=2;
    NSInteger ignoreCountOfBegining=count%2;
    
    for (NSInteger i = 0; i < cellCount; i++) {
        if (i > imageViews.count - 1) break;
        if (i < ignoreCountOfBegining) continue;
        
        NSInteger row = floor((CGFloat)(i - ignoreCountOfBegining) / maxRow);
        NSInteger column = (i - ignoreCountOfBegining) % maxColumn;
        
        CGFloat origin_x = _margin + _cellImageViewchrSideLength * column + _margin * column;
        CGFloat origin_y = beginOriginY + _cellImageViewchrSideLength * row + _margin * row;
        
        UIImageView* imageView = imageViews[i];
        imageView.frame = CGRectMake(origin_x, origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
    }
    return imageViews;
}

- (void)generateImageViewSideLengthWithCanvasView:(UIView *)canvasView byImageViewsCount:(NSInteger)count {
    CGFloat sideLength = 0.0f;
    
    if (count == 1) {
        sideLength = canvasView.frame.size.width;
    } else if (count >=2 && count <=4) {
        sideLength = (canvasView.frame.size.width - _margin * 3) / 2;
    } else {
        sideLength = (canvasView.frame.size.width - _margin * 3) / 2;
    }
    
    _cellImageViewchrSideLength = sideLength;
}

@end
