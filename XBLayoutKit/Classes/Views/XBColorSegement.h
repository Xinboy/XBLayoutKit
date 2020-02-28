//
//  XBColorSegement.h
//  ViewsTestDemo
//
//  Created by Xinbo Hong on 2017/11/30.
//  Copyright © 2017年 X-Core Co,. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectIndexBlock)(NSInteger selectIndex);

@interface XBColorSegement : UIView
/** 默认背景色*/
@property (nonatomic, strong) UIColor *bgColor;
/** 默认文本色*/
@property (nonatomic, strong) UIColor *textColor;
/** 选中item的下标背景色*/
@property (nonatomic, strong) UIColor *scrollViewColor;
/** 选中item的背景色*/
@property (nonatomic, strong) UIColor *selectBgColor;
/** 选中item的文本色*/
@property (nonatomic, strong) UIColor *selectTextColor;

@property (nonatomic, copy) SelectIndexBlock selectBlock;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;


/**
 初始化 Segement

 @param frame Segement的 frame
 @param titlesArray Segement每个 item 显示的文字
 @param selectedBlock 点击 item 响应的外部时间
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame TitlesArray:(NSArray *)titlesArray SelectIndexBlock:(SelectIndexBlock)selectedBlock;

- (instancetype)initWithTitlesArray:(NSArray *)titlesArray SelectIndexBlock:(SelectIndexBlock)selectedBlock;
/**
 对selectedSegmentIndex 赋值；0 - (titlesArray.count - 1)之间

 @param selectIndex 赋值参数
 */
- (void)selectedIndex:(NSInteger)selectIndex;

/**
 复原 Segement状态
 */
- (void)resetSelectedStatus;
@end
