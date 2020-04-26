//
//  GuidePageView.h
//  GuideView
//
//  Created by Xinbo Hong on 2019/8/27.
//  Copyright © 2019 com.xinbo.pro. All rights reserved.
//
/*
*  控件名称: 新版本预览视图，支持静态图片，动态图片，视频
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuidePageView : UIView

/// 是否显示左上角跳过按钮
@property (nonatomic, assign, getter=isHiddenSkipButton) BOOL hiddenSkipButton;

/// 是否支持滑动进入APP(默认为NO-不支持滑动进入APP | 只有在canSliderInto为YES-隐藏状态下可用; canSliderInto为NO-显示状态下直接点击按钮进入)
@property (nonatomic, assign, getter=isCanSliderInto) BOOL canSliderInto;

/**
 *  图片引导页（可自动识别动态图片和静态图片)
 *
 *  @param frame      位置大小
 *  @param imageNameArray 引导页图片数组(NSString)
 *  @param isHidden   开始体验按钮是否隐藏(YES:隐藏-引导页完成自动进入APP首页; NO:不隐藏-引导页完成点击开始体验按钮进入APP主页)
 *
 */
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden;

/**
 *  视频引导页
 *
 *  @param frame    位置大小
 *  @param videoURL 引导页视频地址
 *
 */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;

@end

NS_ASSUME_NONNULL_END
