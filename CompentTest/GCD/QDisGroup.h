//
//  QDisGroup.h
//  CompentTest
//
//  Created by qrh on 2018/3/6.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDisGroup : NSObject

@property (nonatomic, readonly, strong) dispatch_group_t executeGroup;

#pragma mark
-(void)wait;
-(void)enter;
-(void)leave;
-(void)wait:(NSTimeInterval)delay;

@end
