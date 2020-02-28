//
//  CarouselScrollView.m
//  CarouselScorllView
//
//  Created by Xinbo Hong on 2018/2/22.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import "CarouselScrollView.h"
#import <Masonry.h>

#define CAROUSE_INDEX_CALCULATE(x,y) (x+y)%y  //计算循环索引

NS_INLINE NSTimeInterval kDefaultDurationTime() {
    return 2.0f;
}

NS_INLINE CGRect kDefaultDurationFrame() {
    return CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/4);
}

@interface CarouselScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIScrollView *containerScrollView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) NSInteger currentNumber;
@end

@implementation CarouselScrollView

- (void)clickResponse
{
    if ([self.delegate respondsToSelector:@selector(clickResponseWithIndex:)]) {
        [self.delegate clickResponseWithIndex:self.currentNumber];
    }else {
        NSLog(@"did not realize the id<CCCycleScrollViewClickActionDeleage>delegate");
    }
}

#pragma mark - **************** 初始化相关方法
- (instancetype)initWithImages:(NSArray *)images {
    return [self initWithImages:images withFrame:kDefaultDurationFrame()];
}

- (instancetype)initWithImages:(NSArray *)images withFrame:(CGRect)frame {
    return [self initWithImages:images withFrame:frame pageLocation:CarouselPageControlPositionCenter PageChangeTime:kDefaultDurationTime()];
}

- (instancetype)initWithImages:(NSArray *)images
                     withFrame:(CGRect)frame
                  pageLocation:(CarouselPageControlPosition)pageLocation
                PageChangeTime:(NSTimeInterval)changeTime {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.imagesArray = [NSArray arrayWithArray:images];
        self.pageLocation = pageLocation;
        self.carouselIntervalTime = changeTime;
        self.currentNumber = 0;
        
        [self initSubviewsMasonryConfig];
        [self initPageControlCongfig];
        [self changeImageView];
        [self pageControlPosition:pageLocation];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(clickResponse)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

/** 设置子视图位置*/
- (void)initSubviewsMasonryConfig {
    
    [self addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.leftImageView];
    [self.containerScrollView addSubview:self.centerImageView];
    [self.containerScrollView addSubview:self.rightImageView];
    
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.equalTo(self);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right);
        make.top.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerImageView.mas_right);
        make.right.top.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
}

/** 设置小圆点属性*/
- (void)initPageControlCongfig {
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.imagesArray.count;
    
    [self addSubview:self.pageControl];

    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
}

/** 初始化NSTimer对象*/
- (void)initTimer {
    self.timer = [NSTimer timerWithTimeInterval:self.carouselIntervalTime target:self selector:@selector(carouseImagesWithIntervalTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - **************** 私有方法
/** 根据枚举修改小圆点的位置*/
- (void)pageControlPosition:(CarouselPageControlPosition)pageLocation {
    switch (pageLocation) {
        case CarouselPageControlPositionLeft: {
            [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(50);
            }];
            break;
        }
        case CarouselPageControlPositionCenter: {
            [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
            }];
            break;
        }
        case CarouselPageControlPositionRight: {
            [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-50);
            }];
        break;
        }
    }
}

/** 轮播图片*/
- (void)carouseImagesWithIntervalTime {
    if (self.imagesArray.count == 0) {
        NSLog(@"Error:images is empty!");
        return;
    }
    self.currentNumber = CAROUSE_INDEX_CALCULATE(self.currentNumber + 1, self.imagesArray.count);
    
    self.pageControl.currentPage = self.currentNumber;
    [self changeImageView];
    
    [self.containerScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.containerScrollView.frame), 0) animated:YES];
    self.containerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.containerScrollView.frame), 0);
}

/** 图片轮动*/
- (void)changeImageView {
    if (self.imagesArray.count == 0) {
        NSLog(@"Error:images is empty!");
        return;
    }
    NSInteger tempIndex = 0;
    
    //重设图片的内容
    tempIndex = CAROUSE_INDEX_CALCULATE(self.currentNumber, self.imagesArray.count);
    self.centerImageView.image = [UIImage imageNamed:self.imagesArray[tempIndex]];
    
    tempIndex = CAROUSE_INDEX_CALCULATE(self.currentNumber - 1, self.imagesArray.count);
    self.leftImageView.image = [UIImage imageNamed:self.imagesArray[tempIndex]];
    
    tempIndex = CAROUSE_INDEX_CALCULATE(self.currentNumber + 1, self.imagesArray.count);
    self.rightImageView.image = [UIImage imageNamed:self.imagesArray[tempIndex]];
    
}
#pragma mark - **************** ScrollView  Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self initTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = [self.containerScrollView contentOffset];
    if (offset.x == CGRectGetWidth(self.containerScrollView.frame) * 2) {
        self.currentNumber = CAROUSE_INDEX_CALCULATE(self.currentNumber + 1,self.imagesArray.count);
    } else if (offset.x == 0) {
        self.currentNumber = CAROUSE_INDEX_CALCULATE(self.currentNumber - 1,self.imagesArray.count);
    } else {
        return;
    }
    self.pageControl.currentPage = self.currentNumber;
    [self changeImageView];
    self.containerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.containerScrollView.frame), 0);
}
#pragma mark - **************** Setter 方法
- (void)setPageLocation:(CarouselPageControlPosition)pageLocation {
    [self pageControlPosition:pageLocation];
}

- (void)setCarouselIntervalTime:(NSTimeInterval)carouselIntervalTime {
    _carouselIntervalTime = carouselIntervalTime;
    [self.timer invalidate];
    [self initTimer];
}
#pragma mark - **************** Lazy Load
- (UIScrollView *)containerScrollView {
    if (!_containerScrollView) {
        self.containerScrollView = [[UIScrollView alloc] init];
        self.containerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, CGRectGetHeight(self.frame));
        self.containerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        self.containerScrollView.backgroundColor = [UIColor grayColor];
        self.containerScrollView.scrollEnabled = YES;
        self.containerScrollView.showsHorizontalScrollIndicator = NO;
        self.containerScrollView.showsVerticalScrollIndicator = NO;
        self.containerScrollView.pagingEnabled = YES;
        self.containerScrollView.delegate = self;
        
    }
    return _containerScrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        self.leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        self.centerImageView = [[UIImageView alloc] init];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        self.rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
