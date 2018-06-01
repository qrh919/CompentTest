//
//  NSObject+Leaks.h
//  CompentTest
//
//  Created by qrh on 2018/5/30.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Leaks)
-(void)swizzleSEL:(SEL)originalSelector withSEL:(SEL)swizzledSelector;
@end
