//
//  FMDBViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/5.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "FMDBViewController.h"
#import "StudentAddEditViewController.h"
#import "MYDBManager.h"
#import "Student.h"

@interface FMDBViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeConfig];
    [MYDBManager dbOpen];
    [MYDBManager createTableSql:@"CREATE TABLE IF NOT EXISTS t_student (sid integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL, sex text NOT NULL);"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArr = [NSMutableArray arrayWithArray:[MYDBManager selectSql:@"select * from t_student order by age asc"]];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defaultCellId = @"defaultCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    Student *student = [_dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d岁",student.age];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Student *s = [_dataArr objectAtIndex:indexPath.row];
        [_dataArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSString *deleteSql = @"delete from t_student where sid = ?";
        NSArray *array = @[@(s.sid)];
        [MYDBManager deleteOrUpdateSql:deleteSql params:array callBack:^(BOOL flag) {
            NSLog(@"%@",flag?@"成功":@"失败");
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentAddEditViewController *nextVC = [StudentAddEditViewController new];
    Student *student = [_dataArr objectAtIndex:indexPath.row];
    nextVC.student = student;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark-------------
- (void)addAction:(UIBarButtonItem *)sender{
    StudentAddEditViewController *nextVC = [StudentAddEditViewController new];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (void)initializeConfig
{
    self.navigationItem.title = @"FMDB";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    [self.view addSubview:self.tableView];
    _dataArr = [NSMutableArray array];
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

@end


