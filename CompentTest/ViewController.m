//
//  ViewController.m
//  CompentTest
//
//  Created by qrh on 2017/10/20.
//  Copyright © 2017年 qrh. All rights reserved.
//

#import "ViewController.h"
#import "SBViewController.h"
#import "QPopMenuView.h"
#import "YBPopupMenu.h"
//#import "PNCTestViewController.h"
#import "TestViewController.h"
#import "QShowWaterViewController.h"
#import "NFCTestViewController.h"
#import "ChangeCellHeightController.h"
#import "CycleViewViewController.h"
#import "FMDBViewController.h"
#import "GCDTestViewController.h"
#import "AnimationTestViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //
    self.dataArr = @[@"searchBar",@"pnChart",@"test",@"水波纹",@"NFC",@"UIKit",@"轮播",@"FMDB",@"GCD",@"动画"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    dispatch_apply(100, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
//        NSLog(@"--%ld",i);
//    });
//    NSLog(@"=====");
}

- (void)rightBarButtonItemClicked
{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 6; i++) {
        NSString *name = [NSString stringWithFormat:@"%d",i + 1];
        UIImage *image  = [UIImage imageNamed:name];
        [imageArray addObject:image];
        
    }
    
    [YBPopupMenu showAtPoint:CGPointMake(200, 200) titles:@[@"扫一扫"] icons:@[@"yqw_icon_scan"] menuWidth:120 delegate:nil];
    
    QPopMenuView *menuView = [[QPopMenuView alloc] initWithPositionOfDirection:CGPointMake(self.view.frame.size.width - 24, 0) images:imageArray titleArray:@[@"我是第一栏",@"我是第二栏",@"我是第三栏",@"我是第四栏",@"我是第五栏",@"我是最后一栏",]];
    //    menuView.delegate = self;
    menuView.menuViewClickedBlock = ^(NSInteger index) {
        NSLog(@"%ld",index);
    };
    [self.view addSubview:menuView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultCellId = @"defaultCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *nextVC;
    switch (indexPath.row) {
        case 0:
            nextVC = [[SBViewController alloc] init];
            break;
        case 1:
            
            break;
        case 2:
            nextVC = [[TestViewController alloc] init];
            break;
        case 3:
            nextVC = [[QShowWaterViewController alloc] init];
            break;
        case 4:
            nextVC = [[NFCTestViewController alloc] init];
            break;
        case 5:
            nextVC = [[ChangeCellHeightController alloc] init];
            break;
        case 6:
            nextVC = [[CycleViewViewController alloc] init];
            break;
        case 7:
            nextVC = [[FMDBViewController alloc] init];
            break;
        case 8:
            nextVC = [[GCDTestViewController alloc] init];
            break;
        case 9:
            nextVC = [[AnimationTestViewController alloc] init];
            break;
        default:
            break;
    }
    if(nextVC){
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
