//
//  PageScrollView.m
//  test
//
//  Created by Xinbo Hong on 2018/6/22.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import "PageScrollView.h"
#import <Masonry.h>
@interface PageScrollView ()<UIScrollViewDelegate>


@property (nonatomic, assign) ScrollViewAligment aligment;
@property (nonatomic, strong) NSArray *itemsArray;
@end

@implementation PageScrollView

#pragma mark - **************** 初始化
- (instancetype)initWithFrame:(CGRect)frame
                     Aligment:(ScrollViewAligment)aligment
                    ItemWidth:(CGFloat)itemWidth
                         Edge:(CGFloat)edge {
    self = [super initWithFrame:frame];
    if (self) {

        self.halfEdge = edge * 0.5;
        self.itemWidth = itemWidth;
        
        CGFloat scrollViewWidth = 2 * self.halfEdge + itemWidth;
        /** 设置 UIScrollView */
        switch (aligment) {
            case ScrollViewAligmentLeft:
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, self.frame.size.height)];
                break;
            case ScrollViewAligmentCenter:
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - scrollViewWidth) / 2, 0, scrollViewWidth , self.frame.size.height)];
                break;
            case ScrollViewAligmentRight:
                self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - scrollViewWidth), 0, scrollViewWidth, self.frame.size.height)];
                break;
        }
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        [self addSubview:self.scrollView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame ItemWidth:(CGFloat)itemWidth Edge:(CGFloat)edge {
    return [self initWithFrame:frame Aligment:ScrollViewAligmentCenter ItemWidth:itemWidth Edge:edge];
}

- (instancetype)initWithItemWidth:(CGFloat)itemWidth Edge:(CGFloat)edge {
    return [self initWithItemWidth:itemWidth Edge:edge Aligment:ScrollViewAligmentCenter];
}

- (instancetype)initWithItemWidth:(CGFloat)itemWidth
                             Edge:(CGFloat)edge
                         Aligment:(ScrollViewAligment)aligment {
    self = [super init];
    if (self) {
        
        self.halfEdge = edge * 0.5;
        self.itemWidth = itemWidth;
        self.aligment = aligment;
        /** 设置 UIScrollView */
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        [self addSubview:self.scrollView];
    }
    
    return self;
}

#pragma mark - **************** 外露接口
- (void)showDataWithBorrowModelArray:(NSArray *)itemsArray FrameType:(NSString *)type {
    self.itemsArray = itemsArray;
    for (int i = 0; i< self.itemsArray.count; i++) {
        //根据model的类型实例化
        UIView *item = [[UIView alloc] init];
        
        [self initSubviewProperty:item Index:i FrameType:type];
    }
    //设置轮播图当前的显示区域
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.itemsArray.count, 0);
}

- (void)initSubviewProperty:(UIView *)view Index:(NSInteger)index FrameType:(NSString *)type {
    view.tag = 1000 + index;
    view.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapOfScrollViewInPageScrollView:)];
    [view addGestureRecognizer:tap];
    
    [self.scrollView addSubview:view];
    
    if ([type isEqualToString:@"frame"]) {
        view.frame = CGRectMake((2 * index + 1) * self.halfEdge + index * (CGRectGetWidth(self.scrollView.frame) - 2 * self.halfEdge), 0, (CGRectGetWidth(self.scrollView.frame) - 2 * self.halfEdge), CGRectGetHeight(self.scrollView.frame));
    } else {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset((2 * index + 1) * self.halfEdge + index * (CGRectGetWidth(self.scrollView.frame) - 2 * self.halfEdge));
            make.top.equalTo(self);
            make.width.mas_equalTo(self.itemWidth);
            make.height.equalTo(self);
        }];
    }
}

- (void)setItemClickBlock:(ScrollViewItemClickBlock)itemClickBlock {
    if (itemClickBlock) {
        _itemClickBlock = itemClickBlock;
    }
}

- (void)setEndBlock:(ScrollViewEndDeceleratingBlock)endBlock {
    if (endBlock) {
        _endBlock = endBlock;
    }
}
#pragma mark - **************** 视图加载和私有事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.endBlock) {
        self.endBlock(scrollView);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.scrollView.frame, CGRectMake(0, 0, 0, 0))) {
        CGFloat scrollViewWidth = 2 * self.halfEdge + self.itemWidth;
        switch (self.aligment) {
            case ScrollViewAligmentLeft: {
                [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                    make.width.mas_equalTo(scrollViewWidth);
                }];
                break;
            }
            case ScrollViewAligmentCenter: {
                [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self);
                    make.centerX.equalTo(self);
                    make.width.mas_equalTo(scrollViewWidth);
                }];
                break;
            }
            case ScrollViewAligmentRight: {
                [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.bottom.equalTo(self);
                    make.width.mas_equalTo(scrollViewWidth);
                }];
                break;
            }
        }
    }
}


- (void)itemTapOfScrollViewInPageScrollView:(UITapGestureRecognizer *)sender {
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (contentSize.width <= width) {
        return;
    }
    
    CGRect frame = sender.view.frame;
    // selItem中点到contentSize左边距离
    CGFloat edgeLeftToItemCenterX = CGRectGetMidX(frame);
    // selItem中点到contentSize右边距离
    CGFloat edgeRightToItemCenterX = contentSize.width - edgeLeftToItemCenterX;
    
    CGFloat targetX = 0.0;
    
    if (edgeLeftToItemCenterX < width / 2.0) {
        //如果selItem中点到左边的距离小于bounds宽度的一半，scrollView滑到最左边
        targetX = 0.0;
    } else if (edgeRightToItemCenterX < width / 2.0) {
        //如果selItem中点到右边的距离小于bounds宽度的一半，scrollView滑到最右边
        targetX = contentSize.width - width - self.halfEdge;
    } else {
        //将selItem置中
        targetX = edgeLeftToItemCenterX - width / 2.0;
    }
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    
    if (self.itemClickBlock) {
        self.itemClickBlock(sender.view.tag - 1000);
    }
}


- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event {//这边根据需求自己改写
    UIView *view = [super hitTest:point withEvent:event];
    
    if ([view isEqual:self]) {
        for (UIView *subview in self.scrollView.subviews) {
            CGPoint offset = CGPointMake(point.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x - subview.frame.origin.x,
                                         point.y - self.scrollView.frame.origin.y + self.scrollView.contentOffset.y - subview.frame.origin.y);
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return self.scrollView;
    }
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
