//
//  XBDatePicker.h
//  DailyAccouting
//
//  Created by Xinbo Hong on 2017/7/25.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  控件名称:    时间选择器
 *  控件完成情况: 完成，后期跟随技术提升进行优化
 *  最后记录时间: 2018/1/12
 */

typedef void(^ConfirmButtonAction)(UIButton *sender);

@interface XBDatePicker : UIView

- (void)showXBDatePicker;
- (void)hideXBDatePicker;

/**
 * 设置时间的范围
 * Key:minDate Value:[NSDate class] comment:最小时间区间
 * Key:maxDate Value:[NSDate class] comment:最大时间区间
 */
- (void)initDatePickerProperty:(NSDictionary *)propertyDict;

/** 设置文本框的默认时间*/
- (void)setSelectedDateLabelText:(NSString *)text;

/** 设置确定与取消按钮点击事件*/
- (void)setConfirmButtonAction:(ConfirmButtonAction)confirmAction;
@end
