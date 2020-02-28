//
//  LuaViewController.h
//  XBKit
//
//  Created by Xinbo Hong on 2018/8/16.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShowType) {
    ShowTypeAD = 0, //广告显示页
    ShowTypeNewVersion, //新版本显示页
};

@interface LaunchViewController : UIViewController

- (instancetype)initWithRootVC:(UIViewController *)rootVC viewControllerType:(ShowType)showType;

#pragma mark --- 广告页相关属性 ---
//网络图片
@property (nonatomic, strong) NSString *imageUrl;
//本地图片
@property (nonatomic, strong) NSString *localImageName;

@property (nonatomic, assign) NSTimeInterval adTime;

@property (nonatomic, strong) NSString *adUrl;

@property (nonatomic, assign, getter=isCanSkipAd) BOOL canSkipAd;

#pragma mark --- 新版本显示页 ---
//本地图片
@property (nonatomic, strong) NSArray *imagesLocalArray;
//网络图片
@property (nonatomic, strong) NSArray *imagesURLArray;

@property (nonatomic, strong) UIPageControl *pageControl;

@end
