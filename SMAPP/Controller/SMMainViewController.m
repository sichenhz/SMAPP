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
#import "SMButton.h"
#import "SMService.h"
#import "SMNoFloorPlanView.h"

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

@interface SMMainViewController () <SMImagePickerControllerDelegate, SMImageClipViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *mainServices;
@property (nonatomic, weak) SMNoFloorPlanView *guideView;

@end

@implementation SMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeName:) name:kDidUpdateHomeName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutAccessory:) name:kDidStartLayoutAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccessories:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccessories:) name:kDidUpdateCharacteristicValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrimaryHome:) name:kDidUpdatePrimaryHome object:nil];

    UIButton *titleButton = [SMButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    titleButton.titleLabel.font = FONT_H2_BOLD;
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setImage:[[UIImage imageNamed:@"arrow-drop-down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
    HMHomeManager *namager = [HMHomeManager sharedManager];
    [titleButton setTitle:namager.primaryHome.name forState:UIControlStateNormal];
    [titleButton sizeToFit];
    titleButton.width += 15;
    titleButton.height = self.navigationController.navigationBar.height;
    _titleButton = titleButton;
    
    UIImage *image = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightbuttonItem;

     // must initialize them before initialization of its subcontrollers' views
    [self imageView];
    [self guideView];
    
    // load image in case there is no primary home
    [self loadImage:NO];
}

- (void)rightButtonItemPressed:(id)sender {
    
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Add Home" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self addHomeButtonPressed];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Add Room" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        [self addRoomButtonPressed];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Take Photo" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        if (![HMHomeManager sharedManager].primaryHome) {
            [SMToastView showInView:[UIApplication sharedApplication].keyWindow text:@"Please add a new home." duration:3 autoHide:YES];
            return;
        }
        [self cameraButtonPressed];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Select Photo" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        if (![HMHomeManager sharedManager].primaryHome) {
            [SMToastView showInView:[UIApplication sharedApplication].keyWindow text:@"Please add a new home." duration:3 autoHide:YES];
            return;
        }

        [self albumsButtonPressed];
    }]];

    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView show];
}

- (void)addHomeButtonPressed {
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Home..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Vacation Home";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Save" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        [manager addHomeWithName:newName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
            if (error) {
                [self showError:error];
            }
        }];
    }]];
    [alertView show];
}

- (void)addRoomButtonPressed {
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Kitchen, Living Room";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Save" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        __weak typeof(self) weakSelf = self;
        [[HMHomeManager sharedManager].primaryHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            if (error) {
                [weakSelf showError:error];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateRoom object:self userInfo:@{@"room" : room}];
            }
        }];
    }]];
    [alertView show];
}

- (void)cameraButtonPressed {
    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = SMImagePickerControllerSourceTypeCamera;
    
    picker.allowsEditing = YES;
    picker.cropSize = self.scrollView.bounds.size;
    picker.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)albumsButtonPressed {
    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = SMImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    picker.allowsEditing = YES;
    picker.cropSize = self.scrollView.bounds.size;
    picker.allowWhiteEdges = YES;
    picker.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
    // 1 means uncompression
    [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath atomically:YES];
    
    [self.guideView removeFromSuperview];
}

- (void)loadImage:(BOOL)didRemovePrimaryHome {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageFilePath]];
    self.imageView.image = image;
    if (!image) {
        if ([HMHomeManager sharedManager].primaryHome && !didRemovePrimaryHome) {
            self.guideView.label.text = @"Please add your floor plan!";
            self.guideView.homeButton.hidden = YES;
            self.guideView.albumsButton.hidden = NO;
            self.guideView.cameraButton.hidden = NO;
        } else {
            self.guideView.label.text = @"Plase Add your home!";
            self.guideView.homeButton.hidden = NO;
            self.guideView.albumsButton.hidden = YES;
            self.guideView.cameraButton.hidden = YES;
        }
    } else {
        [self.guideView removeFromSuperview];
    }
}

- (void)loadServices {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *floorPlansMap = [userDefaults objectForKey:kShowedFloorPlan];
    NSDictionary *servicesMap = [floorPlansMap objectForKey:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
    
    for (HMAccessory *accessory in [HMHomeManager sharedManager].primaryHome.accessories) {
        for (HMService *service in accessory.services) {
            NSDictionary *coordinateMap = [servicesMap objectForKey:service.uniqueIdentifier.UUIDString];
            if (coordinateMap) {
                
                CGFloat centerX = [[coordinateMap objectForKey:@"centerX"] floatValue];
                CGFloat centerY = [[coordinateMap objectForKey:@"centerY"] floatValue];
                SMServiceType type = [SMService typeWithTypeString:service.serviceType];
                
                if (type == SMServiceTypeBulb ||
                    type == SMServiceTypeSwitch) {
                    for (HMCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
                            [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                            [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
                            
                            [self createButton:[characteristic.value boolValue] service:service centerX:centerX centerY:centerY];
                            break;
                        }
                    }
                } else if (type == SMServiceTypeSensor) {
#warning TODO
                    [self createButton:NO service:service centerX:centerX centerY:centerY];
                }
            }
        }
    }
}

- (void)createButton:(BOOL)isSelect service:(HMService *)service {
    [self createButton:isSelect service:service centerX:self.imageView.width / 2 centerY:self.imageView.height / 2];
    [self save];
}

- (void)createButton:(BOOL)isSelect service:(HMService *)service centerX:(CGFloat)centerX centerY:(CGFloat)centerY {
    SMDisableHighlightButton *button = [SMDisableHighlightButton buttonWithType:UIButtonTypeCustom];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [button addGestureRecognizer:gesture];
    
    button.selected = isSelect;
    
    SMServiceType type = [SMService typeWithTypeString:service.serviceType];
    
    if (type == SMServiceTypeBulb) {
        [button setImage:[UIImage imageNamed:@"bulb_off_l"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"bulb_on_l"] forState:UIControlStateSelected];
    } else if (type == SMServiceTypeSwitch) {
        [button setImage:[UIImage imageNamed:@"placeholder_off"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"placeholder_on"] forState:UIControlStateSelected];
    } else if (type == SMServiceTypeSensor) {
        [button setImage:[UIImage imageNamed:@"sensor"] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.imageView addSubview:button];
    [button sizeToFit];
    button.centerX = centerX;
    button.centerY = centerY;
    
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
    [self save];
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
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self save];
    }
}

- (void)save {
    NSMutableDictionary *servicesMap = [NSMutableDictionary dictionary];
    for (SMMainService *mainService in self.mainServices) {
        NSLog(@"x:%.f  y:%.f  id:%@\n", mainService.button.frame.origin.x, mainService.button.frame.origin.y, mainService.service.uniqueIdentifier.UUIDString);
        
        NSMutableDictionary *coordinateMap = [NSMutableDictionary dictionary];
        [coordinateMap setObject:@(mainService.button.centerX) forKey:@"centerX"];
        [coordinateMap setObject:@(mainService.button.centerY) forKey:@"centerY"];
        
        [servicesMap setObject:coordinateMap forKey:mainService.service.uniqueIdentifier.UUIDString];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *floorPlansMap = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:kShowedFloorPlan]];
    [floorPlansMap setObject:servicesMap forKey:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
    
    [userDefault setObject:floorPlansMap forKey:kShowedFloorPlan];
}

#pragma mark - Getters

- (NSMutableArray *)mainServices {
    if (!_mainServices) {
        _mainServices = [NSMutableArray array];
    }
    return _mainServices;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.bounces = NO;
        _scrollView.bouncesZoom = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _imageView;
}

- (SMNoFloorPlanView *)guideView {
    if (!_guideView) {
        SMNoFloorPlanView *guideView = [[SMNoFloorPlanView alloc] init];
        [guideView.homeButton addTarget:self action:@selector(addHomeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [guideView.albumsButton addTarget:self action:@selector(albumsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [guideView.cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:guideView];
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _guideView = guideView;
    }
    return _guideView;
}

#pragma mark - Notification

- (void)updatePrimaryHome:(NSNotification *)notification {
    for (SMMainService *mainService in self.mainServices) {
        [mainService.button removeFromSuperview];
    }
    [self.mainServices removeAllObjects];
    
    HMHome *home = notification.userInfo[@"home"];
    BOOL didRemovePrimaryHome = [notification.userInfo[@"remove"] boolValue];
    
    if (!didRemovePrimaryHome) {
        [self.titleButton setTitle:home.name forState:UIControlStateNormal];
        [self.titleButton sizeToFit];
        self.titleButton.width += 15;
        self.titleButton.height = self.navigationController.navigationBar.height;
        [self loadServices];
    } else {
        [self.titleButton setTitle:@"" forState:UIControlStateNormal];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
        [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:nil];
    }
    [self loadImage:didRemovePrimaryHome];
}

- (void)updateHomeName:(NSNotification *)notification {
    HMHome *home = notification.userInfo[@"home"];
    HMHomeManager *manager = [HMHomeManager sharedManager];
    
    if ([home isEqual:manager.primaryHome]) {
        [self.titleButton setTitle:home.name forState:UIControlStateNormal];
        [self.titleButton sizeToFit];
        self.titleButton.width += 15;
        self.titleButton.height = self.navigationController.navigationBar.height;
    }
}

- (void)layoutAccessory:(NSNotification *)notification {
    BOOL isSelect = [notification.userInfo[@"status"] boolValue];
    HMService *service = notification.userInfo[@"service"];
    
    if (isSelect) {
        SMServiceType type = [SMService typeWithTypeString:service.serviceType];
        if (type == SMServiceTypeBulb ||
            type == SMServiceTypeSwitch) {
            for (HMCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
                    [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                    [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
                    
                    [self createButton:[characteristic.value boolValue] service:service];
                    break;
                }
            }
        } else if (type == SMServiceTypeSensor) {
#warning TODO
            [self createButton:NO service:service];
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
            
            if ([notification.userInfo[@"remove"] isEqualToString:@"1"]) {
                [self removeButton:service];
            } else {
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

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    self.imageView.center = actualCenter;
}

@end
