//
//  HMHomeManager+Share.m
//  SMAPP
//
//  Created by Sichen on 5/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "HMHomeManager+Share.h"

@implementation HMHomeManager (Share)

+ (HMHomeManager *)sharedManager {
    static HMHomeManager *sharedInstance = nil;
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

@end
