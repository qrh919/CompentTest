//
//  QWaterView.h
//  CompentTest
//
//  Created by qrh on 2018/1/29.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, QWaterType) {
    
    QWaterTypeFromTop,      //从顶部开始
    QWaterTypeFromBottom    //从底部开始
    
};
@interface QWaterView : UIView

@property (nonatomic, assign) CGFloat amplitude;//振幅
@property (nonatomic, assign) CGFloat cycle;//周期 (视图范围内的周期)

@property (nonatomic, assign) QWaterType type;

- (void)startWave;

@end
