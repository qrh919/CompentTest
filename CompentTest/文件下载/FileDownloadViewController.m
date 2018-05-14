//
//  FileDownloadViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/9.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "FileDownloadViewController.h"
#import "QFileDLMananger.h"

@interface FileDownloadViewController ()
@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UILabel *rateLab;

@end

@implementation FileDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.rateLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downLoadAction:(UIButton *)sender{
    [QFileDLMananger downloadWithURL:@"http://ohweag500.bkt.clouddn.com/o_1biiqmdth1eg118jqr56138214f4a.mp4" withProgress:^(CGFloat progress) {
        self.progress.progress = progress;
        self.rateLab.text = [NSString stringWithFormat:@"%.f%%",progress*100];
    }];
}

-(UIButton *)startBtn{
    if(!_startBtn){
        _startBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 80, 40)];
        [_startBtn setTitle:@"开始下载" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(downLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

-(UIProgressView *)progress{
    if(!_progress){
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progress.frame = CGRectMake(100, 100, 200, 5);
        _progress.progressTintColor = [UIColor redColor];
        _progress.trackTintColor = [UIColor blueColor];
    }
    return _progress;
}
-(UILabel *)rateLab{
    if(!_rateLab){
        _rateLab = [[UILabel alloc] initWithFrame:CGRectMake(300, 100, 50, 20)];
        _rateLab.font = [UIFont systemFontOfSize:15];
        _rateLab.textColor = [UIColor blueColor];
    }
    return _rateLab;
}
@end
