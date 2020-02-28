//
//  RectPageControl.h
//  XJPH
//
//  Created by Xinbo Hong on 2018/6/23.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIPageControl


/**
 设置圆点的宽度和间距

 @param dotWidth 宽度
 @param margin 间距
 */
- (void)setDodWidth:(CGFloat)dotWidth margin:(CGFloat)margin;


/**
 设置圆点的图片和选中图片

 @param pageImage 默认图片
 @param currentPageImage 选中图片
 */
- (void)setPageImage:(UIImage *)pageImage CurrentPageImage:(UIImage *)currentPageImage;
@end
