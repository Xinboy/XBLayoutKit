//
//  VerticalLabel.m
//  XBKit
//
//  Created by Xinbo Hong on 2018/6/14.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import "VerticalLabel.h"

@interface VerticalLabel ()

@property (nonatomic, assign) CGFloat leftSpace;

@property (nonatomic, assign) CGFloat verticalSpace;

@end


@implementation VerticalLabel

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftSpace = 11.0;
        self.verticalSpace = 20.0;
        self.verticalAlignment = TextVerticalAlignmentMiddle;
    }
    return self;
}

#pragma mark - --- 公开方法 ---
- (void)setVerticalAlignment:(TextVerticalAlignment)textVerticalAlignment
                   leftSpace:(CGFloat)leftSpace
                 verticalSpace:(CGFloat)verticalSpace {
    self.verticalAlignment = textVerticalAlignment;
    self.leftSpace = leftSpace;
    self.verticalSpace = verticalSpace;
    [self setNeedsDisplay];
}


- (void)setVerticalAlignment:(TextVerticalAlignment)textVerticalAlignment
               textAlignment:(NSTextAlignment)alignment {
    self.verticalAlignment = textVerticalAlignment;
    self.textAlignment = alignment;
    [self setNeedsDisplay];
}

#pragma mark - --- 私有方法 ---
- (void)setVerticalAlignment:(TextVerticalAlignment)textVerticalAlignment {
    _textVerticalAlignment = textVerticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.textVerticalAlignment) {
        case TextVerticalAlignmentTop:
            textRect.origin.y = self.bounds.origin.y + self.verticalSpace;
            break;
        case TextVerticalAlignmentMiddle:
            break;
        case TextVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height - self.verticalSpace;
            break;
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
    }
    textRect.origin.x = self.bounds.origin.x + self.leftSpace;
    
    return textRect;
    
}

- (void)drawTextInRect:(CGRect)rect{
    
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
    [super drawTextInRect:actualRect];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
