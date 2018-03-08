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

@end

@implementation GCDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [QDisQueue executeInMainQueue:^{
        NSLog(@"--%@",[NSThread currentThread]);
    } delay:2];

    [QDisQueue executeInMainQueue:^{
        NSLog(@"=主队列=%@",[NSThread currentThread]);
    }];

    [QDisQueue executeInGlobalQueue:^{
        NSLog(@"=全局队列=%@",[NSThread currentThread]);
    } priority:DISPATCH_QUEUE_PRIORITY_DEFAULT delay:1];
    
    [[[QDisQueue alloc] initQueue] executeInGlobalQueue:^{
        NSLog(@"=全局队列=%@",[NSThread currentThread]);
    } delay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
