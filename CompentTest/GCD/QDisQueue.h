//
//  QDisQueue.h
//  CompentTest
//
//  Created by qrh on 2018/3/7.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDisQueue : NSObject

@property (nonatomic, readonly, strong) dispatch_queue_t executeQueue;

/**
 类方法
 */
+(instancetype)mainQueue;
+(instancetype)globalQueue;
+(instancetype)globalQueueWithPriority:(long)priority;

+(void)executeInMainQueue:(dispatch_block_t)block;
+(void)executeInGlobalQueue:(dispatch_block_t)block;
+(void)executeInGlobalQueue:(dispatch_block_t)block priority:(long)priority;
+(void)executeInMainQueue:(dispatch_block_t)block delay:(NSTimeInterval)delay;
+(void)executeInGlobalQueue:(dispatch_block_t)block delay:(NSTimeInterval)delay;
+(void)executeInGlobalQueue:(dispatch_block_t)block priority:(long)priority delay:(NSTimeInterval)delay;
/**
 对象方法
 */
-(instancetype)initQueue;
-(instancetype)initQueueWithIndentifier:(NSString *)identifier andAttr:(dispatch_queue_attr_t)attr;
-(void)executeInGlobalQueue:(dispatch_block_t)block delay:(NSTimeInterval)delay;
@end
