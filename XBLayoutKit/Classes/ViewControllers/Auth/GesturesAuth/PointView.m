//
//  PointView.m
//  pydx
//
//  Created by Xinbo Hong on 2020/2/18.
//  Copyright © 2020年 Xinbo Hong. All rights reserved.
//

#import "PointView.h"

@interface PointView ()

@property (nonatomic, strong) CAShapeLayer *contentLayer;

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@property (nonatomic, strong) CAShapeLayer *centerLayer;

@property (nonatomic, copy, readwrite) NSString *ID;

@end

@implementation PointView

- (instancetype)initWithFrame:(CGRect)frame WithID:(NSString *)ID {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.ID = ID;
    
        //内部颜色Layer
        [self.layer addSublayer:self.contentLayer];
        //边框颜色Layer
        [self.layer addSublayer:self.borderLayer];
        //选择颜色Layer
        [self.layer addSublayer:self.centerLayer];
        
        //默认为未选中，隐藏选择颜色Layer
        self.centerLayer.hidden = YES;
//        self.selectedColor = [self colorForRed:30.0 green:180.0 blue:244.0 alpha:1.0];
        
        self.successColor = [self colorForRed:43.0 green:210.0 blue:11.0 alpha:1.0];
        self.errorColor = [self colorForRed:222.0 green:64.0 blue:60.0 alpha:1.0];
        self.fillColor = [self colorForRed:249.0 green:249.0 blue:249.0 alpha:1.0];
        
    }
    return self;
}


- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.centerLayer.fillColor = _selectedColor.CGColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.contentLayer.fillColor = _fillColor.CGColor;
}

- (UIColor *)colorForRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

#pragma mark - **************** Getter and setter
//根据情况显示三种状态
- (void)setSuccess:(BOOL)success {
    _success = success;
    if (self.isSuccess) {
        
        self.centerLayer.fillColor = self.successColor.CGColor;
    } else {
        self.centerLayer.fillColor = self.selectedColor.CGColor;
    }
}

- (void)setError:(BOOL)error {
    _error = error;
    if (self.isError) {
        self.centerLayer.fillColor = self.errorColor.CGColor;
    } else {
        self.centerLayer.fillColor = self.selectedColor.CGColor;
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (self.isSelected) {
        self.centerLayer.fillColor = self.selectedColor.CGColor;
        self.centerLayer.hidden = NO;
    } else {
        self.centerLayer.hidden = YES;
    }
}


- (CAShapeLayer *)contentLayer {
    if (!_contentLayer) {
        self.contentLayer = [[CAShapeLayer alloc] init];
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2.0, 2.0, self.bounds.size.width - 4.0, self.bounds.size.height - 4.0) cornerRadius:(self.bounds.size.width - 4.0) / 2.0];
        self.contentLayer.path = path.CGPath;
        self.contentLayer.fillColor = self.fillColor.CGColor;
        self.contentLayer.lineWidth = 2;
        self.contentLayer.cornerRadius = self.bounds.size.width / 2.0;
    }
    return _contentLayer;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        self.borderLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0) radius:self.bounds.size.width / 2.0 startAngle:0 endAngle:2 * M_PI clockwise:NO];
        self.borderLayer.path = path.CGPath;
        //边框颜色
        self.borderLayer.strokeColor = [UIColor colorWithWhite:168 / 255.0 alpha:1.0].CGColor;
        self.borderLayer.fillColor = self.contentLayer.fillColor;
        self.borderLayer.lineWidth = 2;
    }
    return _borderLayer;
}

- (CAShapeLayer *)centerLayer {
    if (!_centerLayer) {
        self.centerLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width / 2.0 - (self.bounds.size.width - 4.0) / 4.0, self.bounds.size.height / 2.0 - (self.bounds.size.height - 4.0) / 4.0, (self.bounds.size.width - 4.0) / 2.0, (self.bounds.size.height - 4.0) / 2.0) cornerRadius:(self.bounds.size.width - 4.0) / 2.0];
        self.centerLayer.path = path.CGPath;
        self.centerLayer.fillColor = self.selectedColor.CGColor;
    }
    return _centerLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
