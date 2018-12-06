//
//  VerticalLabel.h
//  XBKit
//
//  Created by Xinbo Hong on 2018/6/14.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

/**
 *  控件说明: 垂直方向的文字位置布局Label
 *  控件完成情况: 基本完成，后期随技术优化
 *  默认设置：左侧间距：11.0
 *          上下间距：20.0
 *  最后记录时间: 2018/12/05
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger ,LabelVerticalAlignment){
    LabelVerticalAlignmentTop = 0,
    LabelVerticalAlignmentMiddle,
    LabelVerticalAlignmentBottom
};

@interface VerticalLabel : UILabel


@property (nonatomic, assign) LabelVerticalAlignment verticalAlignment;


/**
 修改垂直方式、左侧间距、上下间距
 */
- (void)setVerticalAlignment:(LabelVerticalAlignment)verticalAlignment
                   leftSpace:(CGFloat)leftSpace
               verticalSpace:(CGFloat)verticalSpace;

/**
 修改垂直方式、水平方式
 */
- (void)setVerticalAlignment:(LabelVerticalAlignment)verticalAlignment
               textAlignment:(NSTextAlignment)alignment;

@end
