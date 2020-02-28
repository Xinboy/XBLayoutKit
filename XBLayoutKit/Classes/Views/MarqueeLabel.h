//
//  MarqueeLabel.h
//  XBKit
//
//  Created by Xinbo Hong on 2019/9/18.
//  Copyright © 2019 Xinbo. All rights reserved.
//

/*
 *  控件名称: 简单跑马灯标签
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarqueeLabel : UIView

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIFont *font;
@end

NS_ASSUME_NONNULL_END
