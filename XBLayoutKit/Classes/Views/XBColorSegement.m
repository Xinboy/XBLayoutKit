//
//  XBColorSegement.m
//  ViewsTestDemo
//
//  Created by Xinbo Hong on 2017/11/30.
//  Copyright © 2017年 X-Core Co,. All rights reserved.
//

#import "XBColorSegement.h"
#import "UIFont+XB_Extension.h"

@interface XBColorSegement ()

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, assign) NSInteger indexCount;

@property (nonatomic, strong) UIView *selectedView;
@end


@implementation XBColorSegement

- (instancetype)initWithFrame:(CGRect)frame TitlesArray:(NSArray *)titlesArray SelectIndexBlock:(SelectIndexBlock)selectedBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.indexCount = titlesArray.count;
        self.titlesArray = titlesArray;
        self.bgColor = [UIColor grayColor];
        self.textColor = [UIColor blackColor];
        self.scrollViewColor = [UIColor orangeColor];
        self.selectBgColor = [UIColor darkGrayColor];
        self.selectTextColor = [UIColor orangeColor];
        self.selectedSegmentIndex = -1;
        if (selectedBlock) {
            self.selectBlock = selectedBlock;
        }
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self initSubviews];
        [self addSubview:self.selectedView];
    }
    return self;
}

- (instancetype)initWithTitlesArray:(NSArray *)titlesArray SelectIndexBlock:(SelectIndexBlock)selectedBlock {
    return [self initWithTitlesArray:titlesArray SelectIndexBlock:selectedBlock];
}

- (void)selectedIndex:(NSInteger)selectIndex {
    if (selectIndex >= 0 && selectIndex < self.indexCount) {
        self.selectedSegmentIndex = selectIndex;
    }
}

- (void)segementButtonActionInXBColorSegement:(UIButton *)sender {
    //目前 self.selectedIndex 还是上一次交互的值
    UIButton *lastButton = [self viewWithTag:101 + self.selectedSegmentIndex];
    lastButton.backgroundColor = self.bgColor;
    lastButton.selected = false;
    
    NSInteger index = sender.tag - 101;
    [self showSelectedStatusWithSelectedIndex:index];
    
    self.selectBlock(index);
}

- (void)showSelectedStatusWithSelectedIndex:(NSInteger)index {
    
    [self selectedIndex:index];
    UIButton *button = [self viewWithTag:101 + self.selectedSegmentIndex];
    button.selected = true;
    button.backgroundColor = self.selectBgColor;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedView.center = CGPointMake(button.center.x, self.selectedView.center.y);
    } completion:^(BOOL finished) {
        self.selectedView.hidden = NO;
    }];
}

- (void)resetSelectedStatus {
    for (int i = 0; i < self.indexCount; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:101 + i];
        button.backgroundColor = self.bgColor;
        self.selectedView.hidden = YES;
    }
    self.selectedSegmentIndex = -1;
}
#pragma mark - **************** Lazy Load
- (void)initSubviews {
    CGFloat itemWidth = CGRectGetWidth(self.frame) / 3;

    
    for (int i = 0; i < self.indexCount; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = CGRectMake(itemWidth * i, 0, itemWidth, CGRectGetHeight(self.frame));
        itemButton.backgroundColor = self.bgColor;
        itemButton.tag = 101 + i;
        [itemButton addTarget:self action:@selector(segementButtonActionInXBColorSegement:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemButton setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [itemButton setTitleColor:self.textColor forState:UIControlStateNormal];
        [itemButton setTitleColor:self.selectTextColor forState:UIControlStateSelected];
        
        itemButton.titleLabel.font = [UIFont boldFontOfAutoSize:15.0];
        [self addSubview:itemButton];
    
        [self addSubview:itemButton];
    }
}

- (void)setScrollViewColor:(UIColor *)scrollViewColor {
    _scrollViewColor = scrollViewColor;
    self.selectedView.backgroundColor = self.scrollViewColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (int i = 0; i < self.indexCount; i++) {
        UIButton *itemButton = [self viewWithTag:101 + i];
        [itemButton setTitleColor:self.textColor forState:UIControlStateNormal];
    }
}

- (void)setSelectTextColor:(UIColor *)selectTextColor {
    _selectTextColor = selectTextColor;
    for (int i = 0; i < self.indexCount; i++) {
        UIButton *itemButton = [self viewWithTag:101 + i];
        [itemButton setTitleColor:self.selectTextColor forState:UIControlStateSelected];
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    for (int i = 0; i < self.indexCount; i++) {
        UIButton *itemButton = [self viewWithTag:101 + i];
        itemButton.backgroundColor = self.bgColor;
    }
}
- (UIView *)selectedView {
    if (!_selectedView) {
        self.selectedView = [[UIView alloc] init];
        self.selectedView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 3, CGRectGetWidth(self.frame) / 3, 3);
        self.selectedView.backgroundColor = self.scrollViewColor;
        self.selectedView.hidden = YES;
    }
    return _selectedView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
