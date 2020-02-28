//
//  PwdTextField.h
//  XBCodingRepo
//  输入密码显示
//  Created by Xinbo Hong on 2017/12/26.
//  Copyright © 2017年 X-Core Co,. All rights reserved.
//


/**  **
 *  控件说明: 密码输入框，单个方形输入框
 *  控件完成情况: 基本完成，后期随技术优化
 *  最后记录时间: 2018/12/27
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PasswordViewType) {
    //分开的底部线：_ _ _ _
    PasswordViewTypeBottomLine = 0,
    //分开的密码框：口口口口
    PasswordViewTypeSeparateField,
    //合并的密码框：口口口口，NumberSpace必须为0
    PasswordViewTypeSeparateLine,
};

typedef void(^FinishFillAction)(NSString *password);

@interface PasswordView : UITextField 

//完成输入后，调用的方法
@property (nonatomic, copy) FinishFillAction action;

//底部线条/密码框/分割线的颜色
@property (nonatomic, strong) UIColor *lineColor;

//根据不同的布局方式，布局密码框情况
/*
 布局使用方法:
 frame: 初始化后按顺序调用
        1. frameWithNumberCount:NumberSpace:SecureText:
        2. frameWithType:
 masonry: 初始化后，当控件加入到父视图，并且加入约束后才能按顺序要用2个布局方法，否则会crash
        1. masonryWithNumberCount:NumberSpace:SecureText:
        2. masonryWithType:
 */

- (void)frameWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space SecureText:(BOOL)isSecureText;
- (void)frameWithType:(PasswordViewType)type;

- (void)masonryWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space  SecureText:(BOOL)isSecureText;;
- (void)masonryWithType:(PasswordViewType)type;

/**
 *  清除密码
 */
- (void)clearUpPassword;

@end
