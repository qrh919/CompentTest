//
//  RACShowView.m
//  CompentTest
//
//  Created by qrh on 2018/1/18.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "RACShowView.h"
#import <Masonry/Masonry.h>

@interface RACShowView()
@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation RACShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self configPageSubviews];
    }
    return self;
}

-(void)configPageSubviews{
    [self addSubview:self.sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    @weakify(self);
    [[_sendBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        //发送数据
        [self.subject sendNext:@"我是参数"];
    }];
}
-(UIButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sendBtn setTitle:@"子视图按钮" forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    }
    return _sendBtn;
}
-(RACSubject *)subject{
    if(!_subject){
        _subject = [RACSubject subject];
    }
    return _subject;
}
@end
