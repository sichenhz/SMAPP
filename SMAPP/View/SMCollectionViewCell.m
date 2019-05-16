//
//  SMCollectionViewCell.m
//  SMAPP
//
//  Created by Jason on 7/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMCollectionViewCell.h"
#import "Const.h"
#import "Masonry.h"
#import <HomeKit/HomeKit.h>

@implementation SMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = HEXCOLOR(0xF0F8FF);
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UILabel *topLabel = [[UILabel alloc] init];
    [self.contentView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(topLabel.superview).offset(10);
        make.right.equalTo(topLabel.superview).offset(-10);
    }];
    topLabel.font = FONT_BODY;
    topLabel.textColor = COLOR_TITLE;
    topLabel.numberOfLines = 2;
    _topLabel = topLabel;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(editButton.superview);
        make.width.height.equalTo(@35);
    }];
    [editButton setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:removeButton];
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(removeButton.superview);
        make.width.height.equalTo(@35);
    }];
    [removeButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(iconButton.superview);
        make.height.equalTo(iconButton.superview).dividedBy(3);
    }];
    iconButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [iconButton addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _iconButton = iconButton;
}

- (void)setServiceType:(NSString *)serviceType {
    _serviceType = serviceType;
    
    if ([serviceType isEqualToString:HMServiceTypeLightbulb]) {
        self.cellType = SMCollectionViewCellTypeBulb;
        if (self.iconButton.isSelected) {
            [self.iconButton setImage:[UIImage imageNamed:@"bulb_on"] forState:UIControlStateSelected];
        } else {
            [self.iconButton setImage:[UIImage imageNamed:@"bulb_off"] forState:UIControlStateNormal];
        }
    } else if ([serviceType isEqualToString:HMServiceTypeSwitch] ||
               [serviceType isEqualToString:HMServiceTypeThermostat] ||
               [serviceType isEqualToString:HMServiceTypeGarageDoorOpener] ||
               [serviceType isEqualToString:HMServiceTypeAccessoryInformation] ||
               [serviceType isEqualToString:HMServiceTypeFan] ||
               [serviceType isEqualToString:HMServiceTypeOutlet] ||
               [serviceType isEqualToString:HMServiceTypeLockMechanism] ||
               [serviceType isEqualToString:HMServiceTypeLockManagement] ||
               [serviceType isEqualToString:HMServiceTypeBattery] ||
               [serviceType isEqualToString:HMServiceTypeDoor] ||
               [serviceType isEqualToString:HMServiceTypeDoor] ||
               [serviceType isEqualToString:HMServiceTypeDoorbell] ||
               [serviceType isEqualToString:HMServiceTypeSecuritySystem] ||
               [serviceType isEqualToString:HMServiceTypeStatefulProgrammableSwitch] ||
               [serviceType isEqualToString:HMServiceTypeStatelessProgrammableSwitch] ||
               [serviceType isEqualToString:HMServiceTypeWindow] ||
               [serviceType isEqualToString:HMServiceTypeWindowCovering] ||
               [serviceType isEqualToString:HMServiceTypeCameraRTPStreamManagement] ||
               [serviceType isEqualToString:HMServiceTypeCameraControl] ||
               [serviceType isEqualToString:HMServiceTypeMicrophone] ||
               [serviceType isEqualToString:HMServiceTypeSpeaker] ||
               [serviceType isEqualToString:HMServiceTypeAirPurifier] ||
               [serviceType isEqualToString:HMServiceTypeVentilationFan] ||
               [serviceType isEqualToString:HMServiceTypeFilterMaintenance] ||
               [serviceType isEqualToString:HMServiceTypeHeaterCooler] ||
               [serviceType isEqualToString:HMServiceTypeHumidifierDehumidifier] ||
               [serviceType isEqualToString:HMServiceTypeSlats] ||
               [serviceType isEqualToString:HMServiceTypeSlats] ||
               [serviceType isEqualToString:HMServiceTypeLabel] ||
               [serviceType isEqualToString:HMServiceTypeIrrigationSystem] ||
               [serviceType isEqualToString:HMServiceTypeValve] ||
               [serviceType isEqualToString:HMServiceTypeFaucet]) {
        self.cellType = SMCollectionViewCellTypeSwitch;
        if (self.iconButton.isSelected) {
            [self.iconButton setImage:[UIImage imageNamed:@"placeholder_on"] forState:UIControlStateSelected];
        } else {
            [self.iconButton setImage:[UIImage imageNamed:@"placeholder_off"] forState:UIControlStateNormal];
        }
    } else if ([serviceType isEqualToString:HMServiceTypeCarbonDioxideSensor] ||
               [serviceType isEqualToString:HMServiceTypeCarbonMonoxideSensor] ||
               [serviceType isEqualToString:HMServiceTypeAirQualitySensor] ||
               [serviceType isEqualToString:HMServiceTypeContactSensor] ||
               [serviceType isEqualToString:HMServiceTypeHumiditySensor] ||
               [serviceType isEqualToString:HMServiceTypeLeakSensor] ||
               [serviceType isEqualToString:HMServiceTypeLightSensor] ||
               [serviceType isEqualToString:HMServiceTypeMotionSensor] ||
               [serviceType isEqualToString:HMServiceTypeOccupancySensor] ||
               [serviceType isEqualToString:HMServiceTypeSmokeSensor] ||
               [serviceType isEqualToString:HMServiceTypeTemperatureSensor]) {
        self.cellType = SMCollectionViewCellTypeSensor;
        [self.iconButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (void)iconButtonPressed:(id)sender {
    if (self.iconButtonPressed) {
        self.iconButtonPressed(sender);
    }
}

- (void)editButtonPressed:(id)sender {
    if (self.editButtonPressed) {
        self.editButtonPressed();
    }
}

- (void)removeButtonPressed:(id)sender {
    if (self.removeButtonPressed) {
        self.removeButtonPressed();
    }
}


@end

