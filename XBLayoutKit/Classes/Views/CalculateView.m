//
//  CalculateView.m
//  DailyAccouting
//
//  Created by Xinbo Hong on 2017/9/2.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.
//

#import "CalculateView.h"

//运算符
typedef NS_ENUM(NSInteger, CalculatorOparator) {
    CalculatorOparatorDivide = 1,
    CalculatorOparatorSultiply,
    CalculatorOparatorSubtract,
    CalculatorOparatorAdd,
    CalculatorOparatorEqual,
};

//其他事件
typedef NS_ENUM(NSInteger, CalculatorAction) {
    CalculatorActionClear = 1,
    CalculatorActionPercent,
    CalculatorActionBackspace,
};

NSNotificationName const XBCalculateViewDidshowValueHasChangeNotification = @"didShowValueHasChange";

NSString *const XBCalculateViewDidshowValueHasChangeUserInfoKey = @"showValue";

@interface CalculateView () {
    NSString *sNum1;
    NSString *sNum2;
    NSString *resultNum;
    NSInteger oparatorTag;
    BOOL isSelecteOparator;
}

@end

@implementation CalculateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        itemSide = self.frame.size.width / 4;
        oparatorColor = [UIColor colorWithRed:243 / 255.0 green:127 / 255.0 blue:38 / 255.0 alpha:1.0f];
        actionColor = [UIColor colorWithWhite:205 / 255.0 alpha:1.0f];
        numberColor = [UIColor colorWithWhite:217 / 255.0 alpha:1.0f];
        sNum1 = @"0";
        sNum2 = @"0";
        resultNum = @"unknow";
        oparatorTag = 0;
    
        [self initButtonItems];
        [self addSubview:self.calculatorBgView];
    }
    return self;
}


#pragma mark - **************** 加载控件
- (UIView *)calculatorBgView {
    if (!_calculatorBgView) {
        self.calculatorBgView = [[UIView alloc] init];
        self.calculatorBgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.calculatorBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _calculatorBgView;
}

- (void)initButtonItems {
    UIView *buttonItemsBgView = [[UIView alloc] init];
    buttonItemsBgView.frame = CGRectMake(0,CGRectGetHeight(self.calculatorBgView.frame) - itemSide * 5, CGRectGetWidth(self.calculatorBgView.frame), itemSide * 5);
    
    NSDictionary *oparatorAttDict = @{NSFontAttributeName:[UIFont systemFontOfSize:40],
                                      NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGFloat space = 0.5;
    CGFloat innerItemSide = itemSide - space;
    //运算符@"+",@"-",@"×",@"÷",@"="
    //243 127 38
    NSArray *oparatorTitleArray = @[@"÷",@"×",@"−",@"+",@"="];
    for (int i = 0; i < oparatorTitleArray.count; i ++) {
        UIButton *oparatorButton = [[UIButton alloc] init];
        oparatorButton.frame = CGRectMake(itemSide * 3 + space * 4 / 3,(innerItemSide + space * 5 / 4 ) * i, innerItemSide, innerItemSide);
        [oparatorButton setBackgroundImage:[self imageWithColor:oparatorColor] forState:UIControlStateNormal];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:oparatorTitleArray[i] attributes:oparatorAttDict];
        [oparatorButton setAttributedTitle:attStr forState:UIControlStateNormal];
        [oparatorButton addTarget:self action:@selector(calculateViewSelectOparator:) forControlEvents:UIControlEventTouchUpInside];
        oparatorButton.tag = 2001 + i;
        [buttonItemsBgView addSubview:oparatorButton];
    }
    
    NSDictionary *blackColorAttDict = @{NSFontAttributeName:[UIFont systemFontOfSize:30],
                                        NSForegroundColorAttributeName:[UIColor blackColor]};
    //重置，百分号，回退
    NSArray *actionTitleArray = @[@"AC",@"%"];
    for (int i = 0; i < 3; i ++) {
        UIButton *actionrButton = [[UIButton alloc] init];
        actionrButton.frame = CGRectMake((innerItemSide + space * 4 / 3) * i, 0, innerItemSide, innerItemSide);
        [actionrButton setBackgroundImage:[self imageWithColor:actionColor] forState:UIControlStateNormal];
        actionrButton.tag = 3001 + i;
        [actionrButton addTarget:self action:@selector(calculateViewSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i < actionTitleArray.count) {
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:actionTitleArray[i] attributes:blackColorAttDict];
            [actionrButton setAttributedTitle:attStr forState:UIControlStateNormal];
        } else {
            [actionrButton setImage:[UIImage imageNamed:@"btn_backspace_normal"] forState:UIControlStateNormal];
        }
        [buttonItemsBgView addSubview:actionrButton];
    }
    
    //数字1-9
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *numberButton = [[UIButton alloc] init];
            numberButton.frame = CGRectMake((innerItemSide + space * 4 / 3)  * j, (innerItemSide + space * 5 / 4 ) * (i + 1), innerItemSide, innerItemSide);
            [numberButton setBackgroundImage:[self imageWithColor:numberColor] forState:UIControlStateNormal];
            numberButton.tag = 1001 + i;
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",((-3) * i + 7) + j] attributes:blackColorAttDict];
            [numberButton setAttributedTitle:attStr forState:UIControlStateNormal];
            [numberButton addTarget:self action:@selector(calculateViewSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
            [buttonItemsBgView addSubview:numberButton];
        }
    }
    //数字0，小数点
    UIButton *zeroButton = [[UIButton alloc] init];
    zeroButton.frame = CGRectMake(0, (innerItemSide + space * 5 / 4 ) * 4, innerItemSide * 2, innerItemSide);
    [zeroButton setBackgroundImage:[self imageWithColor:numberColor] forState:UIControlStateNormal];
    zeroButton.tag = 1000;
    NSAttributedString *zeroAttStr = [[NSAttributedString alloc] initWithString:@"0" attributes:blackColorAttDict];
    [zeroButton setAttributedTitle:zeroAttStr forState:UIControlStateNormal];
    zeroButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, innerItemSide);
    [zeroButton addTarget:self action:@selector(calculateViewSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
    [buttonItemsBgView addSubview:zeroButton];
    
    UIButton *decimalButton = [[UIButton alloc] init];
    decimalButton.frame = CGRectMake((innerItemSide + space * 4 / 3) * 2, (innerItemSide + space * 5 / 4 ) * 4, innerItemSide, innerItemSide);
    [decimalButton setBackgroundImage:[self imageWithColor:numberColor] forState:UIControlStateNormal];
    decimalButton.tag = 1010;
    NSAttributedString *decimalAttStr = [[NSAttributedString alloc] initWithString:@"." attributes:blackColorAttDict];
    [decimalButton setAttributedTitle:decimalAttStr forState:UIControlStateNormal];
    [decimalButton addTarget:self action:@selector(calculateViewDecimal) forControlEvents:UIControlEventTouchUpInside];
    [buttonItemsBgView addSubview:decimalButton];
    
    
    [self.calculatorBgView addSubview:buttonItemsBgView];
}

#pragma mark - **************** 公开方法
- (void)resetValue {
    sNum1 = @"0";
    sNum2 = @"0";
    resultNum = @"unknow";
    oparatorTag = 0;
}

- (void)hideCalculateView {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }];
}

#pragma mark - **************** 按钮点击方法

/**
 数字的选择
 
 @param sender 点击按钮
 */
- (void)calculateViewSelectNumber:(UIButton *)sender {
    NSString *titleStr = [NSString stringWithFormat:@"%@",sender.currentAttributedTitle.string];
    
    if (![resultNum isEqualToString:@"unknow"]) {
        //上次点击为等号，本次为数字
        [self resetEqualButtonTitle:@"="];
        resultNum = @"unknow";
        sNum2 = @"0";
        oparatorTag = 0;
        sNum1 = titleStr;
        [self postNotificationWithShowValue:sNum1];
        return;
    }
    if (oparatorTag == 0) {
        //最开始输入数值，为第一参数赋值
        if ([sNum1 isEqualToString:@"0"]) {
            sNum1 = titleStr;
        } else {
            sNum1 = [NSString stringWithFormat:@"%@%@",sNum1,titleStr];
        }
        [self postNotificationWithShowValue:sNum1];

    }  else {
        //输入符号后为第二参数赋值
        if ([sNum2 isEqualToString:@"0"]) {
            sNum2 = titleStr;
        } else {
            sNum2 = [NSString stringWithFormat:@"%@%@",sNum2,titleStr];
        }
        [self postNotificationWithShowValue:sNum2];
    }
}



/**
 运算符
 
 @param sender 点击按钮
 */
- (void)calculateViewSelectOparator:(UIButton *)sender {
    NSInteger tag = sender.tag - 2000;
    UIButton *equalButton = [self viewWithTag:2005];
    if (tag != CalculatorOparatorEqual) {
        if (![resultNum isEqualToString:@"unknow"]) {
            //上次点击为等号，本次为运算符
            [self resetEqualButtonTitle:@"="];
            sNum1 = resultNum;
            sNum2 = @"0";
            oparatorTag = tag;
            resultNum = @"unknow";
        } else {
            oparatorTag = tag;
        }
    } else {
        if (![resultNum isEqualToString:@"unknow"]) {
            [self resetEqualButtonTitle:@"="];
            //上次点击为等号，本次为等号
            sNum1 = resultNum;
            resultNum = @"unknow";
            [self hideCalculateView];
            
        }
        if (oparatorTag == 0) {
            [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:sNum1]];
        } else {
            //得出两数计算结果
            double first = [sNum1 doubleValue];
            double second = [sNum2 doubleValue];
            switch (oparatorTag) {
                case CalculatorOparatorAdd: {
                    resultNum = [NSString stringWithFormat:@"%f",first + second];
                    break;
                }
                case CalculatorOparatorSubtract: {
                    resultNum = [NSString stringWithFormat:@"%f",first - second];
                    break;
                }
                case CalculatorOparatorSultiply: {
                    resultNum = [NSString stringWithFormat:@"%f",first * second];
                    break;
                }
                case CalculatorOparatorDivide: {
                    if (second != 0) {
                        resultNum = [NSString stringWithFormat:@"%f",first / second];
                    } else {
                        resultNum = [NSString stringWithFormat:@"0"];
                    }
                    break;
                }
            }
            [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:resultNum]];
            sNum2 = @"0";
            [self resetEqualButtonTitle:@"OK"];
        }
        
    }
}


/**
 小数点
 */
- (void)calculateViewDecimal {
    if (oparatorTag == 0) {
        if ([sNum1 rangeOfString:@"."].length > 0) {
            //存在小数点了，不做出来
        } else {
            sNum1 = [NSString stringWithFormat:@"%@%@",sNum1,@"."];
        }
        [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:sNum1]];
    } else {
        if ([sNum2 rangeOfString:@"."].length > 0) {
            //存在小数点了，不做出来
        } else {
            sNum2 = [NSString stringWithFormat:@"%@%@",sNum2,@"."];
        }
        [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:sNum2]];
    }
}

#pragma mark - **************** actionButton点击方法
- (void)calculateViewSelectAction:(UIButton *)sender
{
    switch (sender.tag - 3000) {
        case CalculatorActionClear:
            [self calculateViewClear];
            break;
        case CalculatorActionPercent:
            [self calculateViewPercent];
            break;
        case CalculatorActionBackspace:
            [self calculateViewBackspace];
            break;
        default:
            break;
    }
}

/**
 重置
 */
- (void)calculateViewClear
{
    [self resetValue];
    [self postNotificationWithShowValue:@"0"];
}

/**
 百分比
 */
- (void)calculateViewPercent
{
    
}

/**
 回退
 */
- (void)calculateViewBackspace
{
    if (oparatorTag == 0) {
        sNum1 = [self calculateViewRemoveExtraZero:sNum1];
        //最开始输入数值，为第一参数赋值
        if (sNum1.length > 1) {
            sNum1 = [sNum1 substringToIndex:sNum1.length - 1];
        } else {
            sNum1 = @"0";
        }
        [self postNotificationWithShowValue:sNum1];
    }  else {
        sNum2 = [self calculateViewRemoveExtraZero:sNum2];
        //输入符号后为第二参数赋值
        if (sNum2.length > 1) {
            sNum2 = [sNum2 substringToIndex:sNum2.length - 1];
        } else {
            sNum2 = @"0";
        }
        [self postNotificationWithShowValue:sNum2];
    }
}


#pragma mark - **************** 细节处理方法
/**重新设置等号按钮标题*/
- (void)resetEqualButtonTitle:(NSString *)text {
    
    
    NSDictionary *oparatorAttDict = @{NSFontAttributeName:[UIFont systemFontOfSize:40],
                                      NSForegroundColorAttributeName:[UIColor whiteColor]};
    UIButton *button = [self viewWithTag:2005];
    NSAttributedString *attStr;

    attStr = [[NSAttributedString alloc] initWithString:text attributes:oparatorAttDict];
    [button setAttributedTitle:attStr forState:UIControlStateNormal];
}


/**
 去除小数点后多余的0，如果为整数，保留小数点后一位的0
 
 @param text 数字字符串
 */
- (NSString *)calculateViewRemoveExtraZero:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        return nil;
    }
    NSRange decimalRange = [text rangeOfString:@"."];
    //最后一位
    NSString *temp = nil;
    NSInteger offset = text.length - 1;
    
    while (1) {
        temp = [text substringWithRange:NSMakeRange(offset, 1)];
        if ([temp isEqualToString:@"0"] && offset > decimalRange.location + 1) {
            offset--;
        } else {
            break;
        }
    }
    return [text substringToIndex:offset + 1];
}

- (void)postNotificationWithShowValue:(NSString *)showValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:XBCalculateViewDidshowValueHasChangeNotification object:nil userInfo:@{XBCalculateViewDidshowValueHasChangeUserInfoKey:showValue}];
}

/** 用颜色生成一张图片 */
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
