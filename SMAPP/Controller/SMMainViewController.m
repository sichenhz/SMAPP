//
//  SMMainViewController.m
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMMainViewController.h"
#import "const.h"
#import "Masonry.h"
#import "HMHomeManager+Share.h"
#import "SMAlertView.h"
#import "SMImagePickerController.h"
#import "SMImageClipViewController.h"

@interface SMMainViewController () <SMImagePickerControllerDelegate, SMImageClipViewControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HMHomeManager *namager = [HMHomeManager sharedManager];
    self.navigationItem.title = namager.primaryHome.name;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeName:) name:kDidUpdateHomeName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeName:) name:kDidUpdatePrimaryHome object:nil];
    
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    self.navigationItem.rightBarButtonItem = rightbuttonItem;
}

- (void)rightButtonItemPressed:(id)sender {
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Take Photo" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self cameraButtonPressed];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Select Photo" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self albumsButtonPressed];
    }]];

    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView show];
}

- (void)cameraButtonPressed {
    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = SMImagePickerControllerSourceTypeCamera;
    
    picker.allowsEditing = YES;
    picker.cropSize = CGSizeMake(750, 750);
    picker.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)albumsButtonPressed {
    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = SMImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    picker.allowsEditing = YES;
    picker.cropSize = CGSizeMake(750, 750);
    picker.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _imageView;
}

#pragma mark - Notification

- (void)updateHomeName:(NSNotification *)notification {
    HMHome *home = notification.userInfo[@"home"];
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if ([home isEqual:manager.primaryHome]) {
        self.navigationItem.title = home.name;
    }
}

#pragma mark - SMImagePickerControllerDelegate

- (void)assetsPickerController:(SMImagePickerController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:nil];

    self.imageView.image = image;
}

- (void)assetsPickerControllerDidCancel:(SMImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - SMImageClipViewControllerDelegate

- (void)clipViewControllerDidCancel:(SMImageClipViewController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clipViewController:(SMImageClipViewController *)picker didFinishClipImage:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:^{

        self.imageView.image = image;
    }];
}

@end
