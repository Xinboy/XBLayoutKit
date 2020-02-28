//
//  CalendarView.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/4/28.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "CalendarView.h"
static NSString *const kWeekDayArray[7] = {@"日",@"一",@"二",@"三",@"四",@"五",@"六"};

@interface CalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *calendarCollectionView;

@property (nonatomic, strong) UIView *weekTitleView;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) NSInteger startIndexRow;

@end

@implementation CalendarView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemWidth = CGRectGetWidth(self.frame) / 7;
        
        [self addSubview:self.weekTitleView];
        [self addSubview:self.calendarCollectionView];
    }
    return self;
}

- (UIView *)weekTitleView {
    if (!_weekTitleView) {
        self.weekTitleView = [[UIView alloc] init];
        self.weekTitleView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 20);
        
        for (int i = 0; i < 7; i++) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(i * self.itemWidth, 0, self.itemWidth, self.weekTitleView.frame.size.height);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:10];
            titleLabel.text = kWeekDayArray[i];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.tag = 1000 + i;
            [self.weekTitleView addSubview:titleLabel];
        }
    }
    return _weekTitleView;
}

- (UICollectionView *)calendarCollectionView {
    if (!_calendarCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.itemWidth, self.itemWidth);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        
        self.calendarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.calendarCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.weekTitleView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.weekTitleView.frame));
        self.calendarCollectionView.delegate = self;
        self.calendarCollectionView.dataSource = self;
        [self.calendarCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"Cell"];
        self.calendarCollectionView.backgroundColor = [UIColor clearColor];
        
    }
    return _calendarCollectionView;
}

#pragma mark - **************** UIColletionView delegate and dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //获取当前星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitWeekday fromDate:[NSDate date]];
    self.startIndexRow = components.weekday - 1;
    
    return 30;
//    return (self.startIndexRow - 1) + 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    if (indexPath.row < self.startIndexRow) {
        
    } else {
        NSDateComponents *current = [self fetchComponent:[NSDate date]];
        
        NSDate *date = [self endDayAfterNowWithIntervals:indexPath.row - self.startIndexRow];
        NSDateComponents *components = [self fetchComponent:date];
        
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld",components.day];
        cell.monthLabel.text = [NSString stringWithFormat:@"%ld月",components.month];
        
        
        NSLog(@"%@,%@",cell.dayLabel.text,cell.monthLabel.text);
     
        if (indexPath.row == self.startIndexRow) {
            cell.monthLabel.hidden = false;
            cell.monthLabel.textColor = [UIColor grayColor];
        }
        if (components.day == 1 && components.month != current.month) {
            cell.monthLabel.hidden = false;
            cell.monthLabel.textColor = [UIColor blueColor];
        }
    
    }
    
    return cell;
}


///
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell changeDayLabelIsSelected];
}

#pragma mark - --- 私有方法 ---
- (NSDate *)endDayAfterNowWithIntervals:(CGFloat)intervals {
    NSDate * date = [NSDate date];
    
    if (intervals == 0) {
        return date;
    }
    NSTimeInterval timeInterval = 24 * 60 * 60 * 1;
    date = [date initWithTimeIntervalSinceNow:timeInterval * intervals];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitWeekday fromDate:date];
    
    return date;
}

- (NSDateComponents *)fetchComponent:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitWeekday fromDate:date];
    return components;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


#pragma mark - --- CalendarCell ---

@interface CalendarCell ()

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *bgColor;

@end


@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
        [self addSubview:self.monthLabel];
        [self addSubview:self.dayLabel];
    }
    return self;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        self.monthLabel = [[UILabel alloc] init];
        self.monthLabel.frame = CGRectMake(0, 0, 20, 20);
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.backgroundColor = self.bgColor;
        self.monthLabel.textColor = self.textColor;
        self.monthLabel.hidden = true;
    }
    return _monthLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        CGFloat space = 20;
        CGFloat side = CGRectGetWidth(self.frame) - space * 2;
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.frame = CGRectMake(0, 0, side, side);
        self.dayLabel.center = self.center;
        self.dayLabel.layer.masksToBounds = true;
        self.dayLabel.layer.cornerRadius = CGRectGetHeight(self.dayLabel.frame) * 0.5;
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.backgroundColor = self.bgColor;
        self.dayLabel.textColor = self.textColor;
    }
    return _dayLabel;
}

- (void)changeDayLabelIsSelected {
    if (self.isSelected) {
        self.dayLabel.backgroundColor = self.textColor;
        self.dayLabel.textColor = self.bgColor;
    } else {
        self.dayLabel.backgroundColor = self.bgColor;
        self.dayLabel.textColor = self.textColor;
    }
}

@end

