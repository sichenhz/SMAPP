//
//  SMGridViewCell.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

@import UIKit;

@interface SMGridViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *thumbnailView;
@property (nonatomic, copy) NSString *representedAssetIdentifier;

// Selection overlay
@property (nonatomic) BOOL allowsSelection;

@end
