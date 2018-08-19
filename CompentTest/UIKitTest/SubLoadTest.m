//
//  SubLoadTest.m
//  CompentTest
//
//  Created by qrh on 2018/2/28.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "SubLoadTest.h"

@implementation SubLoadTest

+(void)load{
    NSLog(@"子类%@",NSStringFromClass([self class]));
}

+(void)initialize{
    NSLog(@"子类 %s",__func__);
}

@end
