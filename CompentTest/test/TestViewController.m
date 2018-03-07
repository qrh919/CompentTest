//
//  TestViewController.m
//  CompentTest
//
//  Created by qrh on 2018/1/4.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "TestViewController.h"
#import "TestCoreFoundation.h"

@interface TestViewController ()
@property (nonatomic, strong) UIView *testview;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"测试";
    self.indexId = @"1";
    self.array = [NSMutableArray arrayWithArray:@[@"1",@"2"]];
    [self.view addSubview:self.testview];
    
    TestCoreFoundation *model = [[TestCoreFoundation alloc] init];
    [model test1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"---被释放---");
}

-(UIView *)testview{
    if(!_testview){
        _testview = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
        _testview.backgroundColor = [UIColor redColor];
    }
    return _testview;
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
