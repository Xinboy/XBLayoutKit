//
//  AuthManager.h
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/3/12.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//



/*
 *  管理内容:    面容、指纹解锁
 *  控件完成情况: 基本完成
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AuthManager : NSObject

/****************** 授权通知Key ******************/
/** 授权成功*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthSuccess;
/** 授权失败*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthFailed;
/** 授权取消*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthCancel;
/** 输入密码*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthInputPwd;
/** 设备不可用*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthNotAvailable;
/** 设备未设置*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthNotEnrolled;
/** 设备未设置密码*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthPasscodeNotSet;
/** 设备被锁定*/
UIKIT_EXTERN NSString *const kNotificationKeyValidateAuthLocked;
/****************** 授权验证 ******************/

+ (void)validateAuthSetting;
@end
