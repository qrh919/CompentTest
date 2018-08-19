//
//  AppDelegate+Extension.m
//  CompentTest
//
//  Created by qrh on 2017/10/20.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "AppDelegate+Extension.h"
#import <objc/runtime.h>

static char *kNameKey = "nameKey";

@implementation AppDelegate (Extension)

-(void)setName:(NSString *)name{
    objc_setAssociatedObject(self, &kNameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)name{
    return objc_getAssociatedObject(self, &kNameKey);
}

@end
