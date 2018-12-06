//
//  CalendarView.h
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/4/28.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

/**
 *  控件说明: 日历
 *  控件完成情况: 未完成
 *  最后记录时间: 2018/12/05
 */

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@end


#pragma mark - --- CalendarCell ---
@interface CalendarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *monthLabel;

@property (nonatomic, strong) UILabel *dayLabel;

- (void)changeDayLabelIsSelected;
@end
