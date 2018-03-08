//
//  AnimationTestViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/8.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "AnimationTestViewController.h"
#import "SnapshotViewController.h"

@interface AnimationTestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@end

@implementation AnimationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataDic = [NSMutableDictionary dictionary];
    [_dataDic setValue:@"SnapshotViewController" forKey:@"截屏动画"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataDic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultCellId = @"defaultCellId2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    NSString *key = [_dataDic.allKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [_dataDic.allKeys objectAtIndex:indexPath.row];
    UIViewController *vc = [[NSClassFromString([_dataDic valueForKey:key]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

@end
