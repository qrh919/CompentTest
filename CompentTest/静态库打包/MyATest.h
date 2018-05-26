//
//  MyATest.h
//  MyATest
//
//  Created by qrh on 2018/5/17.
//  Copyright © 2018年 qrh. All rights reserved.
//
/*
 
 build settings -> Build Active Architecture Only 设为NO 为适配所有机型  (真机需选中Generic ios Devices)
 info 下面 use Release / Debug 设置静态库打包模式
 
 
 //======================静态库冲突重新打包攻略========================//
 1、打开终端，直接输入
 
 cd ~/ && mkdir librepack && cd librepack
 
 2、把项目中的引发冲突的.a文件拷贝一份出来，/Users/momo/Desktop/SVN/Payment/Payment/ipos是文件路径。
 
 cp /Users/momo/Desktop/SVN/Payment/Payment/ipos/libiPosLib.a ./libx.a
 
 3、查看包信息
 
 lipo -info libx.a
 
 结果：此SDK支持armv7,arm64
 
 
 4、分平台逐步做以下步骤
 
 4.1、创建临时文件夹，用于存放armv7平台解压后的.o文件：
 
 mkdir armv7
 
 4.2、取出armv7平台的包
 
 lipo libx.a -thin armv7 -output armv7/libx-armv7.a
 
 4.3、查看库中所包含的文件列表
 
 ar -t armv7/libx-armv7.a
 
 4.4、解压出object file（即.o后缀文件）
 
 cd armv7 && ar xv libx-armv7.a
 
 4.5、找到冲突的包（JSONKit），删除掉（此步可以多次操作）
 
 rm WapAuthHandler.o
 
 4.6、重新打包object file
 
 cd .. && ar rcs libx-armv7.a armv7/*.o
 
 5、多平台的SDK的话，需要多次操作第4步。操作完成后，合并多个平台的文件为一个.a文件
 
 lipo -create libx-armv7.a libx-arm64.a -output libiPosLib-new.a
 
 6、拷贝到项目中覆盖源文件：
 
 cp libiPosLib-new.a /Users/momo/Desktop/SVN/Payment/Payment/ipos/libiPosLib.a
 
 
 
 PS:每步严格按照步骤来做，唯一能该更改的内容是armv7,armv7s,arm64。
 
 
 
 */
#import <Foundation/Foundation.h>

@interface MyATest : NSObject
+(void)showMyName:(NSString *)name;
@end
