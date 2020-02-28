//
//  PointView.h
//  pydx
//
//  Created by Xinbo Hong on 2020/2/18.
//  Copyright © 2020年 Xinbo Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointView : UIView

@property (nonatomic, copy, readonly) NSString *ID;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign, getter=isError) BOOL error;

@property (nonatomic, assign, getter=isSuccess) BOOL success;

/// 选中色
@property (nonatomic, strong) UIColor *selectedColor;
/// 错误色
@property (nonatomic, strong) UIColor *errorColor;
/// 成功色
@property (nonatomic, strong) UIColor *successColor;
/// 底色
@property (nonatomic, strong) UIColor *fillColor;

- (instancetype)initWithFrame:(CGRect)frame WithID:(NSString *)ID;

@end
