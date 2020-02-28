//
//  RateStarView.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/5/17.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "RateStarView.h"
#import <MAsonry/Masonry.h>

static NSString *const kForegroundStarImageName = @"icon_star_yellow";
static NSString *const kBackgroundStarImageName = @"icon_star_gray";

@interface RateStarView ()

@property (nonatomic, strong) UIView *bgStarView;

@property (nonatomic, strong) UIView *fgStarView;

@property (nonatomic, assign) NSInteger numberOfStars;

@property (nonatomic, assign) CGFloat currentScore;

@property (nonatomic, copy) CompleteBlock completeBlock;

@property (nonatomic, assign, getter=isMasonryLayout) BOOL masonryLayout;

@end

@implementation RateStarView


#pragma mark - --- Frame---
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.masonryLayout = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRateStarActionWithTapGestureRecognizer:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)frameWithNumberOfStars:(NSInteger)numberOfStars
rateStyle:(RateStarStyle)rateStyle
isAnination:(BOOL)isAnimation
finish:(CompleteBlock)finishBlock {
    
    self.rateStyle = rateStyle;
    self.animation = isAnimation;
    if (finishBlock) {
        self.completeBlock = finishBlock;
    }
    [self creatStarView];
    [self frameStarView];
}

- (void)frameWithNumberOfStars:(NSInteger)numberOfStars {
    return [self frameWithNumberOfStars:numberOfStars rateStyle:RateStarStyleIncomplete isAnination:true finish:nil];
}

- (void)frameStarView {
    
    NSArray *fgSubviews = [self.fgStarView subviews];
    for (int i = 0; i < fgSubviews.count; i++) {
        UIImageView *imageView = [fgSubviews[i] isKindOfClass:[UIImageView class]] ? fgSubviews[i]:nil;
        if (imageView) {
            imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        }
    }
    
    NSArray *bgSubviews = [self.bgStarView subviews];
    for (int i = 0; i < bgSubviews.count; i++) {
        UIImageView *imageView = [fgSubviews[i] isKindOfClass:[UIImageView class]] ? fgSubviews[i]:nil;
        if (imageView) {
            imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        }
    }
    self.fgStarView.frame = CGRectMake(0, 0, self.bounds.size.width * self.currentScore / self.numberOfStars, self.bounds.size.height);
}

#pragma mark - --- Masonry ---
- (instancetype)init {
    self = [super init];
    if (self) {
        self.masonryLayout = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRateStarActionWithTapGestureRecognizer:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)masonryWithNumberOfStars:(NSInteger)numberOfStars
rateStyle:(RateStarStyle)rateStyle
isAnination:(BOOL)isAnimation
finish:(CompleteBlock)finishBlock {
    self.rateStyle = rateStyle;
    self.animation = isAnimation;
    if (finishBlock) {
        self.completeBlock = finishBlock;
    }
    [self creatStarView];
    [self masonryStarView];
}

- (void)masonryWithNumberOfStars:(NSInteger)numberOfStars {
    return [self masonryWithNumberOfStars:numberOfStars rateStyle:RateStarStyleIncomplete isAnination:true finish:nil];
}

- (void)masonryStarView {
    [super layoutIfNeeded];
    [self layoutSubviews];
    
    NSArray *fgSubviews = [self.fgStarView subviews];
    for (int i = 0; i < fgSubviews.count; i++) {
        UIImageView *imageView = [fgSubviews[i] isKindOfClass:[UIImageView class]] ? fgSubviews[i]:nil;
        if (imageView) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.fgStarView).offset(i * self.bounds.size.width / self.numberOfStars);
                make.top.equalTo(self.fgStarView);
                make.width.mas_equalTo(self.bounds.size.width / self.numberOfStars);
                make.height.equalTo(self.fgStarView);
            }];
        }
    }
    NSArray *bgSubviews = [self.bgStarView subviews];
    for (int i = 0; i < bgSubviews.count; i++) {
        UIImageView *imageView = [bgSubviews[i] isKindOfClass:[UIImageView class]] ? bgSubviews[i]:nil;
        if (imageView) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgStarView).offset(i * self.bounds.size.width / self.numberOfStars);
                make.top.equalTo(self.bgStarView);
                make.width.mas_equalTo(self.bounds.size.width / self.numberOfStars);
                make.height.equalTo(self.bgStarView);
            }];
        }
    }
    [self.fgStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(self.bounds.size.width * self.currentScore / self.numberOfStars);
        make.height.equalTo(self);
    }];
}

#pragma mark - --- 视图公共部分 ---
- (void)creatStarView {
    self.fgStarView = [self starViewWithImageName:kForegroundStarImageName];
    self.bgStarView = [self starViewWithImageName:kBackgroundStarImageName];
    
    
    [self addSubview:self.bgStarView];
    [self addSubview:self.fgStarView];
}

- (UIView *)starViewWithImageName:(NSString *)imageName {
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.clipsToBounds = true;
    bgView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < self.numberOfStars; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        starImageView.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:starImageView];
    }
    return bgView;
}

#pragma mark - --- 私有方法 ---


- (void)showRateStarActionWithTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    CGFloat offset = point.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    switch (self.rateStyle) {
        case RateStarStyleIncomplete: {
            self.currentScore = ceil(realStarScore);
            break;
        }
        case RateStarStyleWhole: {
            self.currentScore = roundf(realStarScore) > realStarScore ? ceil(realStarScore) : (ceil(realStarScore) - 0.5);
            break;
        }
        case RateStarStyleHalf: {
            self.currentScore = realStarScore;
            break;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak RateStarView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0.0;
    
    if (self.isMasonryLayout) {
        [UIView animateWithDuration:animationTimeInterval animations:^{
            [weakSelf.fgStarView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(weakSelf.bounds.size.width * weakSelf.currentScore / self.numberOfStars);
            }];
        }];
    } else {
        [UIView animateWithDuration:animationTimeInterval animations:^{
            weakSelf.fgStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.currentScore / self.numberOfStars, weakSelf.bounds.size.height);
        }];
    }
    
}

- (void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    if (self.completeBlock) {
        self.completeBlock(_currentScore);
    }
    
    [self setNeedsLayout];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
