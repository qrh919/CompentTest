//
//  NFCHelper.h
//  CompentTest
//
//  Created by qrh on 2018/2/10.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFCHelper : NSObject

@property (nonatomic, copy) void (^onNFCResultBlock)(BOOL status, NSString *result);

-(void)restartSession;

@end
