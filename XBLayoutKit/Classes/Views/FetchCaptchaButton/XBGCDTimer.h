//
//  XBGCDTimer.h
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/1/16.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^TimerRunBlock)(NSUInteger currentTime);
typedef void (^TimerStopBlock)(void);

@interface XBGCDTimer : UIButton

@property (nonatomic, assign, getter=isTimerRunning) BOOL timerRunning;

@property (nonatomic, copy) TimerStopBlock timerStopBlock;

/**
 *  定时器初始化(定时器默认开启)
 *
 *  @param timeDuration  时长
 *  @param timerRunBlock 定时器回调
 */
- (void)timerWithTimeDuration:(double)timeDuration withRunBlock:(TimerRunBlock)timerRunBlock;


/**
 *  定时器停止
 */
- (void)stopTimer;

/**
 *  定时器恢复
 */
- (void)resumeTimer;

/**
 *  定时器暂停
 */
- (void)suspendTimer;

@end
