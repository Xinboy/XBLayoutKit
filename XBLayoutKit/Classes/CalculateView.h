//
//  CalculateView.h
//  DailyAccouting
//
//  Created by Xinbo Hong on 2017/9/2.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.


/**
 *  控件说明: 计算器视图
 *  控件完成情况: 未完成，计算逻辑还有问题
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
