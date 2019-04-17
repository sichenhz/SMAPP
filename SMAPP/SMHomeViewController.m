//
//  SMHomeViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMHomeViewController.h"

@interface SMHomeViewController () <
HMHomeManagerDelegate,
HMHomeDelegate,
HMAccessoryDelegate
>

@property (nonatomic, strong) HMHomeManager *homeManager;

@end

@implementation SMHomeViewController

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager {
    if (self = [super init]) {
        _homeManager = homeManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Home";
    
    self.homeManager.delegate = self;

    [self initNavigationItemWithLeftTitle:@"Homes"];
    
    [self initHeaderViewWithCompletionHandler:^(UIButton * _Nonnull leftButton, UIButton * _Nonnull rightButton) {
        [leftButton setTitle:@"Remove Home" forState:UIControlStateNormal];
        [rightButton setTitle:@"Add Home" forState:UIControlStateNormal];
        
        [leftButton addTarget:self action:@selector(removeHome:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addTarget:self action:@selector(addHome:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    __weak typeof(self) weakSelf = self;
    self.didAddAccessory = ^(){
        [weakSelf updateCurrentAccessories];
    };
}

- (void)updateCurrentHomeInfo {
    
    self.textLabel.text = [NSString stringWithFormat:@"current home：%@", self.homeManager.primaryHome.name];

    self.homeManager.primaryHome.delegate = self;
    
    [self.roomVC updatePrivaryHome];
}

- (void)updateCurrentAccessories {
    for (HMAccessory *accessory in self.homeManager.primaryHome.accessories) {
        accessory.delegate = self;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)leftButtonItemPressed:(id)sender {
    if (self.homeManager.homes.count > 0) {
        
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
        
        for (HMHome *home in self.homeManager.homes) {
            NSString *homeName = home.name;
            __weak typeof(self) weakSelf = self;
            [alertView addAction:[SMAlertAction actionWithTitle:homeName style:SMAlertActionStyleDefault selected:home.isPrimary handler:^(SMAlertAction * _Nonnull action) {
                [weakSelf.homeManager updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
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

- (void)rightButtonItemPressed:(id)sender {
    SMAddAccessoryViewController *vc = [[SMAddAccessoryViewController alloc] initWithHomeManager:self.homeManager];
    vc.didAddAccessory = self.didAddAccessory;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)removeHome:(id)sender {
    if (self.homeManager.primaryHome) {
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:@"Are you sure you want to delete this Home?" style:SMAlertViewStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;
        [alertView addAction:[SMAlertAction actionWithTitle:@"Confirm" style:SMAlertActionStyleConfirm
                                                    handler:^(SMAlertAction * _Nonnull action) {
                                                        [self.homeManager removeHome:self.homeManager.primaryHome completionHandler:^(NSError * _Nullable error) {
                                                            if (error) {
                                                                NSLog(@"%@", error);
                                                            } else {
                                                                if (weakSelf.homeManager.homes.count) {
                                                                    [weakSelf.homeManager updatePrimaryHome:weakSelf.homeManager.homes.firstObject completionHandler:^(NSError * _Nullable error) {
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
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Home..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Vacation Home";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    __weak typeof(self) weakSelf = self;
    [alertView addAction:[SMAlertAction actionWithTitle:@"Confirm" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        [weakSelf.homeManager addHomeWithName:newName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [weakSelf.homeManager updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
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
    [self.homeManager updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
        [weakSelf updateCurrentHomeInfo];
        [weakSelf updateCurrentAccessories];
    }];
    NSLog(@"didAddHome");
}


- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home {
    if (self.homeManager.homes.count) {
        __weak typeof(self)weakSelf = self;
        [self.homeManager updatePrimaryHome:self.homeManager.homes.firstObject completionHandler:^(NSError * _Nullable error) {
            [weakSelf updateCurrentHomeInfo];
            [weakSelf updateCurrentAccessories];
        }];
    }
    NSLog(@"didRemoveHome");
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    [self updateCurrentHomeInfo];
}

#pragma mark - HMHomeDelegate

- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory {
    accessory.delegate = self;
    [self.tableView reloadData];
}

- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory {
    [self.tableView reloadData];
}

- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeManager.primaryHome.accessories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.font = FONT_BODY;
        cell.textLabel.font = FONT_BODY;
    }
    HMAccessory *accessory = self.homeManager.primaryHome.accessories[indexPath.row];
    cell.textLabel.text = accessory.name;
    if (accessory.reachable) {
        cell.detailTextLabel.text = @"Available";
        cell.detailTextLabel.textColor = HEXCOLOR(0x2E6C49);
    } else {
        cell.detailTextLabel.text = @"Not Available";
        cell.detailTextLabel.textColor = HEXCOLOR(0xFF0000);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMAccessoryDetailViewController *vc = [[SMAccessoryDetailViewController alloc] init];
    vc.accessory = self.homeManager.primaryHome.accessories[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HMAccessoryDelegate

- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {
    if ([self.homeManager.primaryHome.accessories containsObject:accessory]) {
        NSUInteger index = [self.homeManager.primaryHome.accessories indexOfObject:accessory];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        if (accessory.reachable) {
            cell.detailTextLabel.text = @"Available";
            cell.detailTextLabel.textColor = HEXCOLOR(0x2E6C49);
        } else {
            cell.detailTextLabel.text = @"Not Available";
            cell.detailTextLabel.textColor = HEXCOLOR(0xFF0000);
        }
    }
}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"characteristicValueChanged"
                                                        object:nil
                                                      userInfo:@{@"accessory": accessory,
                                                                 @"service": service,
                                                                 @"characteristic": characteristic}];
}

- (void)accessoryDidUpdateServices:(HMAccessory *)accessory {
    
}

@end
