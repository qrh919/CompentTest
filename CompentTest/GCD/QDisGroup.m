//
//  QDisGroup.m
//  CompentTest
//
//  Created by qrh on 2018/3/6.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "QDisGroup.h"

@interface QDisGroup()
@property (nonatomic, strong) dispatch_group_t executeGroup;
@end

@implementation QDisGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.executeGroup = dispatch_group_create();
    }
    return self;
}
/* 一直等待 */
-(void)wait{
    dispatch_group_wait(self.executeGroup, DISPATCH_TIME_FOREVER);
}
/* 一直等待多少秒

 1   NSEC_PER_SEC，每秒有多少纳秒。
 2   USEC_PER_SEC，每秒有多少毫秒。（注意是指在纳秒的基础上）
 3   NSEC_PER_USEC，每毫秒有多少纳秒。
 */
-(void)wait:(NSTimeInterval)delay{
    dispatch_group_wait(self.executeGroup, delay * NSEC_PER_SEC);
}

/* 需与 leave方法一起使用 成对出现 */
-(void)enter{
    dispatch_group_enter(self.executeGroup);
}

/* 需与 enter方法一起使用 成对出现 */
-(void)leave{
    dispatch_group_leave(self.executeGroup);
}

@end
