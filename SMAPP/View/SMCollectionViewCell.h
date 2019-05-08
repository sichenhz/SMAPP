//
//  SMCollectionViewCell.h
//  SMAPP
//
//  Created by Jason on 7/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *topLabel;
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, copy) void(^editButtonPressed)(void);
@property (nonatomic, copy) void(^removeButtonPressed)(void);

@end

NS_ASSUME_NONNULL_END
