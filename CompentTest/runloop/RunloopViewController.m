//
//  RunloopViewController.m
//  CompentTest
//
//  Created by qrh on 2018/8/16.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "RunloopViewController.h"
#import "MyThread.h"

@interface RunloopViewController ()
{
    NSString *_name;
}
@property (nonatomic, assign) BOOL flag;
@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self childThreadTest];
    
    [self addObserver:self forKeyPath:@"flag" options:(NSKeyValueObservingOptionNew) context:nil];
    
    _name = @"123";
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change[NSKeyValueChangeNewKey]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//子线程开启runloop
-(void)childThreadTest{
    _flag = NO;
    MyThread *thread = [[MyThread alloc] initWithBlock:^{
        NSLog(@"开始");
        __block int i = 0;
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            i++;
            NSLog(@"i = %d",i);
            if(i==10){
                [NSThread exit];//退出当前线程
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        while(!_flag){
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
        }
//        [[NSRunLoop currentRunLoop] run];
//        while (true) {
//
//        }
    }];
    
//    [[NSRunLoop currentRunLoop] addTimer:<#(nonnull NSTimer *)#> forMode:<#(nonnull NSRunLoopMode)#>];
    
    [thread start];
    NSLog(@"-------");
}
//改变状态停止子线程runloop
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _flag = YES;
}

@end
