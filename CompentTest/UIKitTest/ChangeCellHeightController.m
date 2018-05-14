//
//  ChangeCellHeightController.m
//  CompentTest
//
//  Created by qrh on 2018/2/26.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "ChangeCellHeightController.h"
#import "LoadTest.h"
#import <Masonry.h>

@interface ChangeCellHeightController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ChangeCellHeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeConfig];
    /*
    //设置视图位置和大小
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(120, 300, 100, 50)];
    
    //设置背景颜色
    myView.backgroundColor = [UIColor redColor];
    
    //添加
    [self.view addSubview:myView];
    
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:myView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    //设置大小
    maskLayer.frame = myView.bounds;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    myView.layer.mask = maskLayer;
    
    UILabel *label = [[UILabel alloc]init];
    
    //添加文字
    label.text = @"willwang";
    
    //文字颜色
    label.textColor = [UIColor whiteColor];
    
    [myView addSubview: label];
    
    //自动布局
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(myView);
    }];
    
    LoadTest *test = [[LoadTest alloc] init];
    [test showData];
    */
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
        return 500;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offy = scrollView.contentOffset.y;
    if(offy > (self.headerView.frame.size.height-64-50)){
        [self.view addSubview:self.segmentView];
        [_segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@64);
            make.left.right.equalTo(_headerView);
            make.height.equalTo(@50);
        }];
    }else{
        [self.headerView addSubview:self.segmentView];
        [_segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_headerView);
            make.height.equalTo(@50);
        }];
    }
}

- (void)initializeConfig{
    _dataArr = @[[NSMutableDictionary dictionaryWithObjectsAndKeys:@"张三",@"name",0,@"isOn", nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"李四",@"name",0,@"isOn", nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"王五",@"name",0,@"isOn", nil]];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_headerView);
        make.height.equalTo(@50);
    }];
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

-(UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _headerView.backgroundColor = [UIColor grayColor];
    }
    return _headerView;
}
-(UIView *)segmentView{
    if(!_segmentView){
        _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        _segmentView.backgroundColor = [UIColor greenColor];
    }
    return _segmentView;
}
@end
