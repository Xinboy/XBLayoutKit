//
//  PwdTextField.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2017/12/26.
//  Copyright © 2017年 X-Core Co,. All rights reserved.
//

#import "PasswordView.h"

#import "Masonry.h"
@interface PasswordView () <UITextFieldDelegate>

//装入数字控件
@property (nonatomic, assign) PasswordViewType type;
//装入数字控件
@property (nonatomic, strong) NSMutableArray *numberArray;
//当前输入的位数
@property (nonatomic, assign) NSInteger currentNum;
//密码个数
@property (nonatomic, assign) NSInteger numberCount;
//密码之间的间距
@property (nonatomic, assign) CGFloat numberSpace;
//是否显示密码
@property (nonatomic, assign, getter = isSecureText) BOOL secureText;


@end


@implementation PasswordView

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
        
//        if (!CGRectIsNull(frame) && !CGRectIsInfinite(frame)) {
//            [self frameWithNumberCount:self.numberCount NumberSpace:self.numberSpace SecureText:NO];
//        }

    }
    return self;
    
}

- (instancetype)init {
    return [self initWithFrame:CGRectNull];
}


#pragma mark - --- Frame视图创建 ---
- (void)frameWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space SecureText:(BOOL)isSecureText {
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    if (count) {
        self.numberCount = count;
    }
    self.numberSpace = space;
    self.secureText = isSecureText;
    
    CGFloat labelWidth = (CGRectGetWidth(self.frame) - self.numberSpace * (self.numberCount - 1)) / self.numberCount;
    
    for (int i = 0; i < self.numberCount; i++) {
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.numberSpace + labelWidth) * i, 0, labelWidth, CGRectGetHeight(self.frame))];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:numberLabel];
        
        [self.numberArray addObject:numberLabel];
    }
}

- (void)frameWithType:(PasswordViewType)type {
    self.type = type;
    
    for (int i = 0; i < self.numberCount; i++) {
        UIView *view = [[UIView alloc] init];
        view.tag = 1000 + i;
        //点到框中能够弹出键盘
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFeildResponse)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        
        UILabel *temp = self.numberArray[i];
        switch (type) {
            case PasswordViewTypeBottomLine: {
                view.frame = CGRectMake(CGRectGetMinX(temp.frame), CGRectGetMaxY(temp.frame) - 1, CGRectGetWidth(temp.frame), 1);
                //设置底线的颜色，默认为灰色
                view.backgroundColor = [UIColor grayColor];
                break;
            }
            case PasswordViewTypeSeparateField: {
                view.frame = CGRectMake(CGRectGetMinX(temp.frame), CGRectGetMinY(temp.frame), CGRectGetWidth(temp.frame), CGRectGetHeight(temp.frame));
                //设置密码框的底色，默认为白色
                view.backgroundColor = [UIColor whiteColor];
                //设置密码框的边框，默认为1宽度的灰色
                view.layer.borderColor = [UIColor grayColor].CGColor;
                view.layer.borderWidth = 1.0;
                [self sendSubviewToBack:view];
                break;
            }
            case PasswordViewTypeSeparateLine: {
                if (i == self.numberCount - 1) {
                    //最后一个分割线不需要
                    [view removeFromSuperview];
                    break;
                }
                CGFloat width = 1;
                view.frame = CGRectMake(CGRectGetMaxX(temp.frame) - width * 0.5, CGRectGetMinY(temp.frame), 1, CGRectGetHeight(temp.frame));
                //设置分割线颜色，默认为灰色
                view.backgroundColor = [UIColor grayColor];
                self.layer.borderColor = [UIColor grayColor].CGColor;
                self.layer.borderWidth = 1.0;
                break;
            }
        }
    }
}



#pragma mark - --- Masonry视图创建 ---
- (void)masonryWithNumberCount:(CGFloat)count NumberSpace:(CGFloat)space  SecureText:(BOOL)isSecureText {
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    if (count) {
        self.numberCount = count;
    }
    self.numberSpace = space;
    self.secureText = isSecureText;
    
    [self layoutIfNeeded];
    
    CGFloat labelWidth = (CGRectGetWidth(self.frame) - self.numberSpace * (self.numberCount - 1)) / self.numberCount;
    
    for (int i = 0; i < self.numberCount; i++) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(i * (labelWidth + self.numberSpace));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(labelWidth);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        [self.numberArray addObject:numberLabel];
    }
    
}

- (void)masonryWithType:(PasswordViewType)type {
    self.type = type;
    
    for (int i = 0; i < self.numberCount; i++) {
        UIView *view = [[UIView alloc] init];
        view.tag = 1000 + i;
        //点到框中能够弹出键盘
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFeildResponse)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        
        UILabel *temp = self.numberArray[i];
        switch (type) {
            case PasswordViewTypeBottomLine: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(temp);
                    make.top.equalTo(temp.mas_bottom).offset(-1);
                    make.width.equalTo(temp);
                    make.height.mas_equalTo(1);
                }];
                //设置底线的颜色，默认为灰色
                view.backgroundColor = [UIColor grayColor];
                break;
            }
            case PasswordViewTypeSeparateField: {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(temp);
                    make.top.equalTo(temp);
                    make.width.equalTo(temp);
                    make.height.equalTo(temp);
                }];
                //设置密码框的底色，默认为白色
                view.backgroundColor = [UIColor whiteColor];
                //设置密码框的边框，默认为1宽度的灰色
                view.layer.borderColor = [UIColor grayColor].CGColor;
                view.layer.borderWidth = 1.0;
                [self sendSubviewToBack:view];
                break;
            }
            case PasswordViewTypeSeparateLine: {
                if (i == self.numberCount - 1) {
                    //最后一个分割线不需要
                    [view removeFromSuperview];
                    break;
                }
                CGFloat width = 1;
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(temp.mas_right).offset(-width * 0.5);
                    make.top.equalTo(temp);
                    make.width.mas_equalTo(1);
                    make.height.equalTo(temp);
                }];
                //设置分割线颜色，默认为灰色
                view.backgroundColor = [UIColor grayColor];
                self.layer.borderColor = [UIColor grayColor].CGColor;
                self.layer.borderWidth = 1.0;
                break;
            }
        }
    }
}

#pragma mark - --- Function ---
- (void)clearUpPassword {
    self.text = @"";
    [self textFieldDidChange:self];
}

- (void)textFeildResponse {
    [self becomeFirstResponder];
}
#pragma mark - --- Delegate ---

- (void)textFieldDidChange:(UITextField *)sender {
    self.currentNum = self.text.length;
    for (int i = 0; i < self.text.length; i++) {
        if (self.isSecureText) {
            //*
            ((UILabel *)[self.numberArray objectAtIndex:i]).text = @"⦁";
        } else {
            ((UILabel *)[self.numberArray objectAtIndex:i]).text = [self.text substringWithRange:NSMakeRange(i, 1)];
        }
        
    }
    if (self.text.length >= self.numberCount) {
        [self resignFirstResponder];
        
        if (self.action) {
            self.action([sender.text substringToIndex:self.numberCount]);
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

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    for (int i = 0; i < self.numberCount; i++) {
        UIView *line = [self viewWithTag:1000 + i];
        switch (self.type) {
            case PasswordViewTypeBottomLine:
            case PasswordViewTypeSeparateLine:
                line.backgroundColor = lineColor;
                break;
            case PasswordViewTypeSeparateField:
                line.layer.borderColor = lineColor.CGColor;
                break;
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
