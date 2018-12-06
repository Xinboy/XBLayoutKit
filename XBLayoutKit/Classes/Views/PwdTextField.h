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
 *  最后记录时间: 2018/12/05
 */

#import <UIKit/UIKit.h>

typedef void(^InputToCountAction)(void);

@interface PwdTextField : UITextField


- (void)frameWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space;

- (void)masonryWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space;


- (void)setInputToCountAction:(InputToCountAction)action;
@end
