//
//  FetchCaptchaButton.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/1/16.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "FetchCaptchaButton.h"
#import "XBGCDTimer.h"

@interface FetchCaptchaButton ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *identifyString;

@property (nonatomic, strong) NSString *runningTitleString;

@property (nonatomic, strong) NSString *finishRunTitleString;

@property (nonatomic, strong) XBGCDTimer *countTimer;

@property (nonatomic, copy) FetchCaptchaButtonBlock fetchCaptchaButtonBlock;

@end

@implementation FetchCaptchaButton

- (instancetype)initWithFrame:(CGRect)frame
                     Identify:(NSString *)identifyString
                  ButonAction:(FetchCaptchaButtonBlock)actionBlock{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.suspendInBackground = YES;
        
        self.enabled = YES;
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setTitle:@"点击获取" forState:UIControlStateNormal];
        [self addTarget:self action:@selector(startTiming) forControlEvents:UIControlEventTouchUpInside];
        
        //App进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ApplicationBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        //App进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ApplicationEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        self.identifyString = identifyString;
        if ([self fetchCurrentCountTime] > 1) {
            self.countDownTime = [self fetchCurrentCountTime];
            [self startTiming];
        } else {
            self.countDownTime = 60;
        }
        
        self.fetchCaptchaButtonBlock = actionBlock;
    }
    return self;
}



- (void)setRunningTitle:(NSString *)runningTitle {
    self.runningTitleString = runningTitle;
}

- (void)setFinishRunTitle:(NSString *)finishRunnTitle {
    self.finishRunTitleString = finishRunnTitle;
}
#pragma mark - **************** Private Event
/// 开始倒计时
- (void)startTiming {
    if (self.fetchCaptchaButtonBlock) {
        self.fetchCaptchaButtonBlock(self);
    }
    
    __weak typeof(self) weakSelf = self;
    self.enabled = NO;
    [self.countTimer timerWithTimeDuration:self.countDownTime withRunBlock:^(NSUInteger currentTime) {
        NSLog(@"%s",__func__);
        [weakSelf saveCurrentCountTime:currentTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.runningTitleString.length > 0) {
                [weakSelf setTitle:[NSString stringWithFormat:@"%@（%ldS）",self.runningTitleString,currentTime] forState:UIControlStateNormal];
            } else {
                [weakSelf setTitle:[NSString stringWithFormat:@"重新发送（%ldS）",currentTime] forState:UIControlStateNormal];
            }
        });
    }];
}

/// 获取当前秒数
- (NSUInteger)fetchCurrentCountTime {
    
    if (self.isSuspendInBackground) {
        // 暂停获取上次秒数
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (!self.identifyString || self.identifyString == nil) {
            return [[def objectForKey:@"FetchCaptchaButton"] integerValue];
        } else {
            return [[def objectForKey:[NSString stringWithFormat:@"FetchCaptchaButton_%@",self.identifyString]] integerValue];
        }
    } else {
        // 暂停获取上次时间戳，判断时间
        
        NSString *lastDataString = @"";
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (!self.identifyString || self.identifyString == nil) {
            lastDataString = [def objectForKey:@"FetchCaptchaButton_Timestamp"];
        } else {
            lastDataString = [def objectForKey:[NSString stringWithFormat:@"FetchCaptchaButton_Timestamp_%@",self.identifyString]];
        }
        
        NSArray<NSString *> *lastDataArray = [lastDataString componentsSeparatedByString:@"_"];
        NSInteger timeStamp = [lastDataArray.firstObject integerValue];
        NSInteger time = [lastDataArray.lastObject integerValue];
        if ([[self currentTimeStamp] integerValue] - timeStamp > time) {
            //超过剩余时间
            return 0;
        } else {
            return [[self currentTimeStamp] integerValue] - timeStamp;
        }
                              
    }
    
}


/// 保存当前秒数
- (void)saveCurrentCountTime:(NSUInteger)currentTime{
    if (self.isSuspendInBackground) {
         // 保存获取上次秒数
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (!self.identifyString || self.identifyString == nil) {
            [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentTime] forKey:@"FetchCaptchaButton"];
        } else {
            [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)currentTime] forKey:[NSString stringWithFormat:@"FetchCaptchaButton_%@",self.identifyString]];
        }
    } else {
        // 保存上次时间戳和剩余时间判断时间，时间戳_剩余时间
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (!self.identifyString || self.identifyString == nil) {
           [def setObject:[NSString stringWithFormat:@"%@_%lu",[self currentTimeStamp], (unsigned long)currentTime] forKey:@"FetchCaptchaButton_Timestamp"];
        } else {
           [def setObject:[NSString stringWithFormat:@"%@_%lu",[self currentTimeStamp], (unsigned long)currentTime] forKey:[NSString stringWithFormat:@"FetchCaptchaButton_Timestamp_%@",self.identifyString]];
        }
    }
    
}

- (NSString *)currentTimeStamp {
    NSDate *datenow = [NSDate date];

    //秒级
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970])];
    
    //毫秒级
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970] * 1000)];
    
    return timeSp;
}

#pragma mark - App 进入前台/后台
- (void)ApplicationBecomeActive {
    NSLog(@"%s",__func__);
    [self.countTimer resumeTimer];
}

- (void)ApplicationEnterBackground {
    NSLog(@"%s",__func__);
    [self.countTimer suspendTimer];
}

#pragma mark - **************** Lazy Load
- (XBGCDTimer *)countTimer {
    if (!_countTimer) {
        self.countTimer = [[XBGCDTimer alloc] init];
    
        __weak typeof(self) weakSelf = self;
        self.countTimer.timerStopBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%s",__func__);
                weakSelf.enabled = YES;
                if (weakSelf.finishRunTitleString.length > 0) {
                    [weakSelf setTitle:weakSelf.finishRunTitleString forState:UIControlStateNormal];
                } else {
                    [weakSelf setTitle:@"点击获取" forState:UIControlStateNormal];
                }
            });
        };
    }
    return _countTimer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
