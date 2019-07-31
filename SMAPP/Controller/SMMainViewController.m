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
#import "SMToastView.h"
#import "UIViewController+Show.h"
#import "SMDisableHighlightButton.h"
#import "UIView+Extention.h"

@interface SMMainService : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) HMService *service;

@end

@implementation SMMainService

+ (instancetype)serviceWithButton:(UIButton *)button service:(HMService *)service {
    SMMainService *mainService = [[SMMainService alloc] init];
    mainService.button = button;
    mainService.service = service;
    return mainService;
}

@end

@interface SMMainViewController () <SMImagePickerControllerDelegate, SMImageClipViewControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *mainServices;

@end

@implementation SMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HMHomeManager *namager = [HMHomeManager sharedManager];
    self.navigationItem.title = namager.primaryHome.name;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeName:) name:kDidUpdateHomeName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeName:) name:kDidUpdatePrimaryHome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutAccessory:) name:kDidStartLayoutAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccessories:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccessories:) name:kDidUpdateCharacteristicValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrimaryHome:) name:kDidUpdatePrimaryHome object:nil];

    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    self.navigationItem.rightBarButtonItem = rightbuttonItem;
}

- (void)rightButtonItemPressed:(id)sender {
    
    if (![HMHomeManager sharedManager].primaryHome) {
        [SMToastView showInView:[UIApplication sharedApplication].keyWindow text:@"Please add a new home." duration:1.5 autoHide:YES];
        return;
    }
    
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

- (void)saveImage:(UIImage *)image {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.name];
    // 1 means uncompression
    [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath atomically:YES];
}

- (void)loadImage {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.name];
    if (imageFilePath) {
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageFilePath]];
    }
}

- (void)createButton:(BOOL)isSelect service:(HMService *)service {
    SMDisableHighlightButton *button = [SMDisableHighlightButton buttonWithType:UIButtonTypeCustom];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [button addGestureRecognizer:gesture];
    
    button.selected = isSelect;
    [button setImage:[UIImage imageNamed:@"bulb_off"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"bulb_on"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.imageView addSubview:button];
    [button sizeToFit];
    button.centerX = self.imageView.width / 2;
    button.centerY = self.imageView.height / 2;
    
    [self.mainServices addObject:[SMMainService serviceWithButton:button service:service]];
}

- (void)removeButton:(HMService *)service {
    for (SMMainService *mainService in self.mainServices) {
        if ([mainService.service isEqual:service]) {
            [mainService.button removeFromSuperview];
            [self.mainServices removeObject:mainService];
            break;
        }
    }
}

- (void)buttonPressed:(UIButton *)sender {
    for (SMMainService *mainService in self.mainServices) {
        if ([sender isEqual:mainService.button]) {
            HMService *service = mainService.service;
            for (HMCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
                    [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                    [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
                    
                    BOOL changedLockState = ![characteristic.value boolValue];
                    
                    [characteristic writeValue:[NSNumber numberWithBool:changedLockState] completionHandler:^(NSError *error) {
                        if (error) {
                            [self showError:error];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                NSLog(@"Changed Lock State: %@", characteristic.value);
                            });
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCharacteristicValue
                                                                                object:self
                                                                              userInfo:@{@"accessory": service.accessory,
                                                                                         @"service": service,
                                                                                         @"characteristic": characteristic}];
                        }
                    }];
                    break;
                }
            }
        }
    }
}

- (void)move:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender translationInView:self.imageView];
    sender.view.center = CGPointMake(sender.view.center.x + pt.x , sender.view.center.y + pt.y);
    //每次移动完，将移动量置为0，否则下次移动会加上这次移动量
    [sender setTranslation:CGPointMake(0, 0) inView:self.imageView];
}

#pragma mark - Getters

- (NSMutableArray *)mainServices {
    if (!_mainServices) {
        _mainServices = [NSMutableArray array];
    }
    return _mainServices;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
            CGRect navRect = self.navigationController.navigationBar.frame;
            CGFloat NavHeight = statusRect.size.height + navRect.size.height;

            make.top.equalTo(self.view).offset(NavHeight);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _imageView;
}

#pragma mark - Notification

#warning  所有被选中放进floor plan的设备（以及坐标）需要分别对应不同的home做本地持久化
- (void)updatePrimaryHome:(NSNotification *)notification {
    for (SMMainService *mainService in self.mainServices) {
        [mainService.button removeFromSuperview];
    }
    [self.mainServices removeAllObjects];
}

- (void)updateHomeName:(NSNotification *)notification {
    HMHome *home = notification.userInfo[@"home"];
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if ([home isEqual:manager.primaryHome]) {
        self.navigationItem.title = home.name;
        [self loadImage];
    }
}

- (void)layoutAccessory:(NSNotification *)notification {
    BOOL isSelect = [notification.userInfo[@"status"] boolValue];
    HMService *service = notification.userInfo[@"service"];

    if (isSelect) {
        for (HMCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
                [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
                
                [self createButton:[characteristic.value boolValue] service:service];
                break;
            }
        }
    } else {
        [self removeButton:service];
    }
}

- (void)updateAccessories:(NSNotification *)notification {
    HMService *service = notification.userInfo[@"service"];
    if (!service) {
        HMAccessory *accessory = notification.userInfo[@"accessory"];
        for (HMService *serviceInAccessory in accessory.services) {
            for (SMMainService *mainService in self.mainServices) {
                if ([mainService.service isEqual:serviceInAccessory]) {
                    service = mainService.service;
                    break;
                }
            }
        };
    }
    
    for (SMMainService *mainService in self.mainServices) {
        if ([service isEqual:mainService.service]) {
            for (HMCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
                    [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                    [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
                    
                    mainService.button.selected = [characteristic.value boolValue];
                    break;
                }
            }
        }
    }
}

#pragma mark - SMImagePickerControllerDelegate

// from album
- (void)assetsPickerController:(SMImagePickerController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:nil];

    self.imageView.image = image;
    [self saveImage:image];
}

// from album
- (void)assetsPickerControllerDidCancel:(SMImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SMImageClipViewControllerDelegate

// from camera
- (void)clipViewControllerDidCancel:(SMImageClipViewController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// from camera
- (void)clipViewController:(SMImageClipViewController *)picker didFinishClipImage:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = image;
        [self saveImage:image];
    }];
}

@end
