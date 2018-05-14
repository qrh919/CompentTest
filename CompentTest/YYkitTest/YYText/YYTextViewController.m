//
//  YYTextViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/12.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "YYTextViewController.h"
#import "YYKit.h"
#import "Masonry.h"

@interface YYTextViewController ()
@property (nonatomic, strong) YYLabel *label;
@end

@implementation YYTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *msg = @"测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容";
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:msg attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    
    __weak typeof(self) wkSelf = self;
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wkSelf.view).offset(10);
        make.right.equalTo(wkSelf.view).offset(-10);
        make.top.equalTo(wkSelf.view).offset(100);
        make.height.equalTo(@(36));
    }];
    _label.attributedText = attStr;
    [self addSeeMoreButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSeeMoreButton {
    __weak typeof(self) wSelf = self;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...更多"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {

        YYLabel *label = wSelf.label;
        [label sizeToFit];
        
//        wSelf.label.numberOfLines = 0;
//        [wSelf.label mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(wSelf.courseModel.descHeiht);
//        }];
//        if(wSelf.seeMoreBlock){
//            wSelf.seeMoreBlock(YES);
//        }
//        UIButton *btn = [UIButton buttonConfigure:^(UIButton *btn) {
//            [btn setTitle:@"收起" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont systemFontOfSize:15];
//        } action:^(UIButton *btn) {
//            SS(sSelf);
//            sSelf.label.numberOfLines = 2;
//            [sSelf.label mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(@40);
//            }];
//            if(sSelf.seeMoreBlock){
//                sSelf.seeMoreBlock(NO);
//            }
//            [btn removeFromSuperview];
//        }];
//        [wSelf addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(wSelf).offset(-15);
//            make.bottom.equalTo(wSelf.descLab);
//        }];
    };
    
    [text setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"更多"]];
    [text setTextHighlight:hi range:[text.string rangeOfString:@"更多"]];
    text.font = _label.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentTop];
    _label.truncationToken = truncationToken;
}

- (YYLabel *)label{
    if(!_label){
        _label = [YYLabel new];
        _label.userInteractionEnabled = YES;
        _label.numberOfLines = 2;
        _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}

@end
