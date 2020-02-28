//
//  GesturesView.m
//  pydx
//
//  Created by Xinbo Hong on 2020/2/18.
//  Copyright © 2020年 Xinbo Hong. All rights reserved.
//

#import "GesturesView.h"
#import "PointView.h"

/// 设置时第一次存储数据
static NSString *const kGestureTempLockKey = @"kGestureTempLockKey";
/// 设置成功存储数据
static NSString *const kGestureLockKey = @"kGestureLockKey";

@interface GesturesView ()

@property (nonatomic, strong) NSMutableArray *pointViewArray;

@property (nonatomic, strong) NSMutableArray *selectedPointViewArray;

@property (nonatomic, strong) NSMutableArray *selectedViewCenterArray;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@property (nonatomic, strong) UIBezierPath *linePath;

@property (nonatomic, assign, getter=isTouchEnd) BOOL touchEnd;

@property (nonatomic, strong, readwrite) UIColor *selectedColor;

/** 设置手势的两次比对*/
@property (nonatomic, assign, getter=isConfirmSetting) BOOL confirmSetting;

@end

@implementation GesturesView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame selectedColor:[self colorForRed:30.0 green:180.0 blue:244.0 alpha:1.0]];
}

- (instancetype)initWithFrame:(CGRect)frame selectedColor:(UIColor *)selectColor {
    self = [super initWithFrame:frame];
    if (self) {
    
        //默认为否
        self.confirmSetting = NO;
        
        self.touchEnd = NO;
        self.selectedColor = selectColor;
        
        self.startPoint = CGPointZero;
        self.endPoint = CGPointZero;
        for (int i = 0; i < 9; i++) {
            PointView *pointView = [[PointView alloc] initWithFrame:CGRectMake((i % 3) * (self.bounds.size.width / 2.0 - 31.0) + 1, (i / 3) * (self.bounds.size.height / 2.0 - 31.0) + 1, 60, 60)
                                                             WithID:[NSString stringWithFormat:@"gestures %d",i + 1]];
            pointView.selectedColor = selectColor;
            [self addSubview:pointView];
            [self.pointViewArray addObject:pointView];
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //隐藏警告
    if ([self.delegate respondsToSelector:@selector(gesturesView:status:)]) {
        [self.delegate gesturesView:self status:@"0"];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isTouchEnd) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (PointView *pointView in self.pointViewArray) {
        if (CGRectContainsPoint(pointView.frame, point)){
            //如果开始按钮为zero，记录开始按钮，否则不需要记录开始按钮
            if (CGPointEqualToPoint(self.startPoint, CGPointZero)) {
                self.startPoint = pointView.center;
            }
            //判断该手势按钮的中心点是否记录，未记录则记录
            if (![self.selectedViewCenterArray containsObject:[NSValue valueWithCGPoint:pointView.center]]) {
                [self.selectedViewCenterArray addObject:[NSValue valueWithCGPoint:pointView.center]];
            }
            //判断该手势按钮是否已经选中，未选中就选中
            if (![self.selectedPointViewArray containsObject:pointView.ID]) {
                [self.selectedPointViewArray addObject:pointView.ID];
                pointView.selected = YES;
            }
        }
    }
    if (!CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        self.endPoint = point;
        [self drawLine];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.endPoint = [self.selectedViewCenterArray.lastObject CGPointValue];
    
    if (CGPointEqualToPoint(self.endPoint, CGPointZero)) {
        return;
    }
    [self drawLine];
    
    self.touchEnd = YES;
    
    /// 设置手势和解锁手势判断
    if (self.isSettingGesture) {
        if (self.selectedPointViewArray.count < 4) {
            // 个数少于4，取消此次操作
            
            if ([self.delegate respondsToSelector:@selector(gesturesView:error:)]) {
                [self.delegate gesturesView:self error:@"手势个数少于4个，请重新设置"];
            }
            
            [self showStatusForSuccess:NO];
            [self resetGes];
            return;
        }
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (self.isConfirmSetting) {
            //第二次手势识别，与第一次判断
            NSArray *lastArray = [def objectForKey:kGestureTempLockKey];
            if ([lastArray isEqualToArray:self.selectedPointViewArray]) {
                //比对成功，保存并删除临时，并返回结果
                [def setObject:self.selectedPointViewArray.copy forKey:kGestureLockKey];
                
                if ([self.delegate respondsToSelector:@selector(gesturesView:settingStatus:)]) {
                    [self.delegate gesturesView:self settingStatus:YES];
                }
                
            } else {
                if ([self.delegate respondsToSelector:@selector(gesturesView:error:)]) {
                    [self.delegate gesturesView:self error:@"与第一次手势密码不符，请重新设置"];
                }
                //比对失败，重新输入
                [self showStatusForSuccess:NO];
            }
        } else {
            //第一次手势识别
            [def setObject:self.selectedPointViewArray.copy forKey:kGestureTempLockKey];
            self.confirmSetting = YES;
            
            
            // 主要是为了控制器显示提醒标签
            if ([self.delegate respondsToSelector:@selector(gesturesView:status:)]) {
                [self.delegate gesturesView:self status:@"1"];
            }
        }
    
        // 1秒后复原
        [self resetGes];
        return;
    } else {
        NSArray *selectID = [[NSUserDefaults standardUserDefaults] objectForKey:kGestureLockKey];
        
        BOOL isSuccess = NO;
        isSuccess = [self.selectedPointViewArray isEqualToArray:selectID];
        
        [self showStatusForSuccess:isSuccess];
        
        if (!isSuccess) {
            if ([self.delegate respondsToSelector:@selector(gesturesView:error:)]) {
                [self.delegate gesturesView:self error:@"手势密码输入错误"];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(gesturesView:settingStatus:)]) {
            [self.delegate gesturesView:self unlockStatus:isSuccess];
        }
        
        
        
        
        // 1秒后复原
        [self resetGes];
    }

    
}

- (void)drawLine {
    if (self.isTouchEnd) {
        return;
    }
    
    [self.lineLayer removeFromSuperlayer];
    [self.linePath removeAllPoints];
    
    [self.linePath moveToPoint:self.startPoint];
    for (NSValue *pointValue in self.selectedViewCenterArray) {
        [self.linePath addLineToPoint:[pointValue CGPointValue]];
    }
    [self.linePath addLineToPoint:self.endPoint];
    self.lineLayer.path = self.linePath.CGPath;
    self.lineLayer.lineWidth = 4.0;
    self.lineLayer.strokeColor = self.selectedColor.CGColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:self.lineLayer];
    self.layer.masksToBounds = YES;
    
}

- (void)showStatusForSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        for (PointView *view in self.pointViewArray) {
            view.success = YES;
        }
        //成功颜色（绿）
        self.lineLayer.strokeColor = [self colorForRed:43.0 green:210.0 blue:110.0 alpha:1.0].CGColor;
    } else {
        for (PointView *view in self.pointViewArray) {
            view.error = YES;
        }
        //失败颜色（红）
        self.lineLayer.strokeColor = [self colorForRed:222.0 green:64.0 blue:60.0 alpha:1.0].CGColor;
    }
    
    
}

+ (BOOL)hasGesturesLogin {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kGestureLockKey]) {
        return true;
    }
    return false;
    
}

- (void)resetGes {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.touchEnd = NO;
        for (PointView *view in self.pointViewArray) {
            view.selected = NO;
        }
        [self.lineLayer removeFromSuperlayer];
        [self.selectedPointViewArray removeAllObjects];
        [self.selectedViewCenterArray removeAllObjects];
        self.startPoint = CGPointZero;
        self.endPoint = CGPointZero;
    });
}


- (UIColor *)colorForRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}
#pragma mark - **************** Getter and setter

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
}

- (NSMutableArray *)pointViewArray {
    if (!_pointViewArray) {
        self.pointViewArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _pointViewArray;
}

- (NSMutableArray *)selectedPointViewArray {
    if (!_selectedPointViewArray) {
        self.selectedPointViewArray = [NSMutableArray array];
    }
    return _selectedPointViewArray;
}

- (NSMutableArray *)selectedViewCenterArray {
    if (!_selectedViewCenterArray) {
        self.selectedViewCenterArray = [NSMutableArray array];
    }
    return _selectedViewCenterArray;
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        self.lineLayer = [CAShapeLayer layer];
    }
    return _lineLayer;
}

- (UIBezierPath *)linePath {
    if (!_linePath) {
        self.linePath = [UIBezierPath bezierPath];
    }
    return _linePath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
