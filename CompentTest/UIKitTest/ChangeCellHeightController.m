//
//  ChangeCellHeightController.m
//  CompentTest
//
//  Created by qrh on 2018/2/26.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "ChangeCellHeightController.h"
#import "LoadTest.h"

@interface ChangeCellHeightController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ChangeCellHeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeConfig];
    LoadTest *test = [[LoadTest alloc] init];
    [test showData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger isOn = [_dataArr[indexPath.row][@"isOn"] integerValue];
    if(isOn){
        return 100;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultCellId = @"defaultCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    for (UIButton *button in cell.contentView.subviews) {
        [button removeFromSuperview];
    }
    cell.textLabel.text = _dataArr[indexPath.row][@"name"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.bounds.size.width-100, 10, 50, 30);
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.tag = indexPath.row;
    NSInteger isOn = [_dataArr[indexPath.row][@"isOn"] integerValue];
    if(isOn){
        [btn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"展开" forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    return cell;
}

- (void)changeAction:(UIButton *)sender{
    NSMutableDictionary *dic = [_dataArr objectAtIndex:sender.tag];
    NSInteger isOn = [[dic valueForKey:@"isOn"] integerValue];
    if(isOn){
        [dic setValue:@0 forKey:@"isOn"];
    }else{
        [dic setValue:@1 forKey:@"isOn"];
    }
    [_tableView beginUpdates];
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

- (void)initializeConfig{
    _dataArr = @[[NSMutableDictionary dictionaryWithObjectsAndKeys:@"张三",@"name",0,@"isOn", nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"李四",@"name",0,@"isOn", nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"王五",@"name",0,@"isOn", nil]
                 ];
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
