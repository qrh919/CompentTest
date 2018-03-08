//
//  SnapshotViewController.m
//  CompentTest
//
//  Created by qrh on 2018/3/8.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "SnapshotViewController.h"

@interface SnapshotViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *contentView;

@end

@implementation SnapshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG20"]];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_imageView addGestureRecognizer:tapGesture1];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 5.0;
    _scrollView.maximumZoomScale = 0.5;
    [_scrollView setContentSize:self.view.frame.size];
    _contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG20"]];
    _contentView.frame = CGRectMake(0, 200, self.view.frame.size.width, 300);
    [_scrollView addSubview:_contentView];
    [self.view addSubview:self.scrollView];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_scrollView addGestureRecognizer:tapGesture2];
    _scrollView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapAction:(UITapGestureRecognizer *)sender
{
    UIView *imgSnapshot = [_imageView snapshotViewAfterScreenUpdates:YES];
    imgSnapshot.frame = _imageView.frame;
    [self.view addSubview:imgSnapshot];
    
    if([sender.view isKindOfClass:[UIImageView class]]){
        [UIView animateWithDuration:0.5 animations:^{
            imgSnapshot.center = self.view.center;
            imgSnapshot.transform = CGAffineTransformScale(imgSnapshot.transform, 2, 2);
        } completion:^(BOOL finished) {
            [imgSnapshot removeFromSuperview];
            _scrollView.hidden = NO;
        }];
        
    }else{
        imgSnapshot.center = self.view.center;
        imgSnapshot.transform = CGAffineTransformScale(imgSnapshot.transform, 2, 2);
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.hidden = YES;
            imgSnapshot.center = _imageView.center;
            imgSnapshot.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [imgSnapshot removeFromSuperview];
        }];
        
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIView *view in scrollView.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            return view;
        }
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGRect frame = _contentView.frame;
    
    frame.origin.y = (scrollView.frame.size.height - _contentView.frame.size.height) > 0 ? (scrollView.frame.size.height - _contentView.frame.size.height) * 0.5 : 0;
    frame.origin.x = (scrollView.frame.size.width - _contentView.frame.size.width) > 0 ? (scrollView.frame.size.width - _contentView.frame.size.width) * 0.5 : 0;
    _contentView.frame = frame;
    
    scrollView.contentSize = CGSizeMake(_contentView.frame.size.width + 30, _contentView.frame.size.height + 30);
}

@end
