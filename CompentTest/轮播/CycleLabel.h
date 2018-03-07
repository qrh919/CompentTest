//
//  CycleLabel.h
//  CompentTest
//
//  Created by qrh on 2018/3/6.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleLabel : UILabel

- (instancetype)initWithFrame:(CGRect)rect array:(NSArray *)array;

@property (nonatomic, copy) void (^indexClick)(NSInteger index);

@end
