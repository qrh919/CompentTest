//
//  CycleLabel.m
//  CompentTest
//
//  Created by qrh on 2018/3/6.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "CycleLabel.h"

@interface CycleLabel ()
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@end

@implementation CycleLabel

- (instancetype)initWithFrame:(CGRect)rect array:(NSArray *)array
{
    self = [super initWithFrame:rect];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        _dataArr = array;
        self.text = array[0];
        
        __weak typeof(self) wkself = self;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            wkself.index++;
            __strong typeof(self) stself = wkself;
            [UIView animateWithDuration:0.4 animations:^{
                stself.transform = CGAffineTransformTranslate(stself.transform, 0, -50);
                stself.alpha = 0;
            } completion:^(BOOL finished) {
                stself.text = stself.dataArr[stself.index%stself.dataArr.count];
                stself.transform = CGAffineTransformIdentity;
                stself.alpha = 1;
            }];
            
        }];
        _timer = timer;
        
    }
    return self;
}

-(void)tapAction:(UIGestureRecognizer *)sender{
    if(self.indexClick){
        self.indexClick(_index%_dataArr.count);
    }
}

-(void)dealloc{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

@end
