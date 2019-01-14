//
//  CalculateView.m
//  DailyAccouting
//
//  Created by Xinbo Hong on 2017/9/2.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.
//

/**
 *  项目内的Tag值：
 *  运算符:  2001 + i
 *  数字:    1000 + i
 *  小数点:   1010
 *  特殊运算: 3001 + i
 */

#import "CalculateView.h"

//运算符Multiplying
typedef NS_ENUM(NSInteger, CalculatorOparator) {
    //未输入
    CalculatorOparatorNone = 0,
    //除法
    CalculatorOparatorDivide,
    //乘法
    CalculatorOparatorMultiply,
    //减法
    CalculatorOparatorSubtract,
    //加法
    CalculatorOparatorAdd,
    //等于
    CalculatorOparatorEqual,
};

//其他事件
typedef NS_ENUM(NSInteger, CalculatorAction) {
    //清除
    CalculatorActionClear = 1,
    //百分号
    CalculatorActionPercent,
    //回退
    CalculatorActionBackspace,
};

NSNotificationName const XBCalculateViewDidshowValueHasChangeNotification = @"didShowValueHasChange";

NSString *const XBCalculateViewDidshowValueHasChangeUserInfoKey = @"showValue";

@interface CalculateView () {
    
    NSString *sNum1;
    NSString *sShowNum1;
    NSString *sNum2;
    NSString *sShowNum2;
    NSString *resultNum;
    
    CalculatorOparator oparator;
    CalculatorOparator preOparator;
    //判断是否输入了运算符
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
        resultNum = @"0";
        oparator = CalculatorOparatorNone;
        preOparator = CalculatorOparatorNone;
        [self initButtonItems];
        
        [self addSubview:self.calculatorBgView];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
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
    NSArray *actionTitleArray = @[@"AC",@"%",@""];
    for (int i = 0; i < actionTitleArray.count; i ++) {
        UIButton *actionrButton = [[UIButton alloc] init];
        actionrButton.frame = CGRectMake((innerItemSide + space * 4 / 3) * i, 0, innerItemSide, innerItemSide);
        [actionrButton setBackgroundImage:[self imageWithColor:actionColor] forState:UIControlStateNormal];
        actionrButton.tag = 3001 + i;
        [actionrButton addTarget:self action:@selector(calculateViewSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i < actionTitleArray.count - 1) {
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
    resultNum = @"0";
    oparator = CalculatorOparatorNone;
}

- (void)hideCalculateView {
    CGRect rect = self.frame;
    rect.size.height = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    }];
}

#pragma mark - **************** 按钮点击方法

/**
 数字的选择
 
 @param sender 点击按钮
 */
- (void)calculateViewSelectNumber:(UIButton *)sender {
    NSString *titleStr = [NSString stringWithFormat:@"%@",sender.currentAttributedTitle.string];
    
    if (!isSelecteOparator && oparator == CalculatorOparatorEqual) {
        [self resetValue];
    }
    
    switch (oparator) {
        case CalculatorOparatorNone:
        case CalculatorOparatorEqual:
            //最开始输入数值，为第一参数赋值
            if ([sNum1 isEqualToString:@"0"]) {
                sNum1 = titleStr;
            } else {
                sNum1 = [NSString stringWithFormat:@"%@%@",sNum1,titleStr];
            }
            [self postNotificationWithShowValue:sNum1];
            break;
        case CalculatorOparatorDivide:
        case CalculatorOparatorMultiply:
        case CalculatorOparatorSubtract:
        case CalculatorOparatorAdd:
            //输入符号后为第二参数赋值
            if ([sNum2 isEqualToString:@"0"]) {
                sNum2 = titleStr;
            } else {
                sNum2 = [NSString stringWithFormat:@"%@%@",sNum2,titleStr];
            }
            [self postNotificationWithShowValue:sNum2];
            break;
    }
}


/**
 根据第一个运算符进行计算，并且不重置sNum2
 */
- (void)equalOparator {
    NSDecimalNumber *dNum1 = [[NSDecimalNumber alloc] initWithString:sNum1];
    NSDecimalNumber *dNum2 = [[NSDecimalNumber alloc] initWithString:sNum2];
    NSDecimalNumber *result = [[NSDecimalNumber alloc] init];
    switch (oparator) {
        case CalculatorOparatorDivide:
            if ([sNum2 isEqualToString:@"0"]) {
                //当被除数为0，报错，并重置所有
                [self postNotificationWithShowValue:@"错误"];
                [self resetValue];
                return;
            } else {
                NSDecimalNumber *result = [dNum1 decimalNumberByDividingBy:dNum2];
                sNum1 = [result descriptionWithLocale:nil];
            }
            break;
        case CalculatorOparatorMultiply:
            result = [dNum1 decimalNumberByMultiplyingBy:dNum2];
            sNum1 = [result descriptionWithLocale:nil];
            break;
        case CalculatorOparatorSubtract:
            result = [dNum1 decimalNumberBySubtracting:dNum2];
            sNum1 = [result descriptionWithLocale:nil];
            break;
        case CalculatorOparatorAdd:
            result = [dNum1 decimalNumberByAdding:dNum2];
            sNum1 = [result descriptionWithLocale:nil];
            break;
        default:
            break;
    }
    [self postNotificationWithShowValue:sNum1];
}
/**
 运算符
 
 @param sender 点击按钮
 */
- (void)calculateViewSelectOparator:(UIButton *)sender {
    NSInteger tag = sender.tag - 2000;
    
    if ([sNum2 isEqualToString:@"0"]) {
        //赋值当前运算符，但是不进行任何i运算
        oparator = tag;
        isSelecteOparator = YES;
        return;
    }
    //当存在第二参数，对上个运算符进行运算，然后重置第二参数，将当前按钮的运算符赋值到oparator
    [self equalOparator];
    if (tag != CalculatorOparatorEqual) {
        sNum2 = @"0";
        oparator = tag;
        isSelecteOparator = YES;
    } else {
        oparator = tag;
        isSelecteOparator = NO;
    }
}


/**
 小数点
 */
- (void)calculateViewDecimal {
    switch (oparator) {
        case CalculatorOparatorNone:
        case CalculatorOparatorEqual:
            //最开始输入数值，为第一参数赋值
            if ([sNum1 rangeOfString:@"."].length > 0) {
                //存在小数点了，不做出来
            } else {
                sNum1 = [NSString stringWithFormat:@"%@%@",sNum1,@"."];
            }
            [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:sNum1]];
            break;
        case CalculatorOparatorDivide:
        case CalculatorOparatorMultiply:
        case CalculatorOparatorSubtract:
        case CalculatorOparatorAdd:
            //输入符号后为第二参数赋值
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
- (void)calculateViewClear {
    [self resetValue];
    [self postNotificationWithShowValue:@"0"];
}

/**
 百分比
 */
- (void)calculateViewPercent {
    
}

/**
 回退
 */
- (void)calculateViewBackspace {
    return;
    switch (oparator) {
        case CalculatorOparatorNone:
        case CalculatorOparatorEqual:
            //最开始输入数值，为第一参数赋值
            if ([sNum1 rangeOfString:@"."].length > 0) {
                //存在小数点了，不做出来
            } else {
                sNum1 = [NSString stringWithFormat:@"%@%@",sNum1,@"."];
            }
            [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:sNum1]];
            break;
        case CalculatorOparatorDivide:
        case CalculatorOparatorMultiply:
        case CalculatorOparatorSubtract:
        case CalculatorOparatorAdd:
            //输入符号后为第二参数赋值
            if ([sNum2 rangeOfString:@"."].length > 0) {
                //存在小数点了，不做出来
            } else {
                sNum2 = [NSString stringWithFormat:@"%@%@",sNum2,@"."];
            }
            [self postNotificationWithShowValue:[self calculateViewRemoveExtraZero:sNum2]];
    }
    
//
//    if (oparatorTag == 0) {
//        sNum1 = [self calculateViewRemoveExtraZero:sNum1];
//        //最开始输入数值，为第一参数赋值
//        if (sNum1.length > 1) {
//            sNum1 = [sNum1 substringToIndex:sNum1.length - 1];
//        } else {
//            sNum1 = @"0";
//        }
//        [self postNotificationWithShowValue:sNum1];
//    }  else {
//        sNum2 = [self calculateViewRemoveExtraZero:sNum2];
//        //输入符号后为第二参数赋值
//        if (sNum2.length > 1) {
//            sNum2 = [sNum2 substringToIndex:sNum2.length - 1];
//        } else {
//            sNum2 = @"0";
//        }
//        [self postNotificationWithShowValue:sNum2];
//    }
}


#pragma mark - **************** 细节处理方法
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

- (void)postNotificationWithShowValue:(NSString *)showValue {
    //发送通知，给予其他控件当前显示的值
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
