//
//  Const.h
//  SMAPP
//
//  Created by Sichen on 16/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#ifndef Const_h
#define Const_h

static NSString *const kDidUpdateAccessory = @"kDidUpdateAccessory";
static NSString *const kDidRemoveAccessory = @"kDidRemoveAccessory";
static NSString *const kDidUpdateCurrentHomeInfo = @"kDidUpdateCurrentHomeInfo";
static NSString *const kDidUpdateCharacteristicValue = @"kDidUpdateCharacteristicValue";

static NSString *const kUITableViewCell = @"kUITableViewCell";
static NSString *const kSMTableViewCell = @"kSMTableViewCell";
static NSString *const kSMTableViewHeaderView = @"kSMTableViewHeaderView";
static NSString *const kSMCollectionViewCell = @"kSMCollectionViewCell";

// Color
#define RandomColor [UIColor colorWithRed:(arc4random_uniform(256)/255.0) green:(arc4random_uniform(256)/255.0) blue:(arc4random_uniform(256)/255.0) alpha:1]

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR_ORANGE HEXCOLOR(0xFFA500)

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

#endif /* Const_h */
