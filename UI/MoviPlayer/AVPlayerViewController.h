//
//  AVPlayerViewController.h
//  Player
//
//  Created by Zac on 15/11/6.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AVPlayerVCDelegate <NSObject>

- (void)dismissViewController:(id)VC;

@end

typedef NS_ENUM(NSInteger, PanDirection) {
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved
};
@interface AVPlayerViewController : UIViewController
@property (nonatomic,strong ) AVPlayer                *player;//播放器对象

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, assign) id<AVPlayerVCDelegate>delegate;
@end
