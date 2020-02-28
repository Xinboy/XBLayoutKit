//
//  MidTabBar.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/4/10.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "MidProminentTabBar.h"


@interface MidProminentTabBar ()

@end

@implementation MidProminentTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMidButton];
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage new]];
    }
    return self;
}

- (void)initMidButton {
    self.midButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"tabbar_add"];
    self.midButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.midButton setImage:image forState:UIControlStateNormal];
    self.midButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - image.size.width)/2.0, - image.size.height/2.0, image.size.width, image.size.height);
    self.midButton.adjustsImageWhenHighlighted = NO;    
    
    [self addSubview:self.midButton];
}

/** 处理超出区域点击无效的问题*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempPoint = [self.midButton convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.midButton.bounds, tempPoint)) {
            return self.midButton;
        }
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
