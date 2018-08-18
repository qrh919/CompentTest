//
//  RACRootViewController.m
//  CompentTest
//
//  Created by qrh on 2018/1/18.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "RACRootViewController.h"
#import "RACAPITestViewController.h"
#import "RACShowView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface RACRootViewController ()
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) RACShowView *showView;
@end

@implementation RACRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializePageSubviews];
    
    //按钮添加点击响应
    [[self.sendBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        NSLog(@"x= %@",x);
    } completed:^{
        NSLog(@"完成");
    }];
    
    //添加textField的text信号 法1
    [self.textField.rac_textSignal subscribeNext:^(NSString *text) {
        NSLog(@"text=%@",text);
    }];
    //法2 RAC(对象，属性)
//    RAC(self.textField,text) = self.textField.rac_textSignal;
    
    //RAC添加通知信号 无需再手动销毁通知了因为rac内部已经做了处理
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"接受到通知了---");
    }];
    self.showView.name = @"开始";
    //添加kvo监听
    //法1 执行到该行就打印 修改值后再打印
    [[self.showView rac_valuesForKeyPath:@"name" observer:nil] subscribeNext:^(id x) {
        NSLog(@"1===%@",x);
    }];
    [RACObserve(self, self.showView.name) subscribeNext:^(id x) {
        NSLog(@"2===%@",x);
    }];

    //类似系统observeValueForKey 值改变后打印 新值、旧值
    [[self.showView rac_valuesAndChangesForKeyPath:@"name" options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld) observer:nil] subscribeNext:^(id x) {
        NSLog(@"3===%@",x);
    }];
    
    
    self.showView.name = @"结束";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - nav
-(void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    RACAPITestViewController *nextVC = [[RACAPITestViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - subViews
-(void)initializePageSubviews{
    self.navigationItem.title = @"RAC";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"API" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.showView];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.sendBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(200,100));
    }];
    //传递过来的参数
    [_showView.subject subscribeNext:^(NSString *x) {
        NSLog(@"%@",x);
    }];
}
-(UIButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sendBtn setTitle:@"点击" forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    }
    return _sendBtn;
}
-(UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}
-(RACShowView *)showView{
    if(!_showView){
        _showView = [[RACShowView alloc] init];
    }
    return _showView;
}
@end
