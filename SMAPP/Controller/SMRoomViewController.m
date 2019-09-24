//
//  SMRoomViewController.m
//  SMAPP
//
//  Created by Sichen on 14/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMRoomViewController.h"
#import "Const.h"
#import "SMRoomTableViewCell.h"
#import "SMTableViewHeaderView.h"
#import "SMAlertView.h"
#import "UIViewController+Show.h"
#import "UIView+Extention.h"
#import "SMButton.h"

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
@property (nonatomic, weak) UIButton *titleButton;

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
    
    [self initNavigationItems];
        
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView = [[UIView alloc] init]; // remove the lines
    
    [self updateCurrentAccessories];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentAccessories:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacteristicValue:) name:kDidUpdateCharacteristicValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoomName:) name:kDidUpdateRoomName object:nil];
}

- (void)initNavigationItems {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];

    UIButton *titleButton = [SMButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    titleButton.titleLabel.font = FONT_H2_BOLD;
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setImage:[[UIImage imageNamed:@"arrow-drop-down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
    titleButton.height = self.navigationController.navigationBar.height;
    [titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _titleButton = titleButton;
    
    [self updateTitleButtonWithTitle:self.room.name];
}

- (void)updateTitleButtonWithTitle:(NSString *)title {
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    [self.titleButton sizeToFit];
    self.titleButton.width += 15;
}

- (void)updateRoomName:(NSNotification *)notification {
    HMRoom *room = notification.userInfo[@"room"];
    
    if ([room isEqual:self.room]) {
        [self updateTitleButtonWithTitle:room.name];
    }
}

- (void)updateCurrentAccessories {
    
    self.currentShowedSection = -1; // means there is no showed section by default

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *showedServiceMap = [userDefault objectForKey:kShowedService];
    NSString *homeName = [HMHomeManager sharedManager].primaryHome.name;
    NSString *roomName = self.room.name;
    
    self.dataList = [NSMutableArray array];
    
    for (HMAccessory *accessory in self.room.accessories) {
        for (HMService *service in accessory.services) {
            if (service.isUserInteractive) {
                BOOL showed = [service.name isEqualToString:showedServiceMap[homeName][roomName]];
                [self.dataList addObject:[SMRoomViewSectionItem itemWithService:service showed:showed]];
                if (showed) {
                    self.currentShowedSection = self.dataList.count - 1;
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Notification

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
                        slider.value = [characteristic.value integerValue];
                    }
                });
            }
        }
    }
}

#pragma mark - Action

- (void)titleButtonPressed:(id)sender {
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if (manager.primaryHome.rooms.count > 0) {
        
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleAlert];
        
        HMRoom *roomForEntireHome = manager.primaryHome.roomForEntireHome;
        NSString *roomName = roomForEntireHome.name;
        __weak typeof(self) weakSelf = self;
        BOOL isSelected = [roomName isEqualToString:self.titleButton.titleLabel.text];
        [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault selected:isSelected handler:^(SMAlertAction * _Nonnull action) {
            weakSelf.room = roomForEntireHome;
            [weakSelf updateTitleButtonWithTitle:roomForEntireHome.name];
            [weakSelf updateCurrentAccessories];
        }]];
        
        for (HMRoom *room in manager.primaryHome.rooms) {
            NSString *roomName = room.name;
            __weak typeof(self) weakSelf = self;
            BOOL isSelected = [roomName isEqualToString:self.titleButton.titleLabel.text];
            [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault selected:isSelected handler:^(SMAlertAction * _Nonnull action) {
                weakSelf.room = room;
                [weakSelf updateTitleButtonWithTitle:room.name];
                [weakSelf updateCurrentAccessories];
            }]];
        }
                
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
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
            if (error) {
                [self showError:error];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    ((SMRoomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).leftLabel.text = [NSString stringWithFormat:@"%@: %@", characteristic.localizedDescription, characteristic.value ? : @"0"];
                    
                });
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                    object:self
                                                                  userInfo:@{@"accessory": item.service.accessory,
                                                                             @"service": item.service,
                                                                             @"characteristic": characteristic}];
                
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

    [characteristic writeValue:[NSNumber numberWithInteger:slider.value] completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error");
            [self showError:error];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                ((SMRoomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).leftLabel.text = [NSString stringWithFormat:@"%.0f", slider.value] ;
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                object:self
                                                              userInfo:@{@"accessory": item.service.accessory,
                                                                         @"service": item.service,
                                                                         @"characteristic": characteristic}];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SMRoomViewSectionItem *item = self.dataList[indexPath.section];
    HMCharacteristic *characteristic = item.service.characteristics[indexPath.row];
    
    cell.leftLabel.text = [NSString stringWithFormat:@"%@: %@", characteristic.localizedDescription, characteristic.value ? : @"0"];
    cell.accessoryView = nil;
    
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
        slider.value = [characteristic.value integerValue];
        slider.continuous = YES;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SMTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSMTableViewHeaderView];
    if (!header) {
        header = [[SMTableViewHeaderView alloc] initWithReuseIdentifier:kSMTableViewHeaderView];
        header.titleButton.userInteractionEnabled = NO;
    }

    SMRoomViewSectionItem *item = self.dataList[section];

    [header.titleButton setTitle:item.service.name forState:UIControlStateNormal];
    header.arrowButton.selected = item.isShowed;
    
    __weak typeof(self) weakSelf = self;
    
    header.arrowButtonPressed = ^(UIButton *sender) {
        
        if (item.service.characteristics.count) {
            sender.selected = !sender.isSelected;
            
            // update the item status
            item.showed = sender.isSelected;
            
            // reload the current section
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *homeName = [HMHomeManager sharedManager].primaryHome.name;
            NSString *roomName = weakSelf.room.name;
            
            if (item.isShowed) {
                // reload the showed section
                if (weakSelf.currentShowedSection >= 0) {
                    NSInteger currentShowedSection = weakSelf.currentShowedSection;
                    SMRoomViewSectionItem *currentItem = weakSelf.dataList[currentShowedSection];
                    currentItem.showed = NO;
                    
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:currentShowedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                NSMutableDictionary *homesMap = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:kShowedService]];
                NSMutableDictionary *roomsMap = [NSMutableDictionary dictionaryWithDictionary:[homesMap objectForKey:homeName]];
                [roomsMap setObject:item.service.name forKey:roomName];
                [homesMap setObject:roomsMap forKey:homeName];
                [userDefault setObject:homesMap forKey:kShowedService];
                
                weakSelf.currentShowedSection = section;
            } else {
                
                NSMutableDictionary *homesMap = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:kShowedService]];
                NSMutableDictionary *roomsMap = [NSMutableDictionary dictionaryWithDictionary:[homesMap objectForKey:homeName]];
                [roomsMap removeObjectForKey:roomName];
                [homesMap setObject:roomsMap forKey:homeName];
                [userDefault setObject:homesMap forKey:kShowedService];
                
                weakSelf.currentShowedSection = -1;
            }
        } else {
            [weakSelf showText:@"No characteristics in this service."];
        }
    };
    return header;
}

@end
