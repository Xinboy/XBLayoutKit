//
//  MarqueeLabel.m
//  XBKit
//
//  Created by Xinbo Hong on 2019/9/18.
//  Copyright © 2019 Xinbo. All rights reserved.
//

#import "MarqueeLabel.h"

@interface MarqueeLabel()

@property (nonatomic, strong) UILabel *firstLabel;

@property (nonatomic, strong) UILabel *lastLabel;

@end

@implementation MarqueeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.firstLabel];
        
        [self addSubview:self.lastLabel];
    }
    return self;
    
}


- (void)beginMarquee:(NSTimeInterval)duration {
    CGRect firstFrame = self.firstLabel.frame;
    CGRect lastFrame = self.lastLabel.frame;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.firstLabel.frame = CGRectMake(-self.firstLabel.frame.size.width, self.firstLabel.frame.origin.y, self.firstLabel.frame.size.width, self.firstLabel.frame.size.height);
        self.lastLabel.frame = CGRectMake(0, self.lastLabel.frame.origin.y, self.lastLabel.frame.size.width, self.lastLabel.frame.size.height);
    } completion:^(BOOL finished) {
        self.firstLabel.frame = firstFrame;
        self.lastLabel.frame = lastFrame;
        [self beginMarquee:duration];
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    
    self.firstLabel.frame = self.bounds;
    
    self.lastLabel.frame = CGRectMake(CGRectGetMaxX(self.firstLabel.frame), 0, CGRectGetWidth(self.firstLabel.frame), CGRectGetHeight(self.firstLabel.frame));
}

- (void)setText:(NSString *)text {
    self.text = text;
    self.firstLabel.text = self.lastLabel.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.textAlignment = textAlignment;
    self.firstLabel.textAlignment = self.lastLabel.textAlignment = self.textAlignment;
}

- (void)setFont:(UIFont *)font {
    self.font = font;
    self.firstLabel.font = self.lastLabel.font = self.font;
}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        self.firstLabel = [[UILabel alloc] init];
    }
    return _firstLabel;
}

- (UILabel *)lastLabel {
    if (!_lastLabel) {
        self.lastLabel = [[UILabel alloc] init];
    }
    return _lastLabel;
}
@end
