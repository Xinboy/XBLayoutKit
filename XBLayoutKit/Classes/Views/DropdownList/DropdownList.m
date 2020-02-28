//
//  DropdownList.m
//  OCEditProject
//
//  Created by Xinbo Hong on 2020/2/26.
//  Copyright © 2020 com.xinbo. All rights reserved.
//

#import "DropdownList.h"

@implementation DropdownListItem
- (instancetype)initId:(NSString *)itemId itemName:(NSString *)itemName {
    self = [super init];
    if (self) {
        _itemId = itemId;
        _itemName = itemName;
    }
    return self;
}

- (instancetype)init {
    return [self initId:@"" itemName:@""];
}


@end

@interface DropdownList ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;

@end

static CGFloat const kArrowImgHeight= 10;
static CGFloat const kArrowImgWidth= 15;
static CGFloat const kTextLabelX = 5;
static CGFloat const kItemCellHeight = 40;

@implementation DropdownList

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textLabel];
        [self addSubview:self.arrowImage];
        
        [self initData];
    }
    return self;
}

#pragma mark - **************** Public Event response methods
- (instancetype)initWithDataSource:(NSArray *)dataSource {
    self.dataSource = dataSource;
    return [self initWithFrame:CGRectZero];
}

#pragma mark - **************** Private Event response methods
- (void)initData {
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:14];
    self.selectedIndex = 0;
    self.textLabel.font = self.font;
    self.textLabel.textColor = self.textColor;
    
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(listExpand:)];
    [self.textLabel addGestureRecognizer:tapLabel];

    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(listExpand:)];
    [self.arrowImage addGestureRecognizer:tapImg];
}

- (void)listExpand:(UITapGestureRecognizer *)tap {
    [self rotateArrowImage];
    
    CGFloat tableHeight = self.dataSource.count * kItemCellHeight;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self.tableView];
    
    //获取按钮在屏幕中的位置
    CGRect frame = [self convertRect:self.bounds toView:window];
    CGFloat tableViewY = frame.origin.y + frame.size.height;
    CGRect tableViewFrame;
    tableViewFrame.size.width = frame.size.width;
    tableViewFrame.size.height = tableHeight;
    tableViewFrame.origin.x = frame.origin.x;
    if (tableViewY + tableHeight < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        tableViewFrame.origin.y = tableViewY;
    } else {
        tableViewFrame.origin.y = frame.origin.y - tableHeight;
    }
    self.tableView.frame = tableViewFrame;
    
    UITapGestureRecognizer *tagBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lisrClose:)];
    [self.bgView addGestureRecognizer:tagBackground];
}

- (void)lisrClose:(UITapGestureRecognizer *)sender {
    [self removeBackgroundView];
}

- (void)removeBackgroundView {
    [self.bgView removeFromSuperview];
    [self.tableView removeFromSuperview];
    [self rotateArrowImage];
}

- (void)selectedItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
    if (index < self.dataSource.count) {
        DropdownListItem *item = self.dataSource[index];
        self.selectedItem = item;
        self.textLabel.text = item.itemName;
    }
}


- (void)rotateArrowImage {
    // 旋转箭头图片
    self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
}

#pragma mark - --- UITableViewdelegate ---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = self.textColor;
    DropdownListItem *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.itemName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectedItemAtIndex:indexPath.row];
    [self removeBackgroundView];
    if ([self.delegate respondsToSelector:@selector(dropdownList:didSelectItem:)]) {
        [self.delegate dropdownList:self didSelectItem:self.dataSource[indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
#pragma mark - **************** UIView frame / masonry methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initUI];
}
- (void)initUI {
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    
    self.textLabel.frame = CGRectMake(kTextLabelX, 0, viewWidth - kTextLabelX - kArrowImgWidth , viewHeight);
    self.arrowImage.frame = CGRectMake(CGRectGetWidth(self.textLabel.frame), viewHeight / 2 - kArrowImgHeight / 2, kArrowImgWidth, kArrowImgHeight);
}

#pragma mark - **************** Getter and setter
- (void)setDataSource:(NSArray *)dataSource {
    self.dataSource = dataSource;
    if (dataSource.count > 0) {
        [self selectedItemAtIndex:self.selectedIndex];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self selectedItemAtIndex:selectedIndex];
}

- (void)setFont:(UIFont *)font {
    self.font = font;
    self.textLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    self.textColor = textColor;
    self.textLabel.textColor = textColor;
}


- (UILabel *)textLabel {
    if (!_textLabel) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.userInteractionEnabled = YES;
    }
    return _textLabel;
}

- (UIImageView *)arrowImage {
    if (!_arrowImage) {
        self.arrowImage = [[UIImageView alloc] init];
        self.arrowImage.image = [UIImage imageNamed:@"dropdownFlag"];
        self.arrowImage.userInteractionEnabled = YES;
    }
    return _arrowImage;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [UIView new];
        
        self.tableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.tableView.layer.shadowOffset = CGSizeMake(4, 4);
        self.tableView.layer.shadowOpacity = 0.8;
        self.tableView.layer.shadowRadius = 4;
        self.tableView.layer.borderColor = [UIColor grayColor].CGColor;
        self.tableView.layer.borderWidth = 0.5;
        self.tableView.clipsToBounds = NO;
        self.tableView.rowHeight = kItemCellHeight;
    
    }
    return _tableView;
}

- (UIView *)bgView {
    if (!_bgView) {
        self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgView;
}

@end
