//
//  SMHomeViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMHomeViewController.h"
#import "SMTableViewCell.h"
#import "SMTableViewHeaderView.h"
#import "HMHomeManager+Share.h"
#import "Const.h"
#import "UIView+Extention.h"
#import "SMAlertView.h"
#import "SMAccessoryDetailViewController.h"
#import "Masonry.h"

@interface SMHomeViewController () <
HMHomeManagerDelegate,
HMHomeDelegate,
HMAccessoryDelegate
>

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation SMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HMHomeManager *namager = [HMHomeManager sharedManager];
    self.title = namager.primaryHome.name;

    namager.delegate = self;

    [self initNavigationItemWithLeftTitle:@"Homes"];
    
    [self initHeaderViewWithCompletionHandler:^(UIButton * _Nonnull leftButton, UIButton * _Nonnull rightButton) {
        [leftButton setTitle:@"Remove Home" forState:UIControlStateNormal];
        [rightButton setTitle:@"Add Home" forState:UIControlStateNormal];
        
        [leftButton addTarget:self action:@selector(removeHome:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addTarget:self action:@selector(addHome:) forControlEvents:UIControlEventTouchUpInside];
    }];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateAccessory:) name:kDidUpdateAccessory object:nil];
}

- (void)didUpdateAccessory:(NSNotification *)notification {
    [self updateCurrentAccessories];
}

- (void)initNavigationItemWithLeftTitle:(NSString *)title {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonItemPressed:)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateNormal)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateHighlighted)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
//    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Accessory" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
//    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateNormal)];
//    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : HEXCOLOR(0xFFA500)} forState:(UIControlStateHighlighted)];
//    self.navigationItem.rightBarButtonItem = rightbuttonItem;
}

- (void)initHeaderViewWithCompletionHandler:(void (^)(UIButton *leftButton, UIButton *rightButton))completion {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 54)];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [headerView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftButton.superview).offset(15);
        make.top.equalTo(leftButton.superview).offset(5);
        make.width.equalTo(@120);
        make.height.equalTo(@44);
    }];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:HEXCOLOR(0xFFA500) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [leftButton.titleLabel setFont:FONT_H2_BOLD];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [headerView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftButton.superview).offset(-15);
        make.top.equalTo(leftButton.superview).offset(5);
        make.width.equalTo(@120);
        make.height.equalTo(@44);
    }];

    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitleColor:HEXCOLOR(0xFFA500) forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:FONT_H2_BOLD];
    
    self.tableView.tableHeaderView = headerView;
    
    completion(leftButton, rightButton);
}

- (void)updateCurrentHomeInfo {
    
    HMHomeManager *manager = [HMHomeManager sharedManager];

    self.title = manager.primaryHome.name;
    manager.primaryHome.delegate = self;
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObject:manager.primaryHome.roomForEntireHome];
    [arrM addObjectsFromArray:manager.primaryHome.rooms];
    self.dataList = [NSArray arrayWithArray:arrM];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCurrentHomeInfo object:nil];
}

- (void)updateCurrentAccessories {
    for (HMAccessory *accessory in [HMHomeManager sharedManager].primaryHome.accessories) {
        accessory.delegate = self;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)leftButtonItemPressed:(id)sender {
    
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if (manager.homes.count > 0) {
        
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
        
        for (HMHome *home in manager.homes) {
            NSString *homeName = home.name;
            __weak typeof(self) weakSelf = self;
            [alertView addAction:[SMAlertAction actionWithTitle:homeName style:SMAlertActionStyleDefault selected:home.isPrimary handler:^(SMAlertAction * _Nonnull action) {
                [manager updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error updating primary home: %@", error);
                    } else {
                        NSLog(@"Primary home updated.");
                        [weakSelf updateCurrentHomeInfo];
                        [weakSelf updateCurrentAccessories];
                    }
                }];
            }]];
        }
        
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

//- (void)rightButtonItemPressed:(id)sender {
//    SMAddAccessoryViewController *vc = [[SMAddAccessoryViewController alloc] init];
//    vc.didAddAccessory = self.didAddAccessory;
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
//}

- (void)removeHome:(id)sender {
    
    HMHomeManager *manager = [HMHomeManager sharedManager];

    if (manager.primaryHome) {
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:@"Are you sure you want to delete this Home?" style:SMAlertViewStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;
        [alertView addAction:[SMAlertAction actionWithTitle:@"Confirm" style:SMAlertActionStyleConfirm
                                                    handler:^(SMAlertAction * _Nonnull action) {
                                                        [manager removeHome:manager.primaryHome completionHandler:^(NSError * _Nullable error) {
                                                            if (error) {
                                                                NSLog(@"%@", error);
                                                            } else {
                                                                if (manager.homes.count) {
                                                                    [manager updatePrimaryHome:manager.homes.firstObject completionHandler:^(NSError * _Nullable error) {
                                                                        [weakSelf updateCurrentHomeInfo];
                                                                        [weakSelf updateCurrentAccessories];
                                                                    }];
                                                                }
                                                            }
                                                        }];
                                                    }]];
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel
                                                    handler:nil]];
        [alertView show];
    }
}

- (void)addHome:(id)sender {
    
    __weak HMHomeManager *manager = [HMHomeManager sharedManager];

    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Home..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Vacation Home";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    __weak typeof(self) weakSelf = self;
    [alertView addAction:[SMAlertAction actionWithTitle:@"Confirm" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        [manager addHomeWithName:newName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [manager updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
                    [weakSelf updateCurrentHomeInfo];
                    [weakSelf updateCurrentAccessories];
                }];
            }
        }];
    }]];
    [alertView show];
}

#pragma mark - HMHomeManagerDelegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    if (manager.primaryHome) {
        [self updateCurrentHomeInfo];
        [self updateCurrentAccessories];
    } else {
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"No home" message:nil style:SMAlertViewStyleActionSheet];
        [alertView addAction:[SMAlertAction actionWithTitle:@"OK" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home {
    __weak typeof(self)weakSelf = self;
    [[HMHomeManager sharedManager] updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
        [weakSelf updateCurrentHomeInfo];
        [weakSelf updateCurrentAccessories];
    }];
    NSLog(@"didAddHome");
}


- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home {
    NSLog(@"didRemoveHome");
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    if (manager.primaryHome) {
        [self updateCurrentHomeInfo];
        [self updateCurrentAccessories];
    } else {
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"No home" message:nil style:SMAlertViewStyleActionSheet];
        [alertView addAction:[SMAlertAction actionWithTitle:@"OK" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

#pragma mark - HMHomeDelegate

- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:nil];
}

- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:nil];
}

- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory {
    
}

#pragma mark - HMAccessoryDelegate

- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {
    for (HMRoom *room in self.dataList) {
        NSInteger section = [self.dataList indexOfObject:room];
        if ([room.accessories containsObject:accessory]) {
            NSUInteger row = [room.accessories indexOfObject:accessory];
            
            SMTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            cell.available = accessory.reachable;
        }
    }
}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                        object:nil
                                                      userInfo:@{@"accessory": accessory,
                                                                 @"service": service,
                                                                 @"characteristic": characteristic}];
}

- (void)accessoryDidUpdateServices:(HMAccessory *)accessory {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HMRoom *room = self.dataList[section];
    return room.accessories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell];
    if (!cell) {
        cell = [[SMTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCell];
    }
    
    HMRoom *room = self.dataList[indexPath.section];
    HMAccessory *accessory = room.accessories[indexPath.row];
    
    cell.leftLabel.text = accessory.name;
    cell.available = accessory.reachable;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMAccessoryDetailViewController *vc = [[SMAccessoryDetailViewController alloc] init];
    HMRoom *room = self.dataList[indexPath.section];
    vc.accessory = room.accessories[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SMTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewHeaderView];
    if (!header) {
        header = [[SMTableViewHeaderView alloc] initWithReuseIdentifier:kTableViewHeaderView];
    }
    
    HMRoom *room = self.dataList[section];
    header.titleLabel.text = room.name;
    return header;
}

@end
