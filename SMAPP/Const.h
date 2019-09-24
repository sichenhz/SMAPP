//
//  Const.h
//  SMAPP
//
//  Created by Sichen on 16/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#ifndef Const_h
#define Const_h

// Data persistence
static NSString *const kShowedFloorPlan = @"kShowedFloorPlan";
static NSString *const kShowedRoom = @"kShowedRoom";
static NSString *const kShowedService = @"kShowedService";
static NSString *const kFavoriteService = @"kFavoriteService";

// Notification
static NSString *const kDidUpdatePrimaryHome = @"kDidUpdatePrimaryHome";
static NSString *const kDidUpdateHomeName = @"kDidUpdateHomeName";
static NSString *const kDidUpdateHome = @"kDidUpdateHome";
static NSString *const kDidUpdateRoomName = @"kDidUpdateRoomName";
static NSString *const kDidUpdateRoom = @"kDidUpdateRoom";
static NSString *const kDidUpdateAccessory = @"kDidUpdateAccessory";
static NSString *const kDidUpdateCharacteristicValue = @"kDidUpdateCharacteristicValue";
static NSString *const kDidStartLayoutAccessory = @"kDidStartLayoutAccessory";

// Reuse Identifier
static NSString *const kUITableViewHeaderView = @"kUITableViewHeaderView";
static NSString *const kSMTableViewHeaderView = @"kSMTableViewHeaderView";
static NSString *const kUITableViewCell = @"kUITableViewCell";
static NSString *const kSMHomeTableViewCell = @"kSMHomeTableViewCell";
static NSString *const kSMRoomTableViewCell = @"kSMRoomTableViewCell";
static NSString *const kSMHomeListTableViewCell = @"kSMHomeListTableViewCell";
static NSString *const kSMSettingsTableViewCell = @"kSMSettingsTableViewCell";
static NSString *const kSMButtonTableViewCell = @"kSMButtonTableViewCell";
static NSString *const kSMTextFieldTableViewCell = @"kSMTextFieldTableViewCell";
static NSString *const kSMTextViewTableViewCell = @"kSMTextViewTableViewCell";
static NSString *const kSMCollectionViewCell = @"kSMCollectionViewCell";

//#define WIDTH_NAV_R 340
#define WIDTH_NAV_L fabs([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.height)
#define HEIGHT_NAV_L MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// Color
#define RandomColor [UIColor colorWithRed:(arc4random_uniform(256)/255.0) green:(arc4random_uniform(256)/255.0) blue:(arc4random_uniform(256)/255.0) alpha:1]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXCOLORA(rgbValue, a)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define COLOR_ORANGE HEXCOLOR(0xFFA500)
#define COLOR_BACKGROUND HEXCOLOR(0xF2F2F2)
#define COLOR_BACKGROUND_DARK HEXCOLORA(0xDDDEE0, 0.8)
#define COLOR_LINE HEXCOLORA(0x000000, 0.3)
#define COLOR_TITLE HEXCOLOR(0x47525E)

// Font
#define FONT_H1               [UIFont fontWithName:@"CenturyGothic" size:20]
#define FONT_H1_BOLD          [UIFont fontWithName:@"CenturyGothic-Bold" size:20]
#define FONT_H2               [UIFont fontWithName:@"CenturyGothic" size:16]
#define FONT_H2_BOLD          [UIFont fontWithName:@"CenturyGothic-Bold" size:16]
#define FONT_BODY             [UIFont fontWithName:@"CenturyGothic" size:12]
#define FONT_BODY_BOLD        [UIFont fontWithName:@"CenturyGothic-Bold" size:12]
#define FONT_ITALIC           [UIFont fontWithName:@"CenturyGothic-Italic" size:12]

//#define FONT_H1               [UIFont fontWithName:@"Nunito-Regular" size:20]
//#define FONT_H1_BOLD          [UIFont fontWithName:@"Nunito-Bold" size:20]
//#define FONT_H2               [UIFont fontWithName:@"Nunito-Regular" size:16]
//#define FONT_H2_BOLD          [UIFont fontWithName:@"Nunito-Bold" size:16]
//#define FONT_BODY             [UIFont fontWithName:@"Nunito-Regular" size:12]
//#define FONT_BODY_BOLD        [UIFont fontWithName:@"Nunito-Bold" size:12]
//#define FONT_ITALIC           [UIFont fontWithName:@"Nunito-Italic" size:12]

#define kTimeInterval 0.2
#define kVelocity 500.0
#define kAlpha 0.85

#endif /* Const_h */
