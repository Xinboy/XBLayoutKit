//
//  AuthManager.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/3/12.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "AuthManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
/** 授权成功*/
NSString *const kNotificationKeyValidateAuthSuccess = @"kNotificationKeyValidateAuthSuccess";
/** 授权失败*/
NSString *const kNotificationKeyValidateAuthFailed = @"kNotificationKeyValidateAuthFailed";
/** 授权取消*/
NSString *const kNotificationKeyValidateAuthCancel = @"kNotificationKeyValidateAuthCancel";
/** 输入密码*/
NSString *const kNotificationKeyValidateAuthInputPwd = @"kNotificationKeyValidateAuthInputPwd";
/** 设备不可用*/
NSString *const kNotificationKeyValidateAuthNotAvailable = @"kNotificationKeyValidateAuthNotAvailable";
/** 设备未设置*/
NSString *const kNotificationKeyValidateAuthNotEnrolled = @"kNotificationKeyValidateAuthNotEnrolled";
/** 设备未设置密码*/
NSString *const kNotificationKeyValidateAuthPasscodeNotSet = @"kNotificationKeyValidateAuthPasscodeNotSet";
/** 设备被锁定*/
NSString *const kNotificationKeyValidateAuthLocked = @"kNotificationKeyValidateAuthLocked";

@implementation AuthManager

+ (void)validateAuthSetting {
    if ([[UIDevice currentDevice] systemVersion].doubleValue < 8.0 ) {
        NSLog(@"系统不支持");
        return;
    }
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    context.localizedFallbackTitle = @"";
    
    [context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    if (error.code == kLAErrorTouchIDLockout && [UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthLocked object:nil];
        [context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启指纹/面容验证功能" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                if (success) {
                    [self validateAuthSetting];
                }
            }
        }];
        return;
    }
    [context evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹/面容验证" reply:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 指纹识别错误调用分为以下情况,
            // 点击取消按钮 : domain = com.apple.LocalAuthentication code = -2
            // 点击输入密码按钮 : domain = com.apple.LocalAuthentication code = -3
            // 输入密码重新进入指纹系统 : domain = com.apple.LocalAuthentication code = -8
            // 指纹三次错误 : domain = com.apple.LocalAuthentication code = -1
            // 指纹验证成功 : error = nil
            if (error) {
                switch (error.code) {
                    case kLAErrorAuthenticationFailed:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthFailed object:nil];
                        break;
                    case kLAErrorUserCancel:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthCancel object:nil];
                        break;
                    case kLAErrorUserFallback:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthInputPwd object:nil];
                        break;
                    case kLAErrorPasscodeNotSet:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthPasscodeNotSet object:nil];
                        break;
                    case kLAErrorTouchIDNotAvailable:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthNotAvailable object:nil];
                        break;
                    case kLAErrorTouchIDNotEnrolled:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthNotEnrolled object:nil];
                        break;
                    case kLAErrorTouchIDLockout:
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthLocked object:nil];
                        if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
                            [self validateAuthSetting];
                        }
                        break;
                    default:
                        break;
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKeyValidateAuthSuccess object:nil];
        });
    }];
                       
}

@end
