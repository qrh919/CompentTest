//
//  QPopMenuView.h
//  CompentTest
//
//  Created by qrh on 2017/10/25.
//  Copyright © 2017年 qrh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QPopMenuView;

@protocol QPopMenuViewDelegate <NSObject>
/** 菜单点击的位置 0开始 */
- (void)popMenuView:(QPopMenuView *)menuView clickedAtIndex:(NSInteger)index;
@end

@interface QPopMenuView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id<QPopMenuViewDelegate> delegate;
/**
 点击每一栏时通过block回调,0开始,
 */
@property (nonatomic, copy) void (^menuViewClickedBlock)(NSInteger index);

/**
 初始化对象
 
 @param point 箭头指向的位置
 @param imageArray image对象或者图片名称
 @param titleArray 显示的标题, titleArray和imageArray的个数需保持一致
 @return 初始化对象
 */
- (instancetype)initWithPositionOfDirection:(CGPoint)point images:(NSArray *)imageArray titleArray:(NSArray<NSString *> *)titleArray;

@end
