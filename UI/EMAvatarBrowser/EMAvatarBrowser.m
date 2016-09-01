//
//  EMAvatarBrowser.m
//  Dangdang
//
//  Created by Eric MiAo on 16/4/27.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import "EMAvatarBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
static CGRect oldframe;
static NSString *_url;
static UIImageView *_imageView;
@interface EMAvatarBrowser () {
    
}

@end

@implementation EMAvatarBrowser
+ (void)showImage:(UIImageView *)avatarImageView {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    UIImage *image=avatarImageView.image;
    if (image == nil) {
        return;
    }
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    _imageView = imageView;
    if (_url.length == 0 || _url == nil) {
        imageView.image = avatarImageView.image;
    } else {
        [imageView setShowActivityIndicatorView:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"00");
            if (error && image == nil) {
                [showMessage showMessage:@"网络不给力"];
            }
        }];
    }
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
}

+ (void)showImageWithOldImageView:(UIImageView*)avatarImageView urlPath:(NSString *)url {
    _url = url;
    [self showImage:avatarImageView];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [_imageView sd_cancelCurrentImageLoad];
        [backgroundView removeFromSuperview];
    }];
}

@end
