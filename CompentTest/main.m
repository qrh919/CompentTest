//
//  main.m
//  CompentTest
//
//  Created by qrh on 2017/10/20.
//  Copyright © 2017年 qrh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/**
 app启动时间检测打开方式
 在Edit Scheme -> Argument->环境变量里面添加DYLD_PRINT_STATISTICS 值为1
 */

CFAbsoluteTime startTime;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        startTime = CFAbsoluteTimeGetCurrent();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
