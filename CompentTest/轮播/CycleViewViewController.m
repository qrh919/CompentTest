//
//  CycleViewViewController.m
//  CompentTest
//
//  Created by qrh on 2018/2/27.
//  Copyright © 2018年 qrh. All rights reserved.
//

#import "CycleViewViewController.h"
#import "CycleCollectionViewCell.h"
#import "CycleLabel.h"

static NSString *const cellID = @"cycelCellId";

@interface CycleViewViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CycleLabel *cycLabel;
@end

@implementation CycleViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    //添加滚动label
    NSArray *dataArr = @[@"这是个滚动的label-1",@"这是个滚动的label-2",@"这是个滚动的label-3"];
    _cycLabel = [[CycleLabel alloc] initWithFrame:CGRectMake(0, 350, 200, 40) array:dataArr];
    _cycLabel.indexClick = ^(NSInteger index) {
        NSLog(@"%@",dataArr[index]);
    };
    [self.view addSubview:self.cycLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5*10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"%ld 个",indexPath.row%5];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int targetIndex = [self currentIndex] + 1;
    if (targetIndex >= 5*10 || targetIndex == 1) {
        targetIndex = 5*10 * 0.5;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
//    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    int targetIndex = 5*10 * 0.5;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (int)currentIndex
{
    int index = 0;
    index = (_collectionView.contentOffset.x + self.view.bounds.size.width * 0.5) / self.view.bounds.size.width;
    return MAX(0, index);
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 200);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[CycleCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

@end
