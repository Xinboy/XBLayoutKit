//
//  CalculateView.h
//  DailyAccouting
//
//  Created by Xinbo Hong on 2017/9/2.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.


/**
 *  控件说明: 计算器视图
 *  控件完成情况: 基本完成，后期随技术优化
 *  最后记录时间: 2018/12/05
 */

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSNotificationName const XBCalculateViewDidshowValueHasChangeNotification;
UIKIT_EXTERN NSString *const XBCalculateViewDidshowValueHasChangeUserInfoKey;

@interface CalculateView : UIView
{
    CGFloat itemSide;
    UIColor *oparatorColor;
    UIColor *actionColor;
    UIColor *numberColor;
}

@property (nonatomic, strong) UIView *calculatorBgView;

@property (nonatomic, strong) NSString *showValueStr;

- (void)hideCalculateView;

@end
