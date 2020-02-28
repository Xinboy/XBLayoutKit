//
//  RoomListPopViewController.m
//  IQUP
//
//  Created by Xinbo Hong on 2017/12/16.
//  Copyright © 2017年 xigu. All rights reserved.
//

#import "ListPopViewController.h"

typedef NS_ENUM(NSInteger, CellPositionStyle) {
    CellPositionStyleDefault = 0,
    CellPositionStyleTopArc,
    CellPositionStyleBottomArc,
    CellPositionStyleRectRounded,
};

@interface ListPopViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIColor *cellBorderColor;
    UIColor *cellBackgroundColor;
    UIColor *cellSeparatorColor;
    CGFloat itemHeight;
    CGFloat headerHeight;
}

@property (nonatomic, strong) UIToolbar *alphaBgview;

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UILabel *headerTitleLabel;

@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, assign) CGFloat tableViewHeight;


@end

@implementation ListPopViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cellBorderColor = [UIColor clearColor];
    cellBackgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    cellSeparatorColor = [UIColor grayColor];
    itemHeight = 57;
    headerHeight = 51;
    [self iniAllSubviews];
}

- (void)iniAllSubviews {
    self.view.backgroundColor = [UIColor clearColor];
    self.alphaBgview = [[UIToolbar alloc] init];
    self.alphaBgview.frame = self.view.bounds;
    self.alphaBgview.alpha = 0.7;
    self.alphaBgview.backgroundColor = [UIColor clearColor];
    [self.alphaBgview setBarStyle:UIBarStyleBlackTranslucent];
    
    CGFloat leftSpace = 10;
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(leftSpace, CGRectGetHeight(self.view.frame) - self.tableViewHeight, CGRectGetWidth(self.view.frame) - 2 * leftSpace, self.tableViewHeight) style:UITableViewStyleGrouped];
    [self.listTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.alphaBgview];
    [self.view addSubview:self.listTableView];
}

- (void)setListItemArray:(NSArray *)listArray{
    itemHeight = 57;
    headerHeight = 51;
    
    if (listArray.count > 0) {
        self.listArray = listArray.copy;
    }
    
    self.tableViewHeight = itemHeight * (self.listArray.count + 1) + headerHeight * 3;
    if (self.tableViewHeight > CGRectGetHeight(self.view.frame)) {
        self.tableViewHeight = CGRectGetHeight(self.view.frame);
    } else {
        self.listTableView.scrollEnabled = NO;
    }
    [self.listTableView reloadData];
}

#pragma mark - **************** UITableView DataSourse and Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = cellBackgroundColor;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    if (indexPath.section == 0) {
        id temp = self.listArray[indexPath.row];
        if ([temp isKindOfClass:[NSString class]]) {
            cell.textLabel.text = temp;
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = NSLocalizedString(@"取消", nil);
    }
    return cell;
}

/** 解决section 圆角*/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 10.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *backgroundViewLayer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        BOOL addLine = NO;
        
        CellPositionStyle positionStyle = [self cellPositionStyleWithTableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        
        switch (positionStyle) {
            case CellPositionStyleTopArc:
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
                break;
            case CellPositionStyleBottomArc:
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                break;
            case CellPositionStyleDefault:
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
                break;
            case CellPositionStyleRectRounded:
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                break;
            default:
                break;
        }
        backgroundViewLayer.path = pathRef;
        //颜色修改
        backgroundViewLayer.fillColor = cellBackgroundColor.CGColor;
        backgroundViewLayer.strokeColor = cellBorderColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (2.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height - lineHeight, bounds.size.width, lineHeight);
            lineLayer.backgroundColor = cellSeparatorColor.CGColor;
            [backgroundViewLayer addSublayer:lineLayer];
        }
        UIView *backgroundView = [[UIView alloc] initWithFrame:bounds];
        [backgroundView.layer insertSublayer:backgroundViewLayer atIndex:0];
        backgroundView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = backgroundView;
        
        cell.layer.masksToBounds = YES;
        
        UIView *selectedView = [[UIView alloc] initWithFrame:bounds];
        CAShapeLayer *selectedViewLayer = [[CAShapeLayer alloc] init];
        selectedViewLayer.path = pathRef;
        selectedViewLayer.fillColor = cellBackgroundColor.CGColor;
        selectedViewLayer.strokeColor = cellBorderColor.CGColor;
        [selectedView.layer addSublayer:selectedViewLayer];
        cell.selectedBackgroundView = selectedView;
        
        CFRelease(pathRef);
    }
}

- (CellPositionStyle)cellPositionStyleWithTableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat headerHeight = 0;
    CGFloat footerHeight = 0;
    
    CGFloat presetHeight = 17.5;
    
    CGFloat rowCount = [tableView numberOfRowsInSection:indexPath.section];
    headerHeight = CGRectGetHeight([tableView rectForHeaderInSection:indexPath.section]);
    footerHeight = CGRectGetHeight([tableView rectForFooterInSection:indexPath.section]);

    if ((rowCount > 1 && indexPath.row == 0 && headerHeight == presetHeight) ||
        (rowCount == 1 && headerHeight == presetHeight && footerHeight > presetHeight)) {
        //cell 个数大于1 && 位于第一个 && 无header视图
        //cell个数为1 && 无header视图 && 有footer视图
        return CellPositionStyleTopArc;
    } else if ((rowCount > 1 && indexPath.row == rowCount - 1 && footerHeight <= presetHeight) ||
               (rowCount == 1 && headerHeight > presetHeight && footerHeight <= presetHeight)) {
        //cell 个数大于1 && 位于最后 && 无footer视图
        //cell个数为1 && 有header视图 && 无footer视图
        return CellPositionStyleBottomArc;
    } else if (rowCount == 1 && headerHeight <= presetHeight && footerHeight <= presetHeight) {
        //cell个数为1 && 无header视图 && 无footer视图
        return CellPositionStyleRectRounded;
    } else {
        return CellPositionStyleDefault;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    if(!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderView"];
    }
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.listTableView.frame), 51);

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = headerView.bounds;
        layer.path = path.CGPath;
        headerView.layer.mask = layer;
        
        self.headerTitleLabel = [[UILabel alloc] init];
        self.headerTitleLabel.frame = headerView.bounds;
        self.headerTitleLabel.backgroundColor = cellBackgroundColor;
        self.headerTitleLabel.textColor = [UIColor colorWithWhite:143 / 255.0 alpha:1.0f];
        self.headerTitleLabel.font = [UIFont systemFontOfSize:14];
        self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.headerTitleLabel.text = self.titleStr;
        
        CGFloat lineHeight = (2.f / [UIScreen mainScreen].scale);
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = cellSeparatorColor;
        bottomLine.frame = CGRectMake(0, CGRectGetHeight(headerView.frame) - lineHeight, CGRectGetWidth(headerView.frame), lineHeight);
        

        [headerView addSubview:self.headerTitleLabel];
        [headerView addSubview:bottomLine];
        return headerView;
    } else {
        return nil;
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.listArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return itemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return headerHeight;
    } else {
        return 0;
    }
}

#pragma mark -  UITableView Action Function
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.delegate respondsToSelector:@selector(listPopTableView:deleteCellAtIndexPath:)]) {
            [self.delegate listPopTableView:tableView deleteCellAtIndexPath:indexPath];
            [self.listTableView reloadData];
        }
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(listPopTableView:didSelectedAtIndexPath:)]) {
            [self.delegate listPopTableView:self.listTableView didSelectedAtIndexPath:indexPath];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)tableViewCellLongPressGesAction:(UILongPressGestureRecognizer *)sender {
    
    UITableViewCell *cell = (UITableViewCell *)sender.view.superview;
    NSIndexPath *indexPath = [self.listTableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(listPopTableView:longPressAtIndexPath:)]) {
            [self.delegate listPopTableView:self.listTableView longPressAtIndexPath:indexPath];
            [self.listTableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
