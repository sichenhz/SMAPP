//
//  SMAccessoryViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMAccessoryDetailViewController.h"
#import "Const.h"
#import "SMAlertView.h"
#import "HMHomeManager+Share.h"
#import "UIViewController+Show.h"
#import "SMTableViewHeaderView.h"

@interface SMAccessoryDetailViewController ()

@end

@implementation SMAccessoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.accessory.name;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];

    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacteristicValue:) name:kDidUpdateCharacteristicValue object:nil];
}

- (void)assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room {
    
    [[HMHomeManager sharedManager].primaryHome assignAccessory:accessory toRoom:room completionHandler:^(NSError * _Nullable error) {
        if (error) {
            [self showError:error];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self userInfo:@{@"accessory" : accessory, @"room" : room}];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)changeLockState:(UIControl *)sender {
    
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchOriginInTableView];
    
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview];
    HMService *service = self.accessory.services[path.section];
    HMCharacteristic *characteristic = service.characteristics[path.row];
    
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState]) {
        
        BOOL changedLockState = ![characteristic.value boolValue];
        
        [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error) {
            if (error) {
                [self showError:error];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];
                });
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                    object:self
                                                                  userInfo:@{@"accessory": service.accessory,
                                                                             @"service": service,
                                                                             @"characteristic": characteristic}];
                
            }
        }];
    }
}

- (void)changeSliderValue:(UIControl *)sender {
    
    UISlider *slider = (UISlider *)sender;
    
    NSLog(@"%f", slider.value);
    
    CGPoint sliderOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:sliderOriginInTableView];
    
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview];
    HMService *service = self.accessory.services[path.section];
    HMCharacteristic *characteristic = service.characteristics[path.row];
    
    [characteristic writeValue:[NSNumber numberWithInteger:slider.value] completionHandler:^(NSError *error) {
        if (error) {
            [self showError:error];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%.0f", slider.value] ;
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                object:self
                                                              userInfo:@{@"accessory": service.accessory,
                                                                         @"service": service,
                                                                         @"characteristic": characteristic}];
        }
    }];
}

- (void)updateCharacteristicValue:(NSNotification *)notification {
    
    if ([notification.object isEqual:self]) {
        return;
    }
    

    for (HMService *service in self.accessory.services) {
        HMCharacteristic *characteristic = [[notification userInfo] objectForKey:@"characteristic"];
        if ([service.characteristics containsObject:characteristic]) {
            
            NSInteger section = [self.accessory.services indexOfObject:[[notification userInfo] objectForKey:@"service"]];
            NSInteger index = [service.characteristics indexOfObject:characteristic];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section]];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];
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
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.accessory.services.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < self.accessory.services.count) {
        HMService *service = self.accessory.services[section];
        return service.characteristics.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kUITableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = FONT_BODY;
        cell.textLabel.textColor = COLOR_TITLE;
    }

    if (indexPath.section < self.accessory.services.count) {
        HMService *service = self.accessory.services[indexPath.section];
        HMCharacteristic *characteristic = service.characteristics[indexPath.row];
        if (characteristic.value != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];
        } else {
            cell.textLabel.text = @"";
        }
        cell.detailTextLabel.text = characteristic.localizedDescription;
        cell.detailTextLabel.textColor = COLOR_TITLE;
        cell.accessoryType = UITableViewCellAccessoryNone;

        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {
            
            BOOL lockState = [characteristic.value boolValue];
            UISwitch *lockSwitch = [[UISwitch alloc] init];
            lockSwitch.on = lockState;
            [lockSwitch addTarget:self action:@selector(changeLockState:) forControlEvents:UIControlEventValueChanged];
            
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
        } else {
            
            cell.accessoryView = nil;
        }
    } else {
        cell.textLabel.text = @"Room";
        cell.detailTextLabel.text = self.accessory.room.name;
        cell.detailTextLabel.textColor = COLOR_ORANGE;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
    }
 
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SMTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSMTableViewHeaderView];
    if (!header) {
        header = [[SMTableViewHeaderView alloc] initWithReuseIdentifier:kSMTableViewHeaderView];
        header.arrowButton.hidden = YES;
    }
    
    if (section < self.accessory.services.count) {
        // title
        HMService *service = self.accessory.services[section];
        [header.titleButton setTitle:service.name forState:UIControlStateNormal];

        // favorite
        header.switchButton.hidden = YES;
        for (HMCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]) {
                header.switchButton.hidden = NO;
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *homeID = [HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString;
                NSMutableDictionary *favoritesMap = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:kFavoriteService]];
                NSArray *favorites = [favoritesMap objectForKey:homeID];

                header.switchButton.selected = NO;
                for (NSString *serviceID in favorites) {
                    if ([serviceID isEqualToString:service.uniqueIdentifier.UUIDString]) {
                        header.switchButton.selected = YES;
                        break;
                    }
                }
                break;
            }
        }

        header.switchButtonPressed = ^(UIButton *sender) {
            sender.selected = !sender.isSelected;
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *homeID = [HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString;
            NSMutableDictionary *favoritesMap = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:kFavoriteService]];
            NSMutableArray *favorites = [NSMutableArray arrayWithArray:[favoritesMap objectForKey:homeID]];

            // 标记喜欢
            if (sender.isSelected) {
                [favorites addObject:service.uniqueIdentifier.UUIDString];
            } else {
                for (NSString *serviceID in favorites) {
                    if ([serviceID isEqualToString:service.uniqueIdentifier.UUIDString]) {
                        [favorites removeObject:serviceID];
                        break;
                    }
                }
            }
            [favoritesMap setObject:favorites forKey:homeID];
            [userDefault setObject:favoritesMap forKey:kFavoriteService];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self userInfo:@{@"accessory" : service.accessory}];
        };

    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == self.accessory.services.count) {
        HMHomeManager *manager = [HMHomeManager sharedManager];
        
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
        
        [alertView addAction:[SMAlertAction actionWithTitle:@"Create New" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
            
            SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
            
            [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Ex. Kitchen, Living Room";
            }];
            
            [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
            
            [alertView addAction:[SMAlertAction actionWithTitle:@"Save" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
                NSString *newName = alertView.textFields.firstObject.text;
                [manager.primaryHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
                    if (error) {
                        [self showError:error];
                    } else {
                        [self assignAccessory:self.accessory toRoom:room];
                    }
                }];
            }]];
            [alertView show];
            
        }]];
        
        for (HMRoom *room in manager.primaryHome.rooms) {
            NSString *roomName = room.name;
            [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
                [self assignAccessory:self.accessory toRoom:room];
            }]];
        }
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < self.accessory.services.count) {
        return 44;
    } else {
        return 0;
    }
}

@end
