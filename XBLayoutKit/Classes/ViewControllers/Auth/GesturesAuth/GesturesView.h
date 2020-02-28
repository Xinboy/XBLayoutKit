//
//  GesturesView.h
//  pydx
//
//  Created by Xinbo Hong on 2020/2/18.
//  Copyright © 2020年 Xinbo Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GesturesView;


@protocol GesturesViewDelegate <NSObject>

/// 当前界面状态：0-开始手势，1-当前是第二次设置密码
- (void)gesturesView:(GesturesView *)gesturesView status:(NSString *)status;

/// 手势错误原因
- (void)gesturesView:(GesturesView *)gesturesView error:(NSString *)errorName;

/// 手势设置成功情况
- (void)gesturesView:(GesturesView *)gesturesView settingStatus:(BOOL)isSuccess;

/// 手势密码验证成功情况
- (void)gesturesView:(GesturesView *)gesturesView unlockStatus:(BOOL)isSuccess;

@end

@interface GesturesView : UIView

@property (nonatomic, weak) id<GesturesViewDelegate> delegate;

/** 判断是设置手势还是手势解锁*/
@property (nonatomic, assign, getter=isSettingGesture) BOOL settingGesture;

@property (nonatomic, strong, readonly) UIColor *selectedColor;

+ (BOOL)hasGesturesLogin;

- (instancetype)initWithFrame:(CGRect)frame selectedColor:(UIColor *)selectColor;

@end
