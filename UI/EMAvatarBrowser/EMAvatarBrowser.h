//
//  EMAvatarBrowser.h
//  Dangdang
//
//  Created by Eric MiAo on 16/4/27.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMAvatarBrowser : NSObject

/**
 *  为展示url图片添加 @XiaofeiZhang
 *
 *  @param avatarImageView <#avatarImageView description#>
 *  @param url             <#url description#>
 */
+ (void)showImageWithOldImageView:(UIImageView*)avatarImageView urlPath:(NSString *)url;
@end
