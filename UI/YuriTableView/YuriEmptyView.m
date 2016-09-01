//
//  YuriEmptyView.m
//  TawaiCompany
//
//  Created by 张晓飞 on 15/12/30.
//  Copyright © 2015年 张晓飞. All rights reserved.
//

#import "YuriEmptyView.h"
#import <Masonry/Masonry.h>

@implementation YuriEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.emptyImageView = [[UIImageView alloc] init];
        [self addSubview:self.emptyImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_centerY).offset(40);
            
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(self.emptyImageView.mas_bottom).offset(20);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_greaterThanOrEqualTo(15);
        }];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_greaterThanOrEqualTo(15);
        }];
    }
    return self;
}
@end
