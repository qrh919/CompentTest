//
//  GCDTestViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/7.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "GCDTestViewController.h"
#import "QGCD.h"

@interface GCDTestViewController ()
@property (nonatomic, strong) NSLock *lock;
@end

@implementation GCDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [QDisQueue executeInMainQueue:^{
//        NSLog(@"--%@",[NSThread currentThread]);
//    } delay:2];
//
//    [QDisQueue executeInMainQueue:^{
//        NSLog(@"=主队列=%@",[NSThread currentThread]);
//    }];
//
//    [QDisQueue executeInGlobalQueue:^{
//        NSLog(@"=全局队列=%@",[NSThread currentThread]);
//    } priority:DISPATCH_QUEUE_PRIORITY_DEFAULT delay:1];
//
//    [[[QDisQueue alloc] initQueue] executeInGlobalQueue:^{
//        NSLog(@"=全局队列=%@",[NSThread currentThread]);
//    } delay:2];
    
    
    
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
    [self test7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//并行队列
-(void)test1{
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    
}
//串行队列
-(void)test2{
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    
}
//等待完成
-(void)test3{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"3");
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"完成");
    });
}

//dispatch_group_enter：通知group，下面的任务马上要放到group中执行了。
//dispatch_group_leave：通知group，任务完成了，该任务要从group中移除了。
//dispatch_group_enter dispatch_group_leave 需成对使用
-(void)test4{
    dispatch_queue_t queue = dispatch_queue_create("test.qrh.com", 0);
    dispatch_group_t group = dispatch_group_create();
    //异步执行
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            sleep(1);
            NSLog(@"1===%d",i);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            sleep(1);
            NSLog(@"2===%d",i);
        }
        dispatch_group_leave(group);
    });
    //同步执行
    dispatch_group_enter(group);
    dispatch_sync(queue, ^{
        for (int i = 0; i<5; i++) {
            sleep(1);
            NSLog(@"11===%d",i);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_sync(queue, ^{
        for (int i = 0; i<5; i++) {
            sleep(1);
            NSLog(@"22===%d",i);
        }
        dispatch_group_leave(group);
    });
    
}
//dispatch_semaphore_t
//信号量进行加锁同步线程
-(void)test5{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"1");
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(queue, ^{
            NSLog(@"2");
        });
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
    });
}
//加锁NSLock
-(void)test6{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    _lock = [[NSLock alloc] init];
    NSLog(@"------start--------");
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"1");
        [self task:@"1"];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2");
        [self task:@"2"];
    });
}

-(void)task:(NSString *)index{
    if(_lock){
        [_lock lock];
        sleep(2);
        NSLog(@"task---%@",index);
        [_lock unlock];
    }
}
//@synchronized
-(void)test7{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    NSLog(@"------start--------");
    dispatch_async(queue, ^{
        @synchronized(self){
            sleep(2);
            NSLog(@"1");
        }
    });
    
    dispatch_async(queue, ^{
        sleep(1);
        @synchronized(self){
            NSLog(@"2");
        }
    });
}

@end
