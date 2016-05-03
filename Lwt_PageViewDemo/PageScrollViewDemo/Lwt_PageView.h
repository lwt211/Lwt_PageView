//
//  Lwt_PageView.h
//  PageScrollViewDemo
//
//  Created by 李文韬 on 16/4/22.
//  Copyright © 2016年 秀软. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^CurrentPageBlock)(UIImageView *imageView,NSInteger page);

typedef void(^ClickBlock)(UIImageView *imageView,NSInteger page);

@interface Lwt_PageView : UIView


@property (nonatomic,strong) UIColor *currentPageColor;//当前页标签颜色  默认白色
@property (nonatomic,strong) UIColor *tintPageColor;//非当前页标签颜色   默认灰色


/**
 *  初始化轮播
 *
 *  @param frame          <#frame description#>
 *  @param imageS         图片数组
 *  @param repeat         是否循环
 *  @param showHorizontal 是  水平方向  否 竖直方向（无标标签页码）

 */

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)imageS repeat:(BOOL)repeat showHorizontal:(BOOL)showHorizontal;

/**
 *  启动定时器（repeat 为NO是不能使用）
 */

- (void)startRepeatScroll:(NSTimeInterval)animationDuration;

/**
 * 停止定时器
 */
- (void)stopRepeatScroll;


/**
 *  点击回调
 */
- (void)clickBlock:(ClickBlock)clickBlock;


/**
 *  获取当前页面回调
 */

- (void)currentPageViewBlock:(CurrentPageBlock)currentPageblock;


/**
 *  隐藏标签页
 */

- (void)pageHidden:(BOOL)hidden ;


/**
 设置页码标签 在视图里的位置
 */
- (void)setPageContolFrame:(CGRect)frame;



@end
