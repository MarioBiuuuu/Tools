//
//  LKCommonTools.h
//  DDDDD
//
//  Created by Yuri on 16/8/30.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LKCommonTools : NSObject

/**
 *  判断手机号是否合法
 *
 *  @return 返回YES合法 返回NO不合法
 */

+(BOOL)judgePhoneNumberIsLegal:(NSString *)phoneNumber;

/**
 *  判断字符传中是否包含Emoji表情
 *
 *  @param string 字符创
 *
 *  @return 结果 @{@"isContains":@(BOOL),@"emojiCount":@(NSUInteger)}
 */
+ (NSDictionary *)stringContainsEmoji:(NSString *)string;

/**
 *  将汉字转化成拼音
 *
 *  @param string 待转换的中文
 *
 *  @return 拼音字符串
 */
+ (NSString *)translateChineseToPinYin:(NSString *)string;

/**
 *  获取视频第一帧截图
 *
 *  @param videoURL 视频url
 *  @param time 时间
 *
 *  @return 截图
 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 *  字典转json
 *
 *  @param dic
 *
 *  @return
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  json转字典
 *
 *  @param string
 *
 *  @return
 */
+ (NSDictionary *)JsonToDictionary:(NSString *)string;

/**
 *  压缩图片尺寸
 *
 *  @param image    带压缩图片
 *  @param viewSize 目标Size
 *
 *  @return UIImage
 */
+ (UIImage *)compressImage:(UIImage *)image withSize:(CGSize)viewSize;

/**
 *  通过手机号码生成固定颜色
 *
 *  @param mobile 手机号码
 *
 *  @return 颜色
 */
+ (UIColor *)getColorWithMobile:(NSString *)mobile;

/**
 *  将登陆用手机号写入沙盒
 *
 *  @param userName 用户手机号
 */
+ (void)archiveUserMobileToSandBox:(NSString *)mobile;

/**
 *  从沙盒获取题用户手机号
 *
 *  @return 用户手机号
 */
+ (NSString *)unArchiveUserMobile;

/**
 *  将登陆用户名写入沙盒
 *
 *  @param userName 用户名
 */
+ (void)archiveUserNameToSandBox:(NSString *)userName;

/**
 *  从沙盒获取题用户名称
 *
 *  @return 用户名称
 */
+ (NSString *)unArchiveUserName;

/**
 *  将登陆用户ID写入沙盒
 *
 *  @param userID 用户ID
 */
+ (void)archiveUserIDToSandBox:(NSString *)userID;

/**
 *  从沙盒获取题用户ID
 *
 *  @return 用户ID
 */
+ (NSString *)unArchiveUserID;

/**
 *  将登陆用户模型写入沙盒
 *
 *  @param userInfoModel 用户信息模型
 */
+ (void)archiveUserInfoToSandBox:(id)userInfoModel;

/**
 *  从沙盒获取题用户信息模型
 *
 *  @return 用户模型
 */
+ (instancetype)unArchiveUserInfo;

/**
 *  将图片保存到沙盒路径下Image文件夹内
 *
 *  @param image 待保存图片
 *
 *  @return 文件路径
 */
+ (NSString *)saveImageToDocument:(UIImage *)image;

/**
 *  判断字符串是否为全中文
 *
 *  @param checkString 待检测字符串
 *
 *  @return 判断返回
 */
+ (BOOL)checkIsChineseString:(NSString *)checkString;

/**
 *  判断字符串是否为空（@"" nil NULL (null)）
 *
 *  @param string 待检测字符串
 *
 *  @return 判断返回
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *  验证邮箱
 *
 *  @param email 待检测字符串
 *
 *  @return 判断返回
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  判断是否为全数字
 *
 *  @param str 待检测字符串
 *
 *  @return 判断返回
 */
+ (BOOL)isNumText:(NSString *)str;

/**
 *  拉伸图片
 *
 *  @param image 图片
 *
 *  @return 返回拉伸后的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)image;

/**
 *  判断后一个时间是否是在指定的时间范围内
 *
 *  @param minutes   指定的时间范围，单位分钟
 *  @param date      基准时间
 *  @param otherDate 目标时间
 *
 *  @return 判断返回
 */
+ (BOOL)isLessThanDestMinutes:(double)minutes fromDate:(NSString *)date otherDate:(NSString *)otherDate;

/**
 *  检测银行卡的合法性
 *
 *  @param cardNo 银行卡号
 *
 *  @return 判断返回
 */
+ (BOOL)checkBankCardNo:(NSString *)cardNo;


/** 邮箱验证 */
- (BOOL)isValidEmail;

/** 手机号码验证 */
- (BOOL)isValidPhoneNum;

/** 车牌号验证 */
- (BOOL)isValidCarNo;

/** 网址验证 */
- (BOOL)isValidUrl;

/** 邮政编码 */
- (BOOL)isValidPostalcode;

/** 纯汉字 */
- (BOOL)isValidChinese;


/**
 @brief     是否符合IP格式，xxx.xxx.xxx.xxx
 */
- (BOOL)isValidIP;

/** 身份证验证 refer to http://blog.csdn.net/afyzgh/article/details/16965107*/
- (BOOL)isValidIdCardNum;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

/** 去掉html格式 */
- (NSString *)removeHtmlFormat;

/** 工商税号 */
- (BOOL)isValidTaxNo;

@end
