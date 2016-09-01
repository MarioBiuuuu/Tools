//
//  YuriTableView.h
//  TawaiCompany
//
//  Created by 张晓飞 on 15/11/7.
//  Copyright © 2015年 张晓飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuriEmptyView.h"

@protocol YuriTableViewDataSource , YuriTableViewDelegate;

@interface YuriTableView : UIView <UITableViewDelegate, UITableViewDataSource>

/**
 *  数据源相关委托
 */
@property (nonatomic,assign) id <YuriTableViewDataSource> dataSource;

/**
 *  事件回调相关委托
 */
@property (nonatomic,assign) id <YuriTableViewDelegate>   delegate;

/**
 *  展开的列表层级索引 Default is [NSIndexPath indexPathForRow:-1 inSection:-1]
 */
@property (nonatomic,readonly,strong) NSIndexPath *openedIndexPath;

/**
 *  主体列表对象
 */
@property (nonatomic,readonly,strong) UITableView *tableView;

/**
 *  展开最内层cell 要显示的View
 */
@property (nonatomic,strong) UIView *atomView;

/**
 *  展开后atomView的位置坐标（相对于展开的 Cell 左下角）Default is CGPointMake(0, 0);
 */
@property (nonatomic) CGPoint atomOrigin;
/**
 *  空数据页面
 */
@property (nonatomic, strong) YuriEmptyView *emptyView;

@property (nonatomic, assign) BOOL allowTouchEmptyView;

/**
 *  列表单元添加复用标识
 *
 *  @param identifier 复用标识字符串
 *
 *  @return 列表单元对象
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;


/**
 *  模拟列表Cell点击事件 -1 为关闭
 *
 *  @param indexPath cell所在路径
 */
- (void)sendCellTouchActionWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  模拟列表Header点击事件 －1 为关闭
 *
 *  @param section header 索引
 */
- (void)sendHeaderTouchActionWithSection:(NSInteger)section;

/**
 *  重新加载数据
 */
- (void)reloadData;

@end

/**
 *  YuriTableView 数据协议
 */
@protocol YuriTableViewDataSource <NSObject>

@required

- (NSInteger)mTableView:(YuriTableView *)mTableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)mTableView:(YuriTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(YuriTableView *)mTableView;              // Default is 1 if not implemented

- (UIImage *)mTableViewEmptyViewPlaceHodelImage:(YuriTableView *)mTableView;

- (NSMutableAttributedString *)mTableViewEmptyViewTitleString:(YuriTableView *)mTableView;

- (NSMutableAttributedString *)mTableViewEmptyViewInfoString:(YuriTableView *)mTableView;

@end


/**
 *  YuriTableView 委托协议
 */
@protocol YuriTableViewDelegate <NSObject>

@optional

- (CGFloat)mTableView:(YuriTableView *)mTableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)mTableView:(YuriTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mTableView:(YuriTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)mTableView:(YuriTableView *)mTableView viewForHeaderInSection:(NSInteger)section;

- (void)mTableView:(YuriTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section;
- (void)mTableView:(YuriTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section;

- (void)mTableView:(YuriTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)mTableView:(YuriTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)mTableView:(YuriTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)mTableViewAllowTouchuEmptyView:(YuriTableView *)mTableView;

- (void)mTableViewDidTouchEmptyView:(YuriTableView *)mTableView emptyView:(YuriEmptyView *)emptyView;

- (UIColor *)mTableViewEmptyBackgroundColor:(YuriTableView *)mTableView;

@end




