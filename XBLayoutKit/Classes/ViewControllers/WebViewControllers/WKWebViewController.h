//
//  WKWebViewController.h
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2017/12/28.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.
//

/*
 *  控件名称:    封装wkWebView控制器
 *  控件完成情况: 进行了部分优化
 *  最后记录时间: 2018/5/25
 */

#import <UIKit/UIKit.h>

typedef void(^pushNewInterfaceBlock)(void);

@interface WKWebViewController : UIViewController

/* url字符串*/
@property (nonatomic, strong) NSString *url;
/* html字符串*/
@property (nonatomic, strong) NSString *html;
/* 本地HTML文件的路径*/
@property (nonatomic, strong) NSString *localHtmlPath;

@property (nonatomic, assign, getter = isCanDownRefresh) BOOL canDownRefresh;

/** 根据后台返回的值，跳转到对应的界面 */
@property (nonatomic, copy) pushNewInterfaceBlock pushBlock;


/**
 将html字符串保存为本地到手机本地，然后将w

 @param html <#html description#>
 */
- (void)loadHtmlString:(NSString *)html;
@end
