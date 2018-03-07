//
//  QShowWaterViewController.m
//  CompentTest
//
//  Created by qrh on 2018/1/29.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "QShowWaterViewController.h"
#import "QWaterView.h"

@interface QShowWaterViewController ()

@end

@implementation QShowWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    QWaterView *waterView = [[QWaterView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    waterView.amplitude = 20;
    waterView.cycle = 2 * M_PI;
    waterView.type = QWaterTypeFromTop;
    [waterView startWave];
    [self.view addSubview:waterView];
    
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
