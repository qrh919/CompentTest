//
//  LoadTest.h
//  CompentTest
//
//  Created by qrh on 2018/2/28.
//  Copyright © 2018年 qrh. All rights reserved.
//

/*
 load方法 内部调用的是函数地址
 父类 子类 分类 互不影响 且调用顺序为父类->子类->分类
 1、+load方法是在main函数之前调用的；
 2、遵从先父类后子类，先本类后列类别的顺序调用；
 3、类,父类与分类之间的调用是互不影响的.子类中不需要调用super方法，也不会调用父类的+load方法实现；
 4、无论该类是否接收消息，都会调用+load方法
 
 initialize方法

 1.+initialize方法是在main函数之后调用的；
 2.+initialize方法遵从懒加载方式,只有在类或它的子类收到第一条消息之前被调用的;
 3.子类中不需要调用super方法，会自动调用父类的方法实现；
 4.+initialize只调用一次,init可多次调用.
 
 */

#import <Foundation/Foundation.h>

@interface LoadTest : NSObject

-(void)showData;

@end
