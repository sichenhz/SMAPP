//
//  SMImageClipViewController.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMImagePickerController.h"
@protocol SMImageClipViewControllerDelegate;

@interface SMImageClipViewController : UIViewController

// If set this property to YES, clipping function would be disable.
@property (nonatomic, getter=isPreview) BOOL preview;

- (instancetype)initWithImage:(UIImage *)image picker:(SMImagePickerController *)picker;

// Call this method and set delegate if you want to use it as a stand-alone tool.
- (instancetype)initWithImage:(UIImage *)image cropSize:(CGSize)cropSize;
@property (nonatomic, weak) id <SMImageClipViewControllerDelegate>delegate;

@end

@protocol SMImageClipViewControllerDelegate <NSObject>

@optional

- (void)clipViewControllerDidCancel:(SMImageClipViewController *)picker;
- (void)clipViewController:(SMImageClipViewController *)picker didFinishClipImage:(UIImage *)image;

@end

