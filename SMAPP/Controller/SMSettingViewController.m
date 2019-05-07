//
//  SMSettingViewController.m
//  SMAPP
//
//  Created by Jason on 6/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMSettingViewController.h"
#import "Masonry.h"
#import "SMCollectionViewCell.h"
#import "Const.h"
#import "HMHomeManager+Share.h"

@interface SMSettingViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation SMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"My Devices";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 40) / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.33);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(collectionView.superview);
    }];

    [collectionView registerClass:[SMCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCell];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceVertical = YES; // make collectionView bounce even datasource has only 1 item
    _collectionView = collectionView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kDidUpdateCurrentHomeInfo object:nil];
}

- (void)reloadData:(NSNotification *)notification {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HMHomeManager *manager = [HMHomeManager sharedManager];
    return manager.primaryHome.accessories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
    
    HMHomeManager *manager = [HMHomeManager sharedManager];
    HMAccessory *accessory = manager.primaryHome.accessories[indexPath.row];
    cell.topLabel.text = [NSString stringWithFormat:@"%@ > %@", accessory.room.name, accessory.name];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate



@end
