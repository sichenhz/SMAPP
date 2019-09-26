//
//  SMCollectionViewCell.h
//  SMAPP
//
//  Created by Sichen on 7/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SMCollectionViewCellTypeSensor,
    SMCollectionViewCellTypeSwitch,
    SMCollectionViewCellTypeBulb,
    SMCollectionViewCellGarageDoorOpener,
} SMCollectionViewCellType;

NS_ASSUME_NONNULL_BEGIN

@interface SMCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UILabel *topLabel;
@property (nonatomic, weak, readonly) UIButton *iconButton;

@property (nonatomic, copy) void(^iconButtonPressed)(UIButton *sender);
@property (nonatomic, copy) void(^editButtonPressed)(void);
@property (nonatomic, copy) void(^removeButtonPressed)(void);

@property (nonatomic, assign) SMCollectionViewCellType cellType;
@property (nonatomic, copy) NSString *serviceType;

@end

NS_ASSUME_NONNULL_END
