//
//  QDisQueue.m
//  CompentTest
//
//  Created by qrh on 2018/3/7.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "QDisQueue.h"

static QDisQueue *mainQueue;
static QDisQueue *globalQueue;
static QDisQueue *normalQueue;


@interface QDisQueue()
@property (nonatomic, strong) dispatch_queue_t executeQueue;
@end

@implementation QDisQueue

+(void)initialize{
    if (self == [QDisQueue self]) {
        mainQueue = [QDisQueue new];
        globalQueue = [QDisQueue new];
        normalQueue = [QDisQueue new];
        
        mainQueue.executeQueue = dispatch_get_main_queue();
        globalQueue.executeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }

}

+(instancetype)mainQueue{
    return mainQueue;
}

+(instancetype)globalQueue{
    return globalQueue;
}

+(instancetype)globalQueueWithPriority:(long)priority{
    normalQueue.executeQueue = dispatch_get_global_queue(priority, 0);
    return normalQueue;
}

+(void)executeInMainQueue:(dispatch_block_t)block{
    NSParameterAssert(block);
    dispatch_async(mainQueue.executeQueue, block);
}

+(void)executeInGlobalQueue:(dispatch_block_t)block{
    NSParameterAssert(block);
    dispatch_async(globalQueue.executeQueue, block);
}

+(void)executeInGlobalQueue:(dispatch_block_t)block priority:(long)priority{
    NSParameterAssert(block);
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

+(void)executeInMainQueue:(dispatch_block_t)block delay:(NSTimeInterval)delay{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), mainQueue.executeQueue, block);
}

+(void)executeInGlobalQueue:(dispatch_block_t)block delay:(NSTimeInterval)delay{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), globalQueue.executeQueue, block);
}

+(void)executeInGlobalQueue:(dispatch_block_t)block priority:(long)priority delay:(NSTimeInterval)delay{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_global_queue(priority, 0), block);
}



//*****************************//
/**
 DISPATCH_QUEUE_SERIAL 串行队列 先进先出
 DISPATCH_QUEUE_CONCURRENT 并发队列
 */
-(instancetype)initQueue{
    if (self = [super init]) {
        self.executeQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

-(instancetype)initQueueWithIndentifier:(NSString *)identifier andAttr:(dispatch_queue_attr_t)attr{
    if (self = [super init]) {
        self.executeQueue = dispatch_queue_create(identifier.UTF8String, attr);
    }
    return self;
}

-(void)executeInGlobalQueue:(dispatch_block_t)block delay:(NSTimeInterval)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), self.executeQueue,block);
}

- (void)resume{
    dispatch_resume(self.executeQueue);
}

- (void)suspend{
    dispatch_suspend(self.executeQueue);
}

- (void)barrierExecute: (dispatch_block_t)block{
    NSParameterAssert(block);
    dispatch_barrier_async(self.executeQueue, block);
}
/*************************/
/*
            线程优先级                          对应的分发
 默认  DISPATCH_QUEUE_PRIORITY_DEFAULT     QOS_CLASS_USER_INTERACTIVE
 高    DISPATCH_QUEUE_PRIORITY_HIGH        QOS_CLASS_USER_INITIATED
 低    DISPATCH_QUEUE_PRIORITY_LOW         QOS_CLASS_UTILITY
 后台  DISPATCH_QUEUE_PRIORITY_BACKGROUND  QOS_CLASS_BACKGROUND
 
 */
@end
