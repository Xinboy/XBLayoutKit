//
//  PwdTextField.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2017/12/26.
//  Copyright © 2017年 X-Core Co,. All rights reserved.
//

#import "PwdTextField.h"

#import <Masonry/Masonry.h>
@interface PwdTextField () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *numberArray;

@property (nonatomic, copy) InputToCountAction action;

@property (nonatomic, assign) NSInteger currentNum;

@end


@implementation PwdTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberCount = 6;
        self.numberSpace = 10;
        
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor clearColor];
        self.tintColor = [UIColor clearColor];
        self.delegate = self;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.keyboardType = UIKeyboardTypeNumberPad;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        if (!(CGRectIsEmpty(frame) || CGRectIsNull(frame))) {
            [self setupPwdTextFieldWithNumberCount:self.numberCount NumberSpace:self.numberSpace];
        }

    }
    return self;
    
}

- (instancetype)init {
    return [self initWithFrame:CGRectNull];
}

- (void)setupPwdTextFieldWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space {
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    if (count) {
        self.numberCount = count;
    }
    
    if (space) {
        self.numberSpace = space;
    }
    
    CGFloat lineWidth = (CGRectGetWidth(self.frame) - self.numberSpace * (self.numberCount - 1)) / self.numberCount;
    
    UIView *lastView = nil;
    for (int i = 0; i < self.numberCount; i++) {
        
        //Bottom location line
        UIView *bottomLine = [[UIView alloc] init];
//        bottomLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
        //Show number's label
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.center = CGPointMake(bottomLine.center.x, CGRectGetHeight(self.frame) / 2);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:36];
        numberLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:bottomLine];
        [self addSubview:numberLabel];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(self.numberSpace);
            } else {
                make.left.mas_equalTo(self.mas_left);
            }
            make.top.equalTo(self).offset(39);
            make.width.mas_equalTo(lineWidth);
            make.height.mas_equalTo(1);
        }];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomLine);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(self.mas_height);
            make.width.equalTo(bottomLine);
        }];
        lastView = bottomLine;
        [self.numberArray addObject:numberLabel];
    }
}

- (void)textFieldDidChange:(UITextField *)sender {
    for (int i = 0; i < self.text.length; i++) {
        self.currentNum++;
        ((UILabel *)[self.numberArray objectAtIndex:i]).text = [self.text substringWithRange:NSMakeRange(i, 1)];
    }
    if (self.text.length == self.numberCount) {
        [self resignFirstResponder];
        if (self.action) {
            self.action();
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        // 按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        // 判断是不是删除键
        self.currentNum = self.currentNum - 1;
        ((UILabel *)[self.numberArray objectAtIndex:self.currentNum]).text = @"";
        return YES;
    } else if(textField.text.length >= self.numberCount) {
        // 输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，后面禁止输入则忽略输入");
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - **************** Getter and setter
- (NSMutableArray *)numberArray {
    if (!_numberArray) {
        self.numberArray = [NSMutableArray array];
    }
    return _numberArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
