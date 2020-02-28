//
//  RectPageControl.m
//  XJPH
//
//  Created by Xinbo Hong on 2018/6/23.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import "CustomPageControl.h"

@interface CustomPageControl ()

@property (nonatomic, assign) CGFloat dotWidth;

@property (nonatomic, assign) CGFloat margin;

@end


@implementation CustomPageControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = false;
    }
    return self;
}

- (void)setDodWidth:(CGFloat)dotWidth margin:(CGFloat)margin {
    self.dotWidth = dotWidth;
    self.margin = margin;
    [self layoutIfNeeded];
}

- (void)setPageImage:(UIImage *)pageImage CurrentPageImage:(UIImage *)currentPageImage {
    [self setValue:pageImage forKeyPath:@"_pageImage"];
    [self setValue:currentPageImage forKeyPath:@"_currentPageImage"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = self.dotWidth + self.margin;
    
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1) * marginX;
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, self.dotWidth, self.frame.size.height)];
        }else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, self.dotWidth, self.frame.size.height)];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
