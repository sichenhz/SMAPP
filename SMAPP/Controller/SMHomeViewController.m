//
//  SMHomeViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMHomeViewController.h"
#import "SMServiceViewController.h"
#import "SMTableViewCell.h"
#import "SMTableViewHeaderView.h"
#import "HMHomeManager+Share.h"
#import "Const.h"
#import "UIView+Extention.h"
#import "SMAlertView.h"
#import "Masonry.h"
#import "SMAddAccessoryViewController.h"

@interface SMHomeViewSectionItem : NSObject

@property (nonatomic, assign, getter=isHidden) BOOL hidden;
@property (nonatomic, strong) NSArray *services;

@end

@implementation SMHomeViewSectionItem

+ (instancetype)itemWithServices:(NSMutableArray *)services {
    SMHomeViewSectionItem *sectionItem = [[SMHomeViewSectionItem alloc] init];
    sectionItem.services = [NSArray arrayWithArray:services];
    return sectionItem;
}

@end

@interface SMHomeViewController () <
HMHomeManagerDelegate,
HMHomeDelegate,
HMAccessoryDelegate
>

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HMHomeManager *namager = [HMHomeManager sharedManager];
    self.title = namager.primaryHome.name;

    namager.delegate = self;

    [self initNavigationItems];
    
//    [self initHeaderViewWithCompletionHandler:^(UIButton * _Nonnull leftButton, UIButton * _Nonnull rightButton) {
//        [leftButton setTitle:@"Remove Home" forState:UIControlStateNormal];
//        [rightButton setTitle:@"Remove Room" forState:UIControlStateNormal];
//
//        [leftButton addTarget:self action:@selector(removeHome:) forControlEvents:UIControlEventTouchUpInside];
//        [rightButton addTarget:self action:@selector(removeRoom:) forControlEvents:UIControlEventTouchUpInside];
//    }];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAccessories:) name:kDidRemoveAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAccessories) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacteristicValue:) name:kDidUpdateCharacteristicValue object:nil];
}

- (void)initNavigationItems {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];
    
    UIImage *image = [[UIImage imageNamed:@"tab_cate_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonItemPressed:)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    self.navigationItem.rightBarButtonItem = rightbuttonItem;
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
    [leftButton setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
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
    [rightButton setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:FONT_H2_BOLD];
    
    self.tableView.tableHeaderView = headerView;
    
    completion(leftButton, rightButton);
}

- (void)updateCurrentHomeInfo {
    HMHomeManager *manager = [HMHomeManager sharedManager];

    self.navigationItem.title = manager.primaryHome.name;
    manager.primaryHome.delegate = self;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCurrentHomeInfo object:self];
}

- (void)updateCurrentAccessories {
    
    HMHomeManager *manager = [HMHomeManager sharedManager];
    self.dataList = [NSMutableArray array];
    NSMutableArray *services = [NSMutableArray array];

    for (HMAccessory *accessory in manager.primaryHome.roomForEntireHome.accessories) {
        for (HMService *service in accessory.services) {
            if (service.isUserInteractive) {
                [services addObject:service];
            }
        }
        accessory.delegate = self;
    }
    if (services.count) [self.dataList addObject:[SMHomeViewSectionItem itemWithServices:services]];
    
    for (HMRoom *room in manager.primaryHome.rooms) {
        services = [NSMutableArray array];
        for (HMAccessory *accessory in room.accessories) {
            for (HMService *service in accessory.services) {
                if (service.isUserInteractive) {
                    [services addObject:service];
                }
            }
            accessory.delegate = self;
        }
        if (services.count) [self.dataList addObject:[SMHomeViewSectionItem itemWithServices:services]];
    }
    
    [self.tableView reloadData];
}

- (void)updateCharacteristicValue:(NSNotification *)notification {
    
    HMService *service = [[notification userInfo] objectForKey:@"service"];
    HMCharacteristic *characteristic = [[notification userInfo] objectForKey:@"characteristic"];

    for (SMHomeViewSectionItem *item in self.dataList) {
        NSArray *services = item.services;
        NSInteger section = [self.dataList indexOfObject:item.services];
        for (HMService *item in services) {
            if ([item isEqual:service]) {
                NSInteger row = [services indexOfObject:item];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UISwitch *lockSwitch = (UISwitch *)cell.accessoryView;
                    lockSwitch.on = [characteristic.value boolValue];
                });
                
                break;
            }
        }
    }
}

- (void)removeAccessories:(NSNotification *)notification {
    HMAccessory *accessory = notification.object;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (SMHomeViewSectionItem *item in self.dataList) {
        NSArray *services = item.services;
        NSInteger section = [self.dataList indexOfObject:services];
        for (HMService *service in services) {
            if ([service.accessory isEqual:accessory]) {
                NSInteger row = [services indexOfObject:service];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [indexPaths insertObject:indexPath atIndex:0];
            }
        }
    }
    for (NSIndexPath *indexPath in indexPaths) {
        [self.dataList[indexPath.section] removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
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
                        NSLog(@"%@", error);
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
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Remove Home" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self removeHome];
    }]];

    [alertView addAction:[SMAlertAction actionWithTitle:@"Remove Room" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self removeRoom];
    }]];

    [alertView addAction:[SMAlertAction actionWithTitle:@"Add Home" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self addHome];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Add Room" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self addRoom];
    }]];

    [alertView addAction:[SMAlertAction actionWithTitle:@"Add Device" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self addDevice];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView show];
}

- (void)removeHome {
    
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if (manager.primaryHome) {
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to remove %@?", manager.primaryHome.name];
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:message style:SMAlertViewStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;
        [alertView addAction:[SMAlertAction actionWithTitle:@"Remove" style:SMAlertActionStyleConfirm
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

- (void)removeRoom {
    
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
    
    for (HMRoom *room in manager.primaryHome.rooms) {
        
        NSString *roomName = room.name;
        __weak typeof(self) weakSelf = self;
        [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
            NSString *message = [NSString stringWithFormat:@"Are you sure you want to remove %@?", roomName];
            SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:message style:SMAlertViewStyleActionSheet];
            
            [alertView addAction:[SMAlertAction actionWithTitle:@"Remove" style:SMAlertActionStyleConfirm
                                                        handler:^(SMAlertAction * _Nonnull action) {
                                                            
                                                            [manager.primaryHome removeRoom:room completionHandler:^(NSError * _Nullable error) {
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
        }]];
    }
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    [alertView show];
}

- (void)addHome {
    
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

- (void)addRoom {
    
    __weak HMHomeManager *manager = [HMHomeManager sharedManager];
    
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Kitchen, Living Room";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Confirm" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        [manager.primaryHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                // TODO
            }
        }];
    }]];
    [alertView show];
}

- (void)addDevice {
    SMAddAccessoryViewController *addVC = [[SMAddAccessoryViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self];
}

- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidRemoveAccessory object:accessory];
}

- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self];
}

#pragma mark - HMAccessoryDelegate

- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {

    for (SMHomeViewSectionItem *item in self.dataList) {
        NSArray *services = item.services;
        NSInteger section = [self.dataList indexOfObject:services];
        
        for (HMService *service in services) {
            if ([service.accessory isEqual:accessory]) {
                NSInteger row = [services indexOfObject:service];
                SMTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                cell.available = accessory.reachable;
                if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
                    
                    UISwitch *lockSwitch = ((UISwitch *)cell.accessoryView);
                    lockSwitch.enabled = cell.isAvailable;
                    
                    for (HMCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected] ||
                            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {
                            lockSwitch.on = [characteristic.value boolValue];
                        }
                        break;
                    }
                }
            }
        }
    }
}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic {

    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                        object:self
                                                      userInfo:@{@"accessory": accessory,
                                                                 @"service": service,
                                                                 @"characteristic": characteristic}];
}

- (void)accessoryDidUpdateName:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self];
}

- (void)accessory:(HMAccessory *)accessory didUpdateNameForService:(HMService *)service {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self];
}

- (void)accessoryDidUpdateServices:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SMHomeViewSectionItem *item = self.dataList[section];
    return item.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMTableViewCell];
    if (!cell) {
        cell = [[SMTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSMTableViewCell];
    }
    
    SMHomeViewSectionItem *item = self.dataList[indexPath.section];
    HMService *service = item.services[indexPath.row];
    
    cell.leftLabel.text = service.name;
    cell.available = service.accessory.reachable;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    for (HMCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {

            UISwitch *lockSwitch = [[UISwitch alloc] init];
            lockSwitch.enabled = service.accessory.isReachable;
            lockSwitch.on = [characteristic.value boolValue];
            [lockSwitch addTarget:self action:@selector(changeLockState:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = lockSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
    }    
    return cell;
}

- (void)changeLockState:(id)sender {
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchOriginInTableView];

    SMHomeViewSectionItem *item = self.dataList[indexPath.section];
    HMService *service = item.services[indexPath.row];

    for (HMCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
            
            BOOL changedLockState = ![characteristic.value boolValue];
            
            [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error) {
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        NSLog(@"Changed Lock State: %@", characteristic.value);
                    });
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                        object:self
                                                                      userInfo:@{@"accessory": service.accessory,
                                                                                 @"service": service,
                                                                                 @"characteristic": characteristic}];
                } else {
                    NSLog(@"%@", error);
                }
            }];
            break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.selectionStyle == UITableViewCellSelectionStyleDefault) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        SMServiceViewController *viewController = [[SMServiceViewController alloc] init];
        viewController.service = self.dataList[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMHomeViewSectionItem *item = self.dataList[indexPath.section];
    return item.isHidden ? 0 : 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SMTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSMTableViewHeaderView];
    if (!header) {
        header = [[SMTableViewHeaderView alloc] initWithReuseIdentifier:kSMTableViewHeaderView];
    }
    
    SMHomeViewSectionItem *item = self.dataList[section];
    header.titleLabel.text = ((HMService *)item.services.firstObject).accessory.room.name;
    header.arrowButton.selected = item.isHidden;
    
    header.arrowButtonPressed = ^(BOOL isSelected) {
        item.hidden = isSelected;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return header;
}

@end
