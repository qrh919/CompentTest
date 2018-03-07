//
//  NFCTestViewController.h
//  CompentTest
//
//  Created by qrh on 2018/2/8.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 使用NFC前需要注意一下几点：
 iOS 11以后才支持 iPhone7 及以上
 需要开启一个session，与其他session类似，同时只能开启一个
 需要App完全在前台模式
 每个session最多扫描60s，超时需再次开启新session
 配置读取单个或多个Tag，配置为单个时，会在读取到第一个Tag时自动结束session
 隐私描述（后文会写到如何配置）会在扫描页面显示
 
 第一步需要配置Capabilities
 使用NFC，第一步需要配置Capabilities，这会自动为你生成entitlements文件中的必要配置。同时为你的App ID激活相关功能。
 entitlements 应该有 com.apple.developer.nfc.readersession.formats  NDEF
 
 第二步打开隐私相关设置
 第二步需要打开隐私相关设置，向info.plist中添加Privacy - NFC Scan Usage Description。
 
 第三步引入Core NFC
 #import <CoreNFC/CoreNFC.h>
 
 第四步实现NFCNDEFReaderSessionDelegate。
 
 第五步开始一个session
 
 */

@interface NFCTestViewController : UIViewController

@end
