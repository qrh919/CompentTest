//
//  StudentAddEditViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/5.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "StudentAddEditViewController.h"
#import "MYDBManager.h"
#import "Student.h"

@interface StudentAddEditViewController ()
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *sexField;
@property (nonatomic, strong) UITextField *ageField;
@end

@implementation StudentAddEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------------
- (void)successAction:(UIBarButtonItem *)sender{
    __weak typeof(self) wkSelf = self;
    if(_student){
        NSString *editSql = @"update t_student set name = ?,age = ?,sex = ? where sid = ?";
        NSArray *params = @[_nameField.text,@([_ageField.text intValue]),_sexField.text,@(_student.sid)];
        [MYDBManager deleteOrUpdateSql:editSql params:params callBack:^(BOOL flag) {
            NSLog(@"%@",flag?@"成功":@"失败");
            if(flag){
                [wkSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        NSString *sql = @"INSERT INTO t_student (name, age, sex) VALUES (?,?,?)";
        NSArray *params = @[_nameField.text,@([_ageField.text intValue]),_sexField.text];
        [MYDBManager insertSql:sql params:params callBack:^(BOOL flag) {
            NSLog(@"%@",flag?@"成功":@"失败");
            if(flag){
                [wkSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}
- (void)initializeConfig
{
    self.navigationItem.title = @"FMDB";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(successAction:)];
  
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _nameField.placeholder = @"姓名";
    [self.view addSubview:_nameField];
    
    _sexField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    _sexField.borderStyle = UITextBorderStyleRoundedRect;
    _sexField.placeholder = @"性别";
    [self.view addSubview:_sexField];
    
    _ageField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 100, 40)];
    _ageField.borderStyle = UITextBorderStyleRoundedRect;
    _ageField.placeholder = @"年龄";
    [self.view addSubview:_ageField];
    if(self.student){
        _nameField.text = _student.name;
        _sexField.text = _student.sex;
        _ageField.text = [NSString stringWithFormat:@"%d",_student.age];
    }
}

@end
