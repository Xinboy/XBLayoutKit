//
//  RateStarView.h
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/5/17.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

/**  **
 *  控件说明: 五星评论控件，支持masonry和frame创建
 *  控件完成情况: 基本完成，后期随技术优化
 *  最后记录时间: 2018/12/06
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RateStarStyle) {
    //只能整颗心选择
    RateStarStyleWhole = 0,
    //半颗心选择
    RateStarStyleHalf,
    //任何位置的星级
    RateStarStyleIncomplete,
};

typedef void(^CompleteBlock)(CGFloat currentScore);

@interface RateStarView : UIView

@property (nonatomic, assign, getter = isAnimation) BOOL animation;

@property (nonatomic, assign) RateStarStyle rateStyle;


/**
 根据frame等参数创建视图
 
 @param numberOfStars 星星总个数
 @param rateStyle 星星的方式
 @param isAnimation 是否启动动画
 @param finishBlock 点击后的额外动作
 */
- (void)frameWithNumberOfStars:(NSInteger)numberOfStars
                     rateStyle:(RateStarStyle)rateStyle
                   isAnination:(BOOL)isAnimation
                        finish:(CompleteBlock)finishBlock;

- (void)frameWithNumberOfStars:(NSInteger)numberOfStars;


- (void)masonryWithNumberOfStars:(NSInteger)numberOfStars
                       rateStyle:(RateStarStyle)rateStyle
                     isAnination:(BOOL)isAnimation
                          finish:(CompleteBlock)finishBlock;

- (void)masonryWithNumberOfStars:(NSInteger)numberOfStars;
@end

