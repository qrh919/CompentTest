//
//  RACAPITestViewController.m
//  CompentTest
//
//  Created by qrh on 2018/1/18.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "RACAPITestViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>

@interface RACAPITestViewController ()
@property (nonatomic, strong) RACDisposable *timeDisp;
@end

@implementation RACAPITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
//    [self test2];
    [self test3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//冷热信号号
/*
 热信号指，即使外部没有订阅，里面已经源源不断发送值了,你在订阅的时候如果前面的信号错过了就错过了不会再有,这就是为何RACSubject为何要先订阅才能收到信号的原因;冷信号因为每次订阅都会执行一次，每个订阅都是独立行为。这和我们是否去订阅他并没有什么直接的关系,在RAC2中 RACSignal是信号，RACSubject是热信号，RACSignal和子类排除RACSubject是冷信号,而在RAC4中signal是热信号 SignalProducer是冷信号.
 */
-(void)test1{
    //创建 冷信号
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"信号创建");
        //发送消息
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [subscriber sendNext:@"发送消息1"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@"发送消息2"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"发送消息3"];
            [subscriber sendCompleted];//发送完成
        }];
        //此处可以返回RACDisposable
        return [RACDisposable disposableWithBlock:^{
            
        }];
//        return nil;
    }];
    //订阅信息
    [coldSignal subscribeNext:^(id x) {
        NSLog(@"x=%@",x);
    }];
    
    
    //改为热信号
    RACSubject *subject = [RACSubject subject];
    //RACMulticastConnection将多个订阅了该信号的任务串联
    RACMulticastConnection *multicastCon = [coldSignal multicast:subject];
    RACSignal *hotSignal = multicastCon.signal;
//    RACSignal *hotSignal2 = multicastCon.autoconnect;//自动连接并返回信号
    //建立连接
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [multicastCon connect];
    }];
    
    [hotSignal subscribeNext:^(id x) {
        NSLog(@"热信号接收1:%@", x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
        [hotSignal subscribeNext:^(id x) {
            NSLog(@"热信号接收2:%@", x);
        }];
    }];
}

//RAC中的定时器 底层基于GCD
-(void)test2{
    __block int time = 60;
    _timeDisp = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        time--;
        NSLog(@"%d",time);
        if(time == 0){
            [_timeDisp dispose];//销毁订阅者
        }
    }];
}
//创建命令 执行信号
-(void)test3{
    //初始化方法里需要返回一个当前受命令的信号
    RACCommand *commamd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //发送一个任务
            [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
                [subscriber sendNext:@"测试一下"];
            }];
            return nil;
        }];
    }];
//    //法1
//    RACSignal *signal = [commamd execute:@"开始执行命令"];
//    [signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    //法2 该方法需写在execute之前 否则不执行
    [commamd.executionSignals subscribeNext:^(id x) {
        NSLog(@"1111=%@",x);
        //此时x为动态创建的信号
        [x subscribeNext:^(id x1) {
            NSLog(@"2222=%@",x1);
        }];
    }];
    [commamd execute:@"开始执行命令"];
//    获取最后一个信号
//    commamd.executionSignals.switchToLatest
}

//bind的用法
-(void)test4{
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //绑定信号
    RACSignal *signal = [subject bind:^RACStreamBindBlock{
        return ^RACSignal *(id value, BOOL *stop){
            NSLog(@"x = %@",value);
            return [RACReturnSignal return:value];
        };
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"x= %@",x);
    }];
    [subject sendNext:@"发送任务"];
}

@end













