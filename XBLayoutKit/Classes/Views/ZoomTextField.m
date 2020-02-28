//
//  LoginTextField.m
//  XJPH
//
//  Created by Xinbo Hong on 2018/6/12.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import "ZoomTextField.h"
#import <Masonry.h>
#import "UIFont+XB_Extension.h"

@interface ZoomTextField ()<UITextFieldDelegate>

/** 占位符字符串*/
@property (nonatomic, strong) NSString *placeholderString;
/** 标题字符串*/
@property (nonatomic, strong) NSString *titleString;
/** 按钮图片字符串*/
@property (nonatomic, strong) NSString *buttonImageName;
/** 占位符颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;
/** 占位符字体*/
@property (nonatomic, strong) UIFont *placeholderFont;

@end

@implementation ZoomTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.placeholderColor = [UIColor colorWithWhite:170.0 / 255.0 alpha:1.0f];
        self.placeholderFont = [UIFont systemFontOfAutoSize:15.0];
        
        [self addSubview:self.inputTextField];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightButton];
        [self addSubview:self.bottomLine];
    
    }
    return self;
}

- (void)changeTitle:(NSString *)title titleColor:(UIColor *)color {
    if (title) {
        self.titleLabel.text = title;
    }
    if (color) {
        self.titleLabel.textColor = color;
    }
}

- (void)setBasePropertyWithTitle:(NSString *)title
                     placeholder:(NSString *)placeholder
                  rightImageName:(NSString *)imageName
               rightButtonAction:(rightButtoAction)block{
    if (title) {
        self.titleString = title;
    }
    if (placeholder) {
        self.placeholderString = placeholder;
    }
    if (imageName) {
        self.buttonImageName = imageName;
        [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.rightButton.hidden = false;
    } else {
        self.rightButton.hidden = true;
    }
    if (block) {
        self.blockAction = block;
    }
    //默认
    self.titleLabel.text = self.placeholderString;

}

- (void)resetTitleLabelToNormalStatus {
    
    self.titleLabel.font = [UIFont systemFontOfAutoSize:13.0];
    self.titleLabel.textColor = [UIColor colorWithWhite:153.0 / 255.0 alpha:1.0f];
    self.titleLabel.text = self.titleString;
}

- (void)setPlaceholderFont:(UIFont *)font Color:(UIColor *)color {
    if (font) {
        self.placeholderFont = font;
    }
    if (color) {
        self.placeholderColor = color;
    }
    [self setTitleLabelWithIsTitle:false];
}


- (void)showDisableStatusWithTitle:(NSString *)title
                              text:(NSString *)text
                    rightImageName:(NSString *)imageName {
    [self setTitleLabelWithIsTitle:true];
    self.titleLabel.text = title;
    self.inputTextField.text = text;
    
    
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.rightButton.hidden = false;
    
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
//    self.titleLabel.textColor = [UIColor colorWithHexInt:0x666666];
//    self.inputTextField.textColor = [UIColor colorWithHexInt:0xAAAAAA];
    self.userInteractionEnabled = false;
}

- (void)showDisableStatusWithTitle:(NSString *)title
                              text:(NSString *)text {
    [self setTitleLabelWithIsTitle:true];
    self.titleLabel.text = title;
    self.inputTextField.text = text;
}

#pragma mark - **************** 私有方法
- (void)setTitleLabelWithIsTitle:(BOOL)isTitle {
    if (isTitle) {
        [self resetTitleLabelToNormalStatus];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.inputTextField.mas_centerY).offset(-20);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.titleLabel.superview layoutIfNeeded];
        }];
    } else {
        self.titleLabel.text = self.placeholderString;
        self.titleLabel.font = self.placeholderFont;
        self.titleLabel.textColor = self.placeholderColor;
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.inputTextField.mas_centerY);
        }];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [self.titleLabel.superview layoutIfNeeded];
        }];
    }
    
}

- (void)titleLabelTapInLoginTextField:(UITapGestureRecognizer *)sender {
    [self.inputTextField becomeFirstResponder];
    [self setTitleLabelWithIsTitle:true];
}

- (void)textFieldValueChangeInLoginTextField:(UITextField *)sender {
    if (sender.text.length > 0 && [self.buttonImageName isEqualToString:@"login_delete"]) {
        self.rightButton.hidden = false;
    } else if (sender.text.length == 0 && [self.buttonImageName isEqualToString:@"login_delete"]) {
        self.rightButton.hidden = true;
    }
}

- (void)rightButtonActionInLoginTextField:(UIButton *)sender {
    if (self.blockAction) {
        self.blockAction(sender);
    }
}
#pragma mark - **************** UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        [self setTitleLabelWithIsTitle:false];
    }
    if (self.endAction) {
        self.endAction(textField.text);
    }
}

#pragma mark - **************** frame
- (void)layoutSubviews {
    [self setNeedsLayout];
    [self setupMasonry];
}

- (void)setupMasonry {
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(25);
        make.bottom.equalTo(self);
    }];
    
    //默认覆盖inputTextField
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputTextField);
        make.centerX.equalTo(self.inputTextField.mas_centerX);
        make.centerY.equalTo(self.inputTextField.mas_centerY).priorityMedium();
        make.height.equalTo(self.inputTextField.mas_height);
    }];
    
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.inputTextField.mas_centerY).priorityMedium();
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.inputTextField.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapInLoginTextField:)];
        [self.titleLabel addGestureRecognizer:tap];
        
        //默认设置
        
        self.titleLabel.font = [UIFont systemFontOfAutoSize:15.0];
        self.titleLabel.textColor = [UIColor colorWithWhite:170.0 / 255.0 alpha:1.0f];
    }
    return _titleLabel;
}


- (UITextField *)inputTextField {
    if (!_inputTextField) {
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.font = [UIFont systemFontOfAutoSize:16.0];
        self.inputTextField.textColor = [UIColor colorWithWhite:34.0 / 255.0 alpha:1.0f];
        self.inputTextField.delegate = self;
        [self.inputTextField addTarget:self action:@selector(textFieldValueChangeInLoginTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTextField;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton addTarget:self action:@selector(rightButtonActionInLoginTextField:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        self.bottomLine = [[UIView alloc] init];
//        self.bottomLine.backgroundColor = [UIColor colorWithHexInt:0xEAEAEA];
    }
    return _bottomLine;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
