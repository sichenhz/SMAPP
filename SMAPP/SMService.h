//
//  SMService.h
//  SMAPP
//
//  Created by Jason on 8/9/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SMServiceTypeOther,
    SMServiceTypeSensor,
    SMServiceTypeSwitch,
    SMServiceTypeBulb,
    SMServiceTypeGarageDoorOpener,
    SMserviceTypeFan,
    SMserviceTypeHeaterCooler,
    SMserviceTypeGate,

    // Fake Devices
    SMserviceTypeTV,
    SMserviceTypeAirconditioner,
    
} SMServiceType;

NS_ASSUME_NONNULL_BEGIN

@interface SMService : NSObject

+ (SMServiceType)typeWithTypeString:(NSString *)typeString;

@end

NS_ASSUME_NONNULL_END
