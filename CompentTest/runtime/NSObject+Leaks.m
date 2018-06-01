//
//  NSObject+Leaks.m
//  CompentTest
//
//  Created by qrh on 2018/5/30.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "NSObject+Leaks.h"
#import <objc/runtime.h>

@implementation NSObject (Leaks)

-(void)swizzleSEL:(SEL)originalSelector withSEL:(SEL)swizzledSelector{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzeldMethod = class_getInstanceMethod(class, swizzledSelector);
    //判断当前class是否已经加过交换的方法
    /*
     class_addMethod 参数说明：
     cls：被添加方法的类
     name：可以理解为方法名
     imp：实现这个方法的函数
     types：一个定义该函数返回值类型和参数类型的字符串
     */
    BOOL didSwizzeldMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzeldMethod), method_getTypeEncoding(swizzeldMethod));
    if(didSwizzeldMethod){
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzeldMethod);
    }
}

@end
