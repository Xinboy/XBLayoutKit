//
//  XBGCDTimer.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/1/16.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "XBGCDTimer.h"

@interface XBGCDTimer () {
    dispatch_source_t __block timer;
}

@property (nonatomic, copy) TimerRunBlock timerRunBlock;

@end

@implementation XBGCDTimer

- (void)timerWithTimeDuration:(double)timeDuration withRunBlock:(TimerRunBlock)receiveTimerRunBlock {
    if (!timer) {
        __weak typeof(self)weakSelf = self;
        
        self.timerRunning = YES;
        NSUInteger __block time = timeDuration;
        self.timerRunBlock = receiveTimerRunBlock;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            if (time <= 0) {
                [self stopTimer];
            } else {
                if (weakSelf.timerRunBlock) {
                    weakSelf.timerRunBlock(time --);
                }
            }
        });
        dispatch_resume(timer);
        
    }
}

- (void)stopTimer {
    if (timer) {
        if (self.isTimerRunning) {
            dispatch_source_cancel(timer);
            timer = nil;
            self.timerRunning = NO;
            if (self.timerStopBlock) {
                self.timerStopBlock();
            }
        }
    }
}

- (void)resumeTimer {
    if (timer) {
        if (!self.isTimerRunning) {
            dispatch_resume(timer);
            self.timerRunning = YES;
        }
    }
}

- (void)suspendTimer {
    if (timer) {
        if (self.isTimerRunning) {
            dispatch_suspend(timer);
            self.timerRunning = NO;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
