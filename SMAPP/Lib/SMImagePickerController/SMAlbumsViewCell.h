//
//  SMAlbumsViewCell.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

@import UIKit;

static CGSize const kAlbumThumbnailSize = {57.0f, 57.0f};

@interface SMAlbumsViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, copy) NSString *representedAlbumIdentifier;

@end
