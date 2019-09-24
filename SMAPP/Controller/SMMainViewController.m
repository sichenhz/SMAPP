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
#import "SMHomeViewController.h"
#import "SMCalendarViewController.h"
#import "SMAccessoryListViewController.h"
#import "SMSettingsViewController.h"

@interface SMButtonService : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) HMService *service;

@end

@implementation SMButtonService

+ (instancetype)serviceWithButton:(UIButton *)button service:(HMService *)service {
    SMButtonService *buttonService = [[SMButtonService alloc] init];
    buttonService.button = button;
    buttonService.service = service;
    return buttonService;
}

@end

@interface SMMainViewController () <SMImagePickerControllerDelegate, SMImageClipViewControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *buttonServices;

@property (nonatomic, strong) SMButton *titleButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) SMNoFloorPlanView *guideView;

@property (nonatomic, strong) NSMutableArray *childVCs;
@property (nonatomic, strong) UINavigationController *menuVC;
@property (nonatomic, strong) UINavigationController *homeVC;
@property (nonatomic, strong) UINavigationController *favioritesVC;
@property (nonatomic, strong) UINavigationController *calendarVC;

@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, assign, getter=isPoped) BOOL poped;

@property (nonatomic, strong) HMHome *editHome;

@end

@implementation SMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];

    // ensure that imageView is added before subcontrollers
    [self imageView];
    self.currentVC = [self menuVC];
    [self homeVC];
    [self favioritesVC];
    [self calendarVC];

    // notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeName:) name:kDidUpdateHomeName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutAccessory:) name:kDidStartLayoutAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccessories:) name:kDidUpdateAccessory object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccessories:) name:kDidUpdateCharacteristicValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrimaryHome:) name:kDidUpdatePrimaryHome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraButtonPressed:) name:kOpenCamera object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumsButtonPressed:) name:kOpenAlbums object:nil];

    // gesture
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];

    // title button
    self.navigationItem.titleView = self.titleButton;

    // right buttons
    UIImage *image = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightbuttonItem;
     
    // left buttons
    UIButton *button1 = [self careateButtonWithImageName:@"menu" selectedImageName:@"menu_selected"];
    button1.selected = YES;
    [button1 addTarget:self action:@selector(button1Pressed:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button2 = [self careateButtonWithImageName:@"bulb_off" selectedImageName:@"bulb_on"];
    [button2 addTarget:self action:@selector(button2Pressed:) forControlEvents:UIControlEventTouchUpInside];
     
    UIButton *button3 = [self careateButtonWithImageName:@"favourite" selectedImageName:@"favourite_selected"];
    [button3 addTarget:self action:@selector(button3Pressed:) forControlEvents:UIControlEventTouchUpInside];
     
    UIButton *button4 = [self careateButtonWithImageName:@"calendar" selectedImageName:@"calendar_selected"];
    [button4 addTarget:self action:@selector(button4Pressed:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button1],
                                               [[UIBarButtonItem alloc] initWithCustomView:button2],
                                               [[UIBarButtonItem alloc] initWithCustomView:button3],
                                               [[UIBarButtonItem alloc] initWithCustomView:button4]];
}

#pragma mark - Getters

- (NSMutableArray *)childVCs {
    if (!_childVCs) {
        _childVCs = [NSMutableArray array];
    }
    return _childVCs;
}

- (UINavigationController *)menuVC {
    if (!_menuVC) {
        _menuVC = [self createNavigationControllerWithClassName:NSStringFromClass((SMSettingsViewController.self))];
        
        [self.childVCs addObject:_menuVC];
    }
    return _menuVC;
}

- (UINavigationController *)homeVC {
    if (!_homeVC) {
        _homeVC = [self createNavigationControllerWithClassName:NSStringFromClass((SMHomeViewController.self))];

        [self.childVCs addObject:_homeVC];
    }
    return _homeVC;
}

- (UINavigationController *)favioritesVC {
    if (!_favioritesVC) {
        _favioritesVC = [self createNavigationControllerWithClassName:NSStringFromClass(SMAccessoryListViewController.self)];
        
        [self.childVCs addObject:_favioritesVC];
    }
    return _favioritesVC;
}

- (UINavigationController *)calendarVC {
    if (!_calendarVC) {
        _calendarVC = [self createNavigationControllerWithClassName:NSStringFromClass(SMCalendarViewController.self)];

        [self.childVCs addObject:_calendarVC];
    }
    return _calendarVC;
}

- (SMButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [SMButton buttonWithType:UIButtonTypeCustom];
        [_titleButton addTarget:self.homeVC.childViewControllers.firstObject action:@selector(switchHome:) forControlEvents:UIControlEventTouchUpInside];
        _titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleButton.titleLabel.font = FONT_H2_BOLD;
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setImage:[[UIImage imageNamed:@"arrow-drop-down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        HMHomeManager *namager = [HMHomeManager sharedManager];
        [_titleButton setTitle:namager.primaryHome.name forState:UIControlStateNormal];
        [_titleButton sizeToFit];
        _titleButton.width += 15;
        _titleButton.height = self.navigationController.navigationBar.height;
    }
    return _titleButton;
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
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view).offset([self.class navigationHeight]);
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
            make.edges.equalTo(self.scrollView);
        }];
    }
    return _imageView;
}

- (SMNoFloorPlanView *)guideView {
    if (!_guideView) {
        SMNoFloorPlanView *guideView = [[SMNoFloorPlanView alloc] init];
        [guideView.homeButton addTarget:self action:@selector(addHomeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [guideView.albumsButton addTarget:self action:@selector(albumsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [guideView.cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:guideView];
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(guideView.superview);
        }];
        _guideView = guideView;
    }
    return _guideView;
}

- (NSMutableArray *)buttonServices {
    if (!_buttonServices) {
        _buttonServices = [NSMutableArray array];
    }
    return _buttonServices;
}

#pragma mark - Public

- (void)loadFloorPlan:(BOOL)didRemoveTheLastHome {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageFilePath]];
    self.imageView.image = image;
    if (image) {
        [self.guideView removeFromSuperview];
    } else {
        if (didRemoveTheLastHome) {
            self.guideView.label.text = @"Plase Add your home!";
            self.guideView.homeButton.hidden = NO;
            self.guideView.albumsButton.hidden = YES;
            self.guideView.cameraButton.hidden = YES;
        } else {
            self.guideView.label.text = @"Please add your floor plan!";
            self.guideView.homeButton.hidden = YES;
            self.guideView.albumsButton.hidden = NO;
            self.guideView.cameraButton.hidden = NO;
        }
    }
}

#pragma mark - Privacy

- (SMDisableHighlightButton *)careateButtonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    SMDisableHighlightButton *button = [[SMDisableHighlightButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    CGRect frame = button.frame;
    frame = button.frame;
    frame.size = button.currentBackgroundImage.size;
    button.frame = frame;
    
    return button;
}

- (UINavigationController *)createNavigationControllerWithClassName:(NSString *)className {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(className) alloc] init]];
    [self addChildViewController:navigationController];
    [self.view addSubview:navigationController.view];
    
    navigationController.view.right = 0;
    navigationController.view.width = WIDTH_NAV_L;
    navigationController.view.top = [self.class navigationHeight];
    navigationController.view.height = HEIGHT_NAV_L - [self.class navigationHeight];;
    navigationController.view.alpha = kAlpha;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_BACKGROUND_DARK;
    [navigationController.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(line.superview);
        make.width.equalTo(@1);
    }];
    
    return navigationController;
}

- (void)resetChildVCsWithCurrentVC:(UIViewController *)currentVC {
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = ((UIBarButtonItem *)obj).customView;
        button.selected = NO;
    }];
    [self.childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ((UIViewController *)obj).view.hidden = YES;
    }];
    
    if (self.isPoped) {
        currentVC.view.left = 0;
    } else {
        currentVC.view.right = 0;
    }
    currentVC.view.hidden = NO;
    self.currentVC = currentVC;
}

- (void)animateWithPop {
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.currentVC.view.frame = CGRectMake(0, self.currentVC.view.frame.origin.y, self.currentVC.view.frame.size.width, self.currentVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.poped = YES;
    }];
}

- (void)animateWithDismiss {
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.currentVC.view.frame = CGRectMake(-self.currentVC.view.frame.size.width, self.currentVC.view.frame.origin.y, self.currentVC.view.frame.size.width, self.currentVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.poped = NO;
    }];
}

- (void)saveFloorPlan:(UIImage *)image home:(HMHome *)home {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:home.uniqueIdentifier.UUIDString];
    // 1 means uncompression
    [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath atomically:YES];
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

- (void)createButton:(BOOL)selected service:(HMService *)service {
    [self createButton:selected service:service centerX:self.imageView.width / 2 centerY:self.imageView.height / 2];
    [self saveCoordinates];
}

- (void)createButton:(BOOL)selected service:(HMService *)service centerX:(CGFloat)centerX centerY:(CGFloat)centerY {
    SMDisableHighlightButton *button = [SMDisableHighlightButton buttonWithType:UIButtonTypeCustom];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [button addGestureRecognizer:gesture];
    
    button.selected = selected;
    
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
    button.size = CGSizeMake(55.0, 55.0);
    button.centerX = centerX;
    button.centerY = centerY;
    
    [self.buttonServices addObject:[SMButtonService serviceWithButton:button service:service]];
}

- (void)removeButton:(HMService *)service {
    for (SMButtonService *buttonService in self.buttonServices) {
        if ([buttonService.service isEqual:service]) {
            [buttonService.button removeFromSuperview];
            [self.buttonServices removeObject:buttonService];
            break;
        }
    }
    [self saveCoordinates];
}

- (void)saveCoordinates {
    NSMutableDictionary *servicesMap = [NSMutableDictionary dictionary];
    for (SMButtonService *buttonService in self.buttonServices) {
        NSLog(@"x:%.f  y:%.f  id:%@\n", buttonService.button.frame.origin.x, buttonService.button.frame.origin.y, buttonService.service.uniqueIdentifier.UUIDString);
        
        NSMutableDictionary *coordinateMap = [NSMutableDictionary dictionary];
        [coordinateMap setObject:@(buttonService.button.centerX) forKey:@"centerX"];
        [coordinateMap setObject:@(buttonService.button.centerY) forKey:@"centerY"];
        
        [servicesMap setObject:coordinateMap forKey:buttonService.service.uniqueIdentifier.UUIDString];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *floorPlansMap = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:kShowedFloorPlan]];
    [floorPlansMap setObject:servicesMap forKey:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
    
    [userDefault setObject:floorPlansMap forKey:kShowedFloorPlan];
}

+ (CGFloat)navigationHeight {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 74.0;
    } else {
        if ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0) {
            return 44.0;
        } else {
            return 32.0;
        }
    }
}

#pragma mark - Actions

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
        [self cameraButtonPressed:nil];
    }]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Select Photo" style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
        if (![HMHomeManager sharedManager].primaryHome) {
            [SMToastView showInView:[UIApplication sharedApplication].keyWindow text:@"Please add a new home." duration:3 autoHide:YES];
            return;
        }

        [self albumsButtonPressed:nil];
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
            } else {
                [(SMHomeViewController *)self.homeVC.childViewControllers.firstObject updatePrimaryHome:home];
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

- (void)cameraButtonPressed:(id)sender {
    
    self.editHome = nil;
    if ([sender isKindOfClass:NSNotification.self]) {
        self.editHome = ((NSNotification *)sender).userInfo[@"home"];
    }

    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = SMImagePickerControllerSourceTypeCamera;
    
    picker.allowsEditing = YES;
    picker.cropSize = self.scrollView.bounds.size;
    picker.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)albumsButtonPressed:(id)sender {
    
    self.editHome = nil;
    if ([sender isKindOfClass:NSNotification.self]) {
        self.editHome = ((NSNotification *)sender).userInfo[@"home"];
    }

    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = SMImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    picker.allowsEditing = YES;
    picker.cropSize = self.scrollView.bounds.size;
    picker.allowWhiteEdges = YES;
    picker.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)button1Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.menuVC];
        sender.selected = YES;
    } else {
        if (self.isPoped) {
            [self animateWithDismiss];
        }
    }
    if (!self.isPoped) {
        [self animateWithPop];
    }
}

- (void)button2Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.homeVC];
        sender.selected = YES;
    } else {
        if (self.isPoped) {
            [self animateWithDismiss];
        }
    }
    if (!self.isPoped) {
        [self animateWithPop];
    }
}

- (void)button3Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.favioritesVC];
        sender.selected = YES;
    } else {
        if (self.isPoped) {
            [self animateWithDismiss];
        }
    }
    if (!self.isPoped) {
        [self animateWithPop];
    }
}

- (void)button4Pressed:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetChildVCsWithCurrentVC:self.calendarVC];
        sender.selected = YES;
    } else {
        if (self.isPoped) {
            [self animateWithDismiss];
        }
    }
    if (!self.isPoped) {
        [self animateWithPop];
    }
}

- (void)buttonPressed:(UIButton *)sender {
    for (SMButtonService *buttonService in self.buttonServices) {
        if ([sender isEqual:buttonService.button]) {
            HMService *service = buttonService.service;
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

- (void)panMenu:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.currentVC.view];
    CGPoint v = [pan velocityInView:self.currentVC.view];
    
    CGFloat y = self.currentVC.view.frame.origin.y;
    CGFloat w = self.currentVC.view.frame.size.width;
    CGFloat h = self.currentVC.view.frame.size.height;
    
    if (self.currentVC.view.frame.origin.x + p.x > 0) {
        self.currentVC.view.frame = CGRectMake(0, y, w, h);
    } else if (CGRectGetMaxX(self.currentVC.view.frame) + p.x < 0) {
        self.currentVC.view.frame = CGRectMake(-w, y, w, h);
    } else {
        self.currentVC.view.frame = CGRectMake(self.currentVC.view.frame.origin.x + p.x, y, w, h);
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.currentVC.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (v.x > kVelocity) { // 向右快速滑动
            [self animateWithPop];
        } else if (v.x < -kVelocity) { // 向左快速滑动
            [self animateWithDismiss];
        } else { // 正常拖拽结束
            if (self.currentVC.view.frame.origin.x >= (-w) / 2) {
                [self animateWithPop];
            } else {
                [self animateWithDismiss];
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
        [self saveCoordinates];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Notification

- (void)updatePrimaryHome:(NSNotification *)notification {
    for (SMButtonService *buttonService in self.buttonServices) {
        [buttonService.button removeFromSuperview];
    }
    [self.buttonServices removeAllObjects];
    
    HMHome *home = notification.userInfo[@"home"];
    BOOL didRemoveTheLastHome = [notification.userInfo[@"didRemoveTheLastHome"] boolValue];
    
    if (didRemoveTheLastHome) {
        [self.titleButton setTitle:@"" forState:UIControlStateNormal];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageFilePath = [path stringByAppendingPathComponent:[HMHomeManager sharedManager].primaryHome.uniqueIdentifier.UUIDString];
        [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:nil];
    } else {
        [self.titleButton setTitle:home.name forState:UIControlStateNormal];
        self.titleButton.height = self.navigationController.navigationBar.height;
        [self loadServices];
    }
    [self.titleButton sizeToFit];
    self.titleButton.width += 15;
    
    [self loadFloorPlan:didRemoveTheLastHome];
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
            for (SMButtonService *buttonService in self.buttonServices) {
                if ([buttonService.service isEqual:serviceInAccessory]) {
                    service = buttonService.service;
                    break;
                }
            }
        };
    }
    
    for (SMButtonService *buttonService in self.buttonServices) {
        if ([service isEqual:buttonService.service]) {
            
            if ([notification.userInfo[@"remove"] isEqualToString:@"1"]) {
                [self removeButton:service];
            } else {
                for (HMCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState]  ||
                        [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] ||
                        [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected]) {
                        
                        buttonService.button.selected = [characteristic.value boolValue];
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

    if ([self.editHome isEqual:[HMHomeManager sharedManager].primaryHome] ||
        self.editHome == nil) {
        self.imageView.image = image;
        [self saveFloorPlan:image home:[HMHomeManager sharedManager].primaryHome];
        [self.guideView removeFromSuperview];
    } else {
        [self saveFloorPlan:image home:self.editHome];
        [(SMHomeViewController *)self.homeVC.childViewControllers.firstObject updatePrimaryHome:self.editHome];
    }
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
        
        if ([self.editHome isEqual:[HMHomeManager sharedManager].primaryHome] ||
            self.editHome == nil) {
            self.imageView.image = image;
            [self saveFloorPlan:image home:[HMHomeManager sharedManager].primaryHome];
            [self.guideView removeFromSuperview];
        } else {
            [self saveFloorPlan:image home:self.editHome];
            [(SMHomeViewController *)self.homeVC.childViewControllers.firstObject updatePrimaryHome:self.editHome];
        }
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
