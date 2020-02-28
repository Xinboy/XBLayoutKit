//
//  PageScrollView.h
//  test
//
//  Created by Xinbo Hong on 2018/6/22.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollViewAligment) {
    ScrollViewAligmentLeft = 0,
    ScrollViewAligmentCenter,
    ScrollViewAligmentRight,
};

typedef void(^ScrollViewItemClickBlock)(NSInteger index);
typedef void(^ScrollViewEndDeceleratingBlock)(UIScrollView *scrollView);



@interface PageScrollView : UIView

@property (nonatomic, copy) ScrollViewItemClickBlock itemClickBlock;

@property (nonatomic, copy) ScrollViewEndDeceleratingBlock endBlock;

@property (nonatomic, strong) UIScrollView *scrollView;
//图片间距的一半
@property (nonatomic, assign) CGFloat halfEdge;
@property (nonatomic, assign) CGFloat itemWidth;
/**
 初始化，默认居中
 @param frame 设置View大小
 @param itemWidth 子视图的宽
 @param edge 设置Scroll内部 子空间间距
 @return 初始化返回值
 */
- (instancetype)initWithFrame:(CGRect)frame
                    ItemWidth:(CGFloat)itemWidth
                         Edge:(CGFloat)edge;

/**
 初始化
 @param frame 设置View大小
 @param aligment scrollview的距离
 @param itemWidth 子视图的宽
 @param edge 设置Scroll内部 子空间间距
 @return 初始化返回值
 */
- (instancetype)initWithFrame:(CGRect)frame
                     Aligment:(ScrollViewAligment)aligment
                    ItemWidth:(CGFloat)itemWidth
                         Edge:(CGFloat)edge;

/**
 初始化，默认居中
 @param itemWidth 子视图的宽
 @param edge 设置Scroll内部 子空间间距
 @return 初始化返回值
 */
- (instancetype)initWithItemWidth:(CGFloat)itemWidth
                             Edge:(CGFloat)edge;

/**
 初始化，默认居中
 @param itemWidth 子视图的宽
 @param aligment scrollview的距离
 @param edge 设置Scroll内部 子空间间距
 @return 初始化返回值
 */
- (instancetype)initWithItemWidth:(CGFloat)itemWidth
                             Edge:(CGFloat)edge
                         Aligment:(ScrollViewAligment)aligment;

#pragma mark - **************** 根据具体的subview进行实例化
- (void)showDataWithBorrowModelArray:(NSArray *)itemsArray FrameType:(NSString *)type;
@end
