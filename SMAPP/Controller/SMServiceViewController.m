//
//  SMServiceViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMServiceViewController.h"
#import "Const.h"

@interface SMServiceViewController ()

@end

@implementation SMServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.service.name;
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacteristicValue:) name:kDidUpdateCharacteristicValue object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.characteristics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kUITableViewCell];
    }
    HMCharacteristic *characteristic = self.service.characteristics[indexPath.row];
    if (characteristic.value != nil) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];;
    } else {
        cell.textLabel.text = @"";
    }
    
    cell.detailTextLabel.text = characteristic.localizedDescription;
    
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState] ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
        
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
               [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetPosition])
    {
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

- (void)changeLockState:(id)sender{
    
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchOriginInTableView];
    
    HMCharacteristic *characteristic = [self.service.characteristics objectAtIndex:indexPath.row];
    
    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
        [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
        
        BOOL changedLockState = ![characteristic.value boolValue];
        
        [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error){
            
            if(error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value] ;
                });
            } else {
                NSLog(@"error in writing characterstic: %@", error);
            }
        }];
    }
}

- (void)changeSliderValue:(id)sender {
    
    UISlider *slider = (UISlider*)sender;
    
    NSLog(@"%f", slider.value);
    
    CGPoint sliderOriginInTableView = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:sliderOriginInTableView];
    
    HMCharacteristic *characteristic = [self.service.characteristics objectAtIndex:indexPath.row];
    
    [characteristic writeValue:[NSNumber numberWithFloat:slider.value] completionHandler:^(NSError *error){
        
        if(error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"%.0f", slider.value] ;
            });
        } else {
            NSLog(@"error in writing characterstic: %@", error);
        }
    }];
}

- (void)updateCharacteristicValue:(NSNotification *)notification {
    
    HMCharacteristic *characteristic = [[notification userInfo] objectForKey:@"characteristic"];
    
    if ([self.service.characteristics containsObject:characteristic]) {
        NSInteger index = [self.service.characteristics indexOfObject:characteristic];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];
        });
    }
}

@end
