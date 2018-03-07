//
//  CycleCollectionViewCell.m
//  CompentTest
//
//  Created by qrh on 2018/2/27.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "CycleCollectionViewCell.h"

@interface CycleCollectionViewCell()
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation CycleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _nameLab.text = title;
}

-(void)createSubViews{
    [self.contentView addSubview:self.nameLab];
    _nameLab.center = self.contentView.center;
}

-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = [UIColor blackColor];
    }
    return _nameLab;
}

@end
