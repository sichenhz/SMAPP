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

@interface SMCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

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
        make.left.equalTo(editButton.superview).offset(5);
        make.bottom.equalTo(editButton.superview).offset(-5);
        make.width.height.equalTo(@25);
    }];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:removeButton];
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(removeButton.superview).offset(-5);
        make.width.height.equalTo(@25);
    }];
    [removeButton setImage:[UIImage imageNamed:@"Goods-details_delete"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(imageView.superview);
        make.height.equalTo(imageView.superview).dividedBy(3);
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;
}

- (void)setServiceType:(NSString *)serviceType {
    _serviceType = serviceType;
    
    if (self.isOn) {
        [self.imageView setImage:[UIImage imageNamed:@"placeholder_on"]];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"placeholder_off"]];
    }
    
    if ([serviceType isEqualToString:HMServiceTypeLightbulb]) {
        if (self.isOn) {
            [self.imageView setImage:[UIImage imageNamed:@"bulb_on"]];
        } else {
            [self.imageView setImage:[UIImage imageNamed:@"bulb_off"]];
        }
    } else if ([serviceType isEqualToString:HMServiceTypeSwitch]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeThermostat]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeGarageDoorOpener]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeAccessoryInformation]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeFan]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeOutlet]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeLockMechanism]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeLockManagement]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeAirQualitySensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeBattery]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeCarbonDioxideSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeCarbonMonoxideSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeContactSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeDoor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeDoorbell]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeHumiditySensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeLeakSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeLightSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeMotionSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeOccupancySensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeSecuritySystem]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeStatefulProgrammableSwitch]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeStatelessProgrammableSwitch]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeSmokeSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeTemperatureSensor]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeWindow]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeWindowCovering]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeCameraRTPStreamManagement]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeCameraControl]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeMicrophone]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeSpeaker]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeAirPurifier]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeVentilationFan]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeFilterMaintenance]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeHeaterCooler]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeHumidifierDehumidifier]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeSlats]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeLabel]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeIrrigationSystem]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeValve]) {
        
    } else if ([serviceType isEqualToString:HMServiceTypeFaucet]) {
        
    } else {
        
    }
}

#pragma mark - Action

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

