//
//  FetchCaptchaButton.h
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/1/16.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

/*
 *  控件名称:    倒计时按钮（退出控制器返回后不重置）
 *  控件完成情况: 完成，后期跟随技术提升进行优化
 *  最后记录时间: 2018/2/11
 */

#import <UIKit/UIKit.h>

typedef void(^FetchCaptchaButtonBlock)(UIButton *sender);

@interface FetchCaptchaButton : UIButton
/// 倒计时的总时间,默认6m0秒
@property (nonatomic, assign) NSUInteger countDownTime;

/// 读秒在后台是否暂停（如果不暂停，回到界面会从上次的秒数继续读取）
@property (nonatomic, assign, getter=isSuspendInBackground) BOOL suspendInBackground;

/**
 初始化方法
 
 @param frame frame
 @param identifyString 控件标识 用于解决多个界面使用此控件倒计时无法刷新问题。当不需要此区别时可以传nil
 @param actionBlock 控件的点击事件
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame
                     Identify:(NSString *)identifyString
                  ButonAction:(FetchCaptchaButtonBlock)actionBlock;


/**
 设置运行时的标题

 @param runningTitle 运行时的标题
 */
- (void)setRunningTitle:(NSString *)runningTitle;


/**
 设置运行结束的标题

 @param finishRunnTitle 运行结束的标题
 */
- (void)setFinishRunTitle:(NSString *)finishRunnTitle;


@end
