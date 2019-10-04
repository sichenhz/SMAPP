//
//  SMService.m
//  SMAPP
//
//  Created by Jason on 8/9/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMService.h"
#import <HomeKit/HomeKit.h>

@implementation SMService

+ (SMServiceType)typeWithTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:HMServiceTypeLightbulb]) {
        return SMServiceTypeBulb;
    } else if ([typeString isEqualToString:HMServiceTypeGarageDoorOpener]) {
        return SMServiceTypeGarageDoorOpener;
    } else if ([typeString isEqualToString:HMServiceTypeFan]) {
        return SMserviceTypeFan;
    } else if ([typeString isEqualToString:HMServiceTypeHeaterCooler]) {
        return SMserviceTypeHeaterCooler;
    } else if ([typeString isEqualToString:HMServiceTypeDoor]) {
        return SMserviceTypeGate;
    } else if ([typeString isEqualToString:HMServiceTypeSwitch] ||
               [typeString isEqualToString:HMServiceTypeThermostat] ||
//               [typeString isEqualToString:HMServiceTypeOutlet] ||
//               [typeString isEqualToString:HMServiceTypeLockMechanism] ||
               [typeString isEqualToString:HMServiceTypeLockManagement] ||
               [typeString isEqualToString:HMServiceTypeBattery] ||
               [typeString isEqualToString:HMServiceTypeDoorbell] ||
               [typeString isEqualToString:HMServiceTypeSecuritySystem] ||
               [typeString isEqualToString:HMServiceTypeStatefulProgrammableSwitch] ||
               [typeString isEqualToString:HMServiceTypeStatelessProgrammableSwitch] ||
               [typeString isEqualToString:HMServiceTypeWindow] ||
               [typeString isEqualToString:HMServiceTypeWindowCovering] ||
               [typeString isEqualToString:HMServiceTypeCameraRTPStreamManagement] ||
               [typeString isEqualToString:HMServiceTypeCameraControl] ||
               [typeString isEqualToString:HMServiceTypeMicrophone] ||
               [typeString isEqualToString:HMServiceTypeSpeaker] ||
               [typeString isEqualToString:HMServiceTypeAirPurifier] ||
               [typeString isEqualToString:HMServiceTypeVentilationFan] ||
               [typeString isEqualToString:HMServiceTypeFilterMaintenance] ||
               [typeString isEqualToString:HMServiceTypeHumidifierDehumidifier] ||
               [typeString isEqualToString:HMServiceTypeSlats] ||
               [typeString isEqualToString:HMServiceTypeLabel] ||
               [typeString isEqualToString:HMServiceTypeIrrigationSystem] ||
               [typeString isEqualToString:HMServiceTypeValve] ||
               [typeString isEqualToString:HMServiceTypeFaucet]) {
        return SMServiceTypeSwitch;
    } else if ([typeString isEqualToString:HMServiceTypeAccessoryInformation] ||
               [typeString isEqualToString:HMServiceTypeCarbonDioxideSensor] ||
               [typeString isEqualToString:HMServiceTypeCarbonMonoxideSensor] ||
               [typeString isEqualToString:HMServiceTypeAirQualitySensor] ||
               [typeString isEqualToString:HMServiceTypeContactSensor] ||
               [typeString isEqualToString:HMServiceTypeHumiditySensor] ||
               [typeString isEqualToString:HMServiceTypeLeakSensor] ||
               [typeString isEqualToString:HMServiceTypeLightSensor] ||
               [typeString isEqualToString:HMServiceTypeMotionSensor] ||
               [typeString isEqualToString:HMServiceTypeOccupancySensor] ||
               [typeString isEqualToString:HMServiceTypeSmokeSensor] ||
               [typeString isEqualToString:HMServiceTypeTemperatureSensor]) {
        return SMServiceTypeSensor;
    }
    else if ([typeString isEqualToString:HMServiceTypeOutlet]) {
        return SMserviceTypeTV;
    }
    else if ([typeString isEqualToString:HMServiceTypeLockMechanism]) {
        return SMserviceTypeAirconditioner;
    }

    return SMServiceTypeOther;
}

@end
