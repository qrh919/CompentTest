//
//  SignatureViewController.m
//  CompentTest
//
//  Created by qrh on 2018/12/13.
//  Copyright © 2018 qrh. All rights reserved.
//

#import "SignatureViewController.h"
#import "NormalSignatureView.h"
#import "PPSSignatureView.h"

@interface SignatureViewController ()
@property (nonatomic, strong) UIImageView *coverImageV;
@property (nonatomic, strong) NormalSignatureView *normalView;
@property (nonatomic, strong) PPSSignatureView *ppsView;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initializePageSubviews];
}

-(void)saveAction:(UIButton *)sender{
    self.coverImageV.hidden = NO;
    self.coverImageV.image = [self convertViewToImage:self.normalView];
    self.normalView.hidden = YES;
//    self.coverImageV.image = [self.ppsView signatureImage];//[self convertViewToImage:self.ppsView];
//    self.ppsView.hidden = YES;
}

-(void)resetAction:(UIButton *)sender{
    self.coverImageV.hidden = YES;
    self.normalView.hidden = NO;
    [self.normalView clean];
//    self.ppsView.hidden = NO;
//    [self.ppsView erase];
}

#pragma mark - init views
- (void)initializePageSubviews{
    self.navigationItem.title = @"签名";
    
    [self.view addSubview:self.coverImageV];
    [self.view addSubview:self.normalView];
//    [self.view addSubview:self.ppsView];
    UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    saveBtn.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width/2, 100);
    [saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    [saveBtn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [saveBtn setTitleColor:UIColor.grayColor forState:(UIControlStateHighlighted)];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:saveBtn];
    
    UIButton *resetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    resetBtn.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height-100, self.view.bounds.size.width/2, 100);
    [resetBtn setTitle:@"重置" forState:(UIControlStateNormal)];
    [resetBtn setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [resetBtn setTitleColor:UIColor.grayColor forState:(UIControlStateHighlighted)];
    [resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:resetBtn];
    
    _coverImageV.hidden = YES;
    
}

-(UIImageView *)coverImageV{
    if(!_coverImageV){
        _coverImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
        _coverImageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageV;
}

-(NormalSignatureView *)normalView{
    if(!_normalView){
        _normalView = [[NormalSignatureView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    }
    return _normalView;
}

-(PPSSignatureView *)ppsView{
    if(!_ppsView){
        _ppsView = [[PPSSignatureView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100) context:[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1]];
    }
    return _ppsView;
}

- (UIImage *)convertViewToImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
