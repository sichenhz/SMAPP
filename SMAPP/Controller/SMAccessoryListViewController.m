//
//  SMAccessoryListViewController.m
//  SMAPP
//
//  Created by Sichen on 14/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMAccessoryListViewController.h"
#import "Masonry.h"
#import "SMCollectionViewCell.h"
#import "Const.h"
#import "HMHomeManager+Share.h"
#import "SMAccessoryDetailViewController.h"
#import "SMAlertView.h"
#import "UIViewController+Show.h"

@interface SMAccessoryListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SMAccessoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"My Favourites";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (WIDTH_NAV_L - 30) / 2;
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
    
    [collectionView registerClass:[SMCollectionViewCell class] forCellWithReuseIdentifier:kSMCollectionViewCell];
    collectionView.backgroundColor = COLOR_BACKGROUND;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceVertical = YES; // make collectionView bounce even datasource has only 1 item
    _collectionView = collectionView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAccessories:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAccessories:) name:kDidUpdatePrimaryHome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAccessories:) name:kDidUpdateCharacteristicValue object:nil];
    
    [self updateCurrentAccessories];
}

- (void)updateCurrentAccessories:(NSNotification *)notification {
    [self updateCurrentAccessories];
}

- (void)updateCurrentAccessories {
    HMHomeManager *manager = [HMHomeManager sharedManager];
    self.dataList = [NSMutableArray array];
    
    for (HMAccessory *accessory in manager.primaryHome.accessories) {
        for (HMService *service in accessory.services) {
            if (service.isUserInteractive) {
                [self.dataList addObject:service];
            }
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - Action

- (void)changeLockState:(id)sender {
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:switchOriginInTableView];
    
    HMService *service = self.dataList[indexPath.row];
    
    for (HMCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
            
            BOOL changedLockState = ![characteristic.value boolValue];
            
            [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error) {
                if (error) {
                    [self showError:error];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        NSLog(@"Changed Lock State: %@", characteristic.value);
                    });
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                        object:self
                                                                      userInfo:@{@"accessory": service.accessory,
                                                                                 @"service": service,
                                                                                 @"characteristic": characteristic}];
                }
            }];
            break;
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSMCollectionViewCell forIndexPath:indexPath];
    
    HMService *service = self.dataList[indexPath.row];
    HMAccessory *accessory = service.accessory;
    
    cell.iconButton.selected = NO;
    for (HMCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {
            cell.iconButton.selected = [characteristic.value boolValue];
            break;
        }
    }
    
    cell.topLabel.text = [NSString stringWithFormat:@"%@ > %@", accessory.room.name, service.name];
    cell.serviceType = service.serviceType;
    
    __weak typeof(self) weakSelf = self;
    
    cell.iconButtonPressed = ^(UIButton *sender) {
        if (cell.cellType == SMCollectionViewCellTypeBulb ||
            cell.cellType == SMCollectionViewCellTypeSwitch) {
            [weakSelf changeLockState:sender];
        } else {
            SMAccessoryDetailViewController *viewController = [[SMAccessoryDetailViewController alloc] init];
            viewController.accessory = service.accessory;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }
    };
    
    cell.editButtonPressed = ^{
        SMAccessoryDetailViewController *vc = [[SMAccessoryDetailViewController alloc] init];
        vc.accessory = accessory;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.removeButtonPressed = ^{
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to remove %@ from your home?", accessory.name];
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:message style:SMAlertViewStyleActionSheet];
        
        [alertView addAction:[SMAlertAction actionWithTitle:@"Remove" style:SMAlertActionStyleConfirm
                                                    handler:^(SMAlertAction * _Nonnull action) {
                                                        HMHomeManager *namager = [HMHomeManager sharedManager];
                                                        [namager.primaryHome removeAccessory:accessory completionHandler:^(NSError * _Nullable error) {
                                                            if (error) {
                                                                [self showError:error];
                                                            } else {
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self userInfo:@{@"accessory" : accessory, @"remove" : @"1"}];
                                                            }
                                                        }];
                                                    }]];
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel
                                                    handler:nil]];
        [alertView show];
        
    };
    
    
    return cell;
}

@end
