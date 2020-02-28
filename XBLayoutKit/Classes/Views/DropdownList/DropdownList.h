//
//  DropdownList.h
//  OCEditProject
//
//  Created by Xinbo Hong on 2020/2/26.
//  Copyright © 2020 com.xinbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DropdownListItem : NSObject

@property (nonatomic, strong, readonly) NSString *itemId;

@property (nonatomic, strong, readonly) NSString *itemName;

- (instancetype)initId:(NSString *)itemId itemName:(NSString *)itemName NS_DESIGNATED_INITIALIZER;

@end


@class DropdownList;
@protocol DropdownListDelegate <NSObject>

- (void)dropdownList:(DropdownList *)dropdownList didSelectItem:(DropdownListItem *)item;

@end

@interface DropdownList : UIView
/// 子项文字
@property (nonatomic, strong) UIColor *textColor;
/// 子项字体
@property (nonatomic, strong) UIFont *font;
/// 数据源
@property (nonatomic, strong) NSArray *dataSource;
/// 选中项序号
@property (nonatomic, assign) NSUInteger selectedIndex;
/// 选中项
@property (nonatomic, strong) DropdownListItem *selectedItem;

@property (nonatomic, weak) id<DropdownListDelegate> delegate;

- (instancetype)initWithDataSource:(NSArray*)dataSource;

- (void)setViewBorder:(CGFloat)width borderColor:(UIColor*)borderColor cornerRadius:(CGFloat)cornerRadius;


@end

NS_ASSUME_NONNULL_END
