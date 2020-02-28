//
//  RoomListPopViewController.h
//  IQUP
//
//  Created by Xinbo Hong on 2017/12/16.
//  Copyright © 2017年 xigu. All rights reserved.
//


/*
 *  控件名称:    下方弹出选项
 *  控件完成情况: 基本完成，还需优化
 *  最后记录时间: 2018/4/11
 */

#import <UIKit/UIKit.h>

@protocol ListPopViewTableViewDeledate <NSObject>

@optional

- (void)listPopTableView:(UITableView *)leftView didSelectedAtIndexPath:(NSIndexPath *)indexPath;

- (void)listPopTableView:(UITableView *)leftView deleteCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)listPopTableView:(UITableView *)leftView longPressAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ListPopViewController : UIViewController

@property (nonatomic, weak) id<ListPopViewTableViewDeledate> delegate;

@property (nonatomic, strong) NSString *titleStr;

- (void)setListItemArray:(NSArray *)listArray;

@end
