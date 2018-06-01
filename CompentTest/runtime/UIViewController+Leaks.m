//
//  UIViewController+Leaks.m
//  CompentTest
//
//  Created by qrh on 2018/5/30.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "UIViewController+Leaks.h"
#import "NSObject+Leaks.h"

@implementation UIViewController (Leaks)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(viewDidAppear:) withSEL:@selector(swizzel_viewDidAppear:)];
        [self swizzleSEL:@selector(viewDidDisappear:) withSEL:@selector(swizel_viewDidDisappear:)];
    });
}

-(void)swizzel_viewDidAppear:(BOOL)animated{
    [self swizzel_viewDidAppear:animated];
}

-(void)swizel_viewDidDisappear:(BOOL)animated{
    [self swizel_viewDidDisappear:animated];
}

@end
