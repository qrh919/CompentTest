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
@property (nonatomic, strong) NSMutableArray *dataArr;
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
//    [self test7];
//    [self test8];
//    [self test9];
//    [self test10];
    [self test11];
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

-(void)test8{
    _dataArr = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<10; i++) {
        
        dispatch_async(queue, ^{
            [_dataArr addObject:@(i)];
        });
        dispatch_barrier_async(queue, ^{
            NSLog(@"------");
        });
        dispatch_async(queue, ^{
            NSLog(@"%@",_dataArr);
        });
    }
}

//dispatch_async_f 异步调用指定函数 context为参数
-(void)test9{
    int context = 10;
    dispatch_async_f(dispatch_get_global_queue(0, 0), &context, testfunc);
}
void testfunc(void *num){
    int *c = num;
    NSLog(@"num = %d",*c);
}

//测试执行顺序
-(void)test10{
    //DISPATCH_QUEUE_CONCURRENT 时 打印的正确顺序为：4123
    //DISPATCH_QUEUE_SERIAL 时 奔溃了，因为队列是同步队列开启的异步线程相当于只有一条线程，如果此时再调用同步执行会造成死锁
    NSLog(@"0 = %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("testqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"1 = %@",[NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"4");
    dispatch_async(queue, ^{
        int i = 10;
        while (i>0) {
            i--;
            sleep(1);
            NSLog(@"%d",i);
        }
    });
    
}
//
-(void)test11{
    NSLog(@"1");
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"3");
        //不会调用testTest11 因为子线程runloop未开启,默认不会调用timer的任务
        [self performSelector:@selector(testTest11) withObject:nil afterDelay:1.0f];
        //子线程默认没有开启runloop需手动打开即可解决
        [[NSRunLoop currentRunLoop] run];
        //会调用testTest11 因为是直接在当前线程调用
//        [self performSelector:@selector(testTest11) withObject:nil];
        NSLog(@"4");
    });
    NSLog(@"2");
}
-(void)testTest11{
    NSLog(@"5");
}

@end
