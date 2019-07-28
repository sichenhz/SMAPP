//
//  SMGridViewController.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMImagePickerController.h"

@interface SMGridViewController : UICollectionViewController

@property (nonatomic, strong) PHFetchResult *assets;

- (instancetype)initWithPicker:(SMImagePickerController *)picker;

@end
