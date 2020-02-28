//
//  CarouselScrollView.h
//  CarouselScorllView
//
//  Created by Xinbo Hong on 2018/2/22.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

/*
 *  控件名称:    图片无限轮播图
 *  控件完成情况: 基本完成
 *  最后记录时间: 2018/4/05
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CarouselPageControlPosition) {
    CarouselPageControlPositionLeft = 0,
    CarouselPageControlPositionCenter = 1,
    CarouselPageControlPositionRight = 2,
};

@protocol CarouselScrollViewResponseDelegate <NSObject>

@optional

/** 点击图片触发相应图片对应的操作*/
- (void)clickResponseWithIndex:(NSInteger)currentIndex;

@end

@interface CarouselScrollView : UIView

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) id<CarouselScrollViewResponseDelegate> delegate;

@property (nonatomic, assign) CarouselPageControlPosition pageLocation;
@property (nonatomic, assign) NSTimeInterval carouselIntervalTime;


/**
 初始化1: 默认大小的高度为四分之一屏幕、小圆点位置在中间、轮动时间为2秒

 @param images 图片的名称
 @return self
 */
- (instancetype)initWithImages:(NSArray *)images;


/**
 初始化2: 默认小圆点位置在中间、轮动时间为2秒

 @param images 图片的名称
 @param frame 控件的大小
 @return self
 */
- (instancetype)initWithImages:(NSArray *)images withFrame:(CGRect)frame;


/**
 初始化3

 @param images 图片的名称
 @param frame 控件的大小
 @param pageLocation 小圆点的位置
 @param changeTime 轮动时间
 @return self
 */
- (instancetype)initWithImages:(NSArray *)images
                     withFrame:(CGRect)frame
                  pageLocation:(CarouselPageControlPosition)pageLocation
                PageChangeTime:(NSTimeInterval)changeTime;

@end
