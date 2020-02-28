//
//  XBDatePicker.m
//  DailyAccouting
//
//  Created by Xinbo Hong on 2017/7/25.
//  Copyright © 2017年 Xinbo Hong. All rights reserved.
//

#import "XBDatePicker.h"

static const CGFloat kButtonHeight = 44;
static const CGFloat kButtonWidth = kButtonHeight * 3 / 2;
static const CGFloat kMargin = 10;

@interface XBDatePicker ()

@property (nonatomic, strong) UIView *headerBgView;


@property (nonatomic, strong) UIButton *cancelButton;
//选择的时间显示框
@property (nonatomic, strong) UILabel *selectedDateLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) ConfirmButtonAction confirmButtonBlock;
@end

@implementation XBDatePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        [self.headerBgView addSubview:self.cancelButton];
        [self.headerBgView addSubview:self.selectedDateLabel];
        [self.headerBgView addSubview:self.confirmButton];
        [self addSubview:self.headerBgView];
        [self addSubview:self.datePicker];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideXBDatePicker)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)initDatePickerProperty:(NSDictionary *)propertyDict {
    if (propertyDict[@"minDate"]) {
        self.datePicker.minimumDate = propertyDict[@"minDate"];
    }
    if (propertyDict[@"maxDate"]) {
        self.datePicker.maximumDate = propertyDict[@"maxDate"];
    }
}

- (void)setSelectedDateLabelText:(NSString *)text {
    self.selectedDateLabel.text = text;
}

- (void)setConfirmButtonAction:(ConfirmButtonAction)confirmAction {
    if (confirmAction) {
        self.confirmButtonBlock = confirmAction;
    }
}

- (void)showXBDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }];
}
#pragma mark - **************** 私有方法
- (void)hideXBDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }];
}

- (void)handleXBDatePickerConfirmButtonAction:(UIButton *)sender {
    if (self.confirmButtonBlock) {
        self.confirmButtonBlock(sender);
    }
}

/** 监听 UIDatePicker改变*/
- (void)handleXBDatePickerValueChange:(UIDatePicker *)sender
{
    NSDate *selectedDate = sender.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:selectedDate];
    self.selectedDateLabel.text = dateStr;
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

#pragma mark - **************** Lazy Load
- (UIView *)headerBgView
{
    if (!_headerBgView) {
        self.headerBgView = [[UIView alloc] init];
        self.headerBgView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 60 - 216, CGRectGetWidth(self.frame), 60);
        self.headerBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _headerBgView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(kMargin, (self.headerBgView.frame.size.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight);
        [self.cancelButton setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [self.cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(hideXBDatePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)selectedDateLabel
{
    if (!_selectedDateLabel) {
        self.selectedDateLabel = [[UILabel alloc] init];
        self.selectedDateLabel.frame = CGRectMake(2 * kMargin + kButtonWidth, 0,self.headerBgView.frame.size.width - (2 * kMargin + kButtonWidth) * 2, self.headerBgView.frame.size.height);
        self.selectedDateLabel.textAlignment = NSTextAlignmentCenter;
        self.selectedDateLabel.textColor = [UIColor blackColor];
        self.selectedDateLabel.font = [UIFont systemFontOfSize:15];
    }
    return _selectedDateLabel;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(self.headerBgView.frame.size.width - kMargin - kButtonWidth, (self.headerBgView.frame.size.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight);
        [self.confirmButton setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [self.confirmButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(handleXBDatePickerConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIDatePicker *)datePicker
{
    //高度216为 UIDatePicker的固定高度
    if (!_datePicker) {
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(0, self.headerBgView.frame.origin.y + self.headerBgView.frame.size.height, self.frame.size.width, 216);
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(handleXBDatePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
