//
//  PwdTextField.h
//  XBCodingRepo
//  输入密码显示
//  Created by Xinbo Hong on 2017/12/26.
//  Copyright © 2017年 X-Core Co,. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  控件名称:    密码输入框，类早期支付宝交易密码输入
 *  控件完成情况: 完成，后期跟随技术提升进行优化
 *  最后记录时间: 2018/2/12
 */

typedef void(^InputToCountAction)(void);

@interface PwdTextField : UITextField
//密码个数
@property (nonatomic, assign) NSInteger numberCount;
//密码之间的间距
@property (nonatomic, assign) CGFloat numberSpace;

- (void)setupPwdTextFieldWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space;

- (void)setInputToCountAction:(InputToCountAction)action;
@end
