//
//  RACShowView.h
//  CompentTest
//
//  Created by qrh on 2018/1/18.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACShowView : UIView

@property (nonatomic, copy) NSString *name;

//添加响应信号
@property (nonatomic, strong) RACSubject *subject;

@end
