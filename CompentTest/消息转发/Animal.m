//
//  Animal.m
//  CompentTest
//
//  Created by qrh on 2018/5/10.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "Animal.h"

@implementation Animal

-(void)sendMessage:(NSString *)message{
    NSLog(@"%@ = %@",NSStringFromClass([self class]),message);
}

@end
