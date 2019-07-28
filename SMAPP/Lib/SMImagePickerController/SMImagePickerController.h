//
//  SMImagePickerController.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

@import Photos;

@protocol SMImagePickerControllerDelegate;

typedef NS_ENUM(NSInteger, SMImagePickerControllerSourceType) {
    SMImagePickerControllerSourceTypePhotoLibrary,
    SMImagePickerControllerSourceTypeSavedPhotosAlbum,
    SMImagePickerControllerSourceTypeCamera
};

@interface SMImagePickerController : UIViewController

@property (nonatomic, weak) id <SMImagePickerControllerDelegate> delegate;

@property (nonatomic) SMImagePickerControllerSourceType sourceType;
@property (nonatomic, strong) NSArray *mediaTypes; // default value is an array containing PHAssetMediaTypeImage.

@property (nonatomic) BOOL allowsMultipleSelection; // default value is NO.
@property (nonatomic) NSInteger maxMultipleCount; // default is unlimited and value is 0.

// These two properties are available when allowsMultipleSelection value is NO.
@property (nonatomic) BOOL allowsEditing; // default value is NO.
@property (nonatomic) CGSize cropSize; // default value is {[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width}

@property (nonatomic, strong) NSMutableArray <PHAsset *>*selectedAssets;
// Managing Asset Selection
- (void)selectAsset:(PHAsset *)asset;
- (void)deselectAsset:(PHAsset *)asset;

// User finish Actions
- (void)finishPickingAssets;
- (void)finishPickingImage:(UIImage *)image;
- (void)cancel;

- (void)presentAlbums;
- (void)presentCamera;
- (void)updateStatusBarHidden:(BOOL)hidden animation:(BOOL)animation;

@end

@protocol SMImagePickerControllerDelegate <NSObject>

@optional

- (void)assetsPickerControllerDidCancel:(SMImagePickerController *)picker;

- (void)assetsPickerControllerDidOverrunMaxMultipleCount:(SMImagePickerController *)picker;

// This method is called when photos are from albums.
- (void)assetsPickerController:(SMImagePickerController *)picker didFinishPickingAssets:(NSArray <PHAsset *>*)assets;
// This method is called when image is from camera or cliping.
- (void)assetsPickerController:(SMImagePickerController *)picker didFinishPickingImage:(UIImage *)image;

@end
