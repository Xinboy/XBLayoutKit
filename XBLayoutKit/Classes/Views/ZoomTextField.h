//
//  LoginTextField.h
//  XJPH
//
//  Created by Xinbo Hong on 2018/6/12.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

/*
 *  控件名称:    输入框，点击后标题显示并上移
 *  控件完成情况: 完成，后期跟随技术提升进行优化
 *  最后记录时间: 2018/2/12
 */

#import <UIKit/UIKit.h>

typedef void(^rightButtoAction)(UIButton *sender);
typedef void(^textFieldEndEditAction)(NSString *textStr);

@interface ZoomTextField : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, copy) rightButtoAction blockAction;

@property (nonatomic, copy) textFieldEndEditAction endAction;



/**
 修改标题的文字和颜色
 */
- (void)changeTitle:(NSString *)title titleColor:(UIColor *)color;


/**
 设置基础的参数
 
 @param title 标题内容
 @param placeholder 文本框placeholder内容
 @param imageName 右侧按钮的图片
 @param block 右侧按钮的点击事件
 */
- (void)setBasePropertyWithTitle:(NSString *)title
                     placeholder:(NSString *)placeholder
                  rightImageName:(NSString *)imageName
               rightButtonAction:(rightButtoAction)block;


/**
 重置为通常情况的状态
 */
- (void)resetTitleLabelToNormalStatus;


/**
 设置placeholder状态的
 
 @param font 字体
 @param color 字体颜色
 */
- (void)setPlaceholderFont:(UIFont *)font Color:(UIColor *)color;

/**
 设置为不可点击的状态
 */
- (void)showDisableStatusWithTitle:(NSString *)title
                              text:(NSString *)text
                    rightImageName:(NSString *)imageName;

/**
 设置为不可点击的状态
 */
- (void)showDisableStatusWithTitle:(NSString *)title
                              text:(NSString *)text;



- (void)setTitleLabelWithIsTitle:(BOOL)isTitle;


@end
