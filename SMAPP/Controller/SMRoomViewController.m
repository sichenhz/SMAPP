//
//  SMRoomViewController.m
//  SMAPP
//
//  Created by Jason on 14/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMRoomViewController.h"
#import "Const.h"
#import "SMRoomTableViewCell.h"
#import "SMTableViewHeaderView.h"
#import "SMAlertView.h"
#import "SMRoomListViewController.h"

@interface SMRoomViewSectionItem : NSObject

@property (nonatomic, assign, getter=isShowed) BOOL showed;
@property (nonatomic, strong) HMService *service;

@end

@implementation SMRoomViewSectionItem

+ (instancetype)itemWithService:(HMService *)service showed:(BOOL)showed {
    SMRoomViewSectionItem *sectionItem = [[SMRoomViewSectionItem alloc] init];
    sectionItem.service = service;
    sectionItem.showed = showed;
    return sectionItem;
}

@end

@interface SMRoomViewController ()

@property (nonatomic, strong) HMRoom *room;
@property (nonatomic, assign) NSInteger currentShowedSection;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SMRoomViewController

- (instancetype)initWithRoom:(HMRoom *)room {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _room = room;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.room.name;
    self.currentShowedSection = -1; // means there is no showed section by default

    [self initNavigationItems];
        
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView = [[UIView alloc] init]; // remove the lines
    
    [self updateCurrentAccessories];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAccessories:) name:kDidRemoveAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAccessories:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacteristicValue:) name:kDidUpdateCharacteristicValue object:nil];
}

- (void)initNavigationItems {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];
    
    UIImage *image = [[UIImage imageNamed:@"tab_cate_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonItemPressed:)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [leftButtonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    
    image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    self.navigationItem.rightBarButtonItems = @[rightbuttonItem, leftButtonItem];
}

- (void)updateCurrentAccessories {
    
    self.dataList = [NSMutableArray array];
    
    for (HMAccessory *accessory in self.room.accessories) {
        for (HMService *service in accessory.services) {
            if (service.isUserInteractive) {
                [self.dataList addObject:[SMRoomViewSectionItem itemWithService:service showed:NO]];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)removeAccessories:(NSNotification *)notification {
    HMAccessory *accessory = notification.userInfo[@"accessory"];
    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    for (SMRoomViewSectionItem *item in self.dataList) {
        NSInteger section = [self.dataList indexOfObject:item];
        if ([item.service.accessory isEqual:accessory]) {
            [sections addIndex:section];
        }
    }
    [self.dataList removeObjectsAtIndexes:sections];
    [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateCurrentAccessories:(NSNotification *)notification {
    [self updateCurrentAccessories];
}

- (void)updateCharacteristicValue:(NSNotification *)notification {
    
    if ([notification.object isEqual:self]) {
        return;
    }
    
    HMCharacteristic *characteristic = [[notification userInfo] objectForKey:@"characteristic"];
    
    for (SMRoomViewSectionItem *item in self.dataList) {
        if (item.isShowed) {
            NSInteger section = [self.dataList indexOfObject:item];
            NSArray *characteristics = item.service.characteristics;
            if ([characteristics containsObject:characteristic]) {
                NSInteger index = [characteristics indexOfObject:characteristic];
                
                SMRoomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    cell.leftLabel.text = [NSString stringWithFormat:@"%@: %@", characteristic.localizedDescription, characteristic.value ? : @"0"];
                    if ([cell.accessoryView isKindOfClass:[UISwitch class]]) {
                        UISwitch *lockSwitch = (UISwitch *)cell.accessoryView;
                        lockSwitch.on = [characteristic.value boolValue];
                    } else if ([cell.accessoryView isKindOfClass:[UISlider class]]) {
                        UISlider *slider = (UISlider *)cell.accessoryView;
                        slider.value = [characteristic.value floatValue];
                    }
                });
            }
        }
    }
}

#pragma mark - Action

- (void)leftButtonItemPressed:(id)sender {
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if (manager.primaryHome.rooms.count > 0) {
        
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
        
        for (HMRoom *room in manager.primaryHome.rooms) {
            NSString *roomName = room.name;
            __weak typeof(self) weakSelf = self;
            BOOL isSelected = [roomName isEqualToString:self.navigationItem.title];
            [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault selected:isSelected handler:^(SMAlertAction * _Nonnull action) {
                weakSelf.room = room;
                weakSelf.navigationItem.title = room.name;
                [weakSelf updateCurrentAccessories];
            }]];
        }
        
        [alertView addAction:[SMAlertAction actionWithTitle:@"Room Settings..." style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
            SMRoomListViewController *roomListVC = [[SMRoomListViewController alloc] initWithHome:manager.primaryHome];
            [self.navigationController pushViewController:roomListVC animated:YES];
        }]];
        
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

- (void)rightButtonItemPressed:(id)sender {
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Kitchen, Living Room";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Save" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        [manager.primaryHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                self.room = room;
                self.navigationItem.title = room.name;
                [self updateCurrentAccessories];
            }
        }];
    }]];
    [alertView show];
}

- (void)changeLockState:(id)sender {
    
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchOriginInTableView];
    
    SMRoomViewSectionItem *item = self.dataList[indexPath.section];
    HMCharacteristic *characteristic = item.service.characteristics[indexPath.item];
    
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
        
        BOOL changedLockState = ![characteristic.value boolValue];
        
        [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error) {
            
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    ((SMRoomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).leftLabel.text = [NSString stringWithFormat:@"%@: %@", characteristic.localizedDescription, characteristic.value ? : @"0"];

                });
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                    object:self
                                                                  userInfo:@{@"accessory": item.service.accessory,
                                                                             @"service": item.service,
                                                                             @"characteristic": characteristic}];
                
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)changeSliderValue:(id)sender {
    
    UISlider *slider = (UISlider*)sender;
    
    NSLog(@"%f", slider.value);
    
    CGPoint sliderOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:sliderOriginInTableView];
    
    SMRoomViewSectionItem *item = self.dataList[indexPath.section];
    HMCharacteristic *characteristic = item.service.characteristics[indexPath.item];

    [characteristic writeValue:[NSNumber numberWithFloat:slider.value] completionHandler:^(NSError *error) {
        
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                ((SMRoomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).leftLabel.text = [NSString stringWithFormat:@"%.0f", slider.value] ;
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                object:self
                                                              userInfo:@{@"accessory": item.service.accessory,
                                                                         @"service": item.service,
                                                                         @"characteristic": characteristic}];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SMRoomViewSectionItem *item = self.dataList[section];
    return item.service.characteristics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMRoomTableViewCell];
    if (!cell) {
        cell = [[SMRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSMRoomTableViewCell];
    }
    
    SMRoomViewSectionItem *item = self.dataList[indexPath.section];
    HMCharacteristic *characteristic = item.service.characteristics[indexPath.row];
    
    cell.leftLabel.text = [NSString stringWithFormat:@"%@: %@", characteristic.localizedDescription, characteristic.value ? : @"0"];
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected] ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {
        
        UISwitch *lockSwitch = [[UISwitch alloc] init];
        lockSwitch.backgroundColor = HEXCOLOR(0xE5E9F2);
        lockSwitch.layer.cornerRadius = 16;
        lockSwitch.enabled = characteristic.service.accessory.isReachable;
        lockSwitch.on = [characteristic.value boolValue];
        [lockSwitch addTarget:self action:@selector(changeLockState:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = lockSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeSaturation] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeBrightness] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeHue] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetTemperature] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetRelativeHumidity] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCoolingThreshold] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeHeatingThreshold] ||
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetPosition]) {
        UISlider *slider = [[UISlider alloc] init];
        slider.bounds = CGRectMake(0, 0, 125, slider.bounds.size.height);
        slider.maximumValue = [characteristic.metadata.maximumValue floatValue];
        slider.minimumValue = [characteristic.metadata.minimumValue floatValue];
        slider.value = [characteristic.value floatValue];
        slider.continuous = true;
        [slider addTarget:self action:@selector(changeSliderValue:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = slider;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRoomViewSectionItem *item = self.dataList[indexPath.section];
    return item.isShowed ? 44 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SMTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSMTableViewHeaderView];
    if (!header) {
        header = [[SMTableViewHeaderView alloc] initWithReuseIdentifier:kSMTableViewHeaderView];
    }
    
    SMRoomViewSectionItem *item = self.dataList[section];

    [header.titleButton setTitle:item.service.name forState:UIControlStateNormal];
    header.arrowButton.selected = item.isShowed;
    
    __weak typeof(self) weakSelf = self;
    
    header.arrowButtonPressed = ^(BOOL isSelected) {
        
        // update the item status
        item.showed = isSelected;
        
        // reload the current section
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (item.isShowed) {
            // reload the showed section
            if (weakSelf.currentShowedSection >= 0) {
                NSInteger currentShowedSection = weakSelf.currentShowedSection;
                SMRoomViewSectionItem *currentItem = weakSelf.dataList[currentShowedSection];
                currentItem.showed = NO;
                
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:currentShowedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            weakSelf.currentShowedSection = section;
        } else {
            
            weakSelf.currentShowedSection = -1;
        }
    };
    return header;
}

@end
