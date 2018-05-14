//
//  QFileDLMananger.h
//  CompentTest
//
//  Created by qrh on 2018/3/9.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface QFileDLMananger : NSObject

//-(instancetype)init __attribute__((unavailable("init not available, call 'initWithUrl' instead")));
//
//-(instancetype)initWithURL:(NSString *)urlString;

+(void)downloadWithURL:(NSString *_Nonnull)urlString withProgress:(void (^__nullable)(CGFloat progress))progress;



@end
