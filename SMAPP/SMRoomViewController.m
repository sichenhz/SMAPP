//
//  SMRoomViewController.m
//  SMAPP
//
//  Created by Jason on 15/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMRoomViewController.h"

@interface SMRoomViewController ()

@property (nonatomic, strong) HMHomeManager *homeManager;
@property (nonatomic, assign) HMRoom *currentRoom;
@property (nonatomic, weak) UIButton *removeButton;

@end

@implementation SMRoomViewController

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager {
    if (self = [super init]) {
        _homeManager = homeManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Room";
    
    [self initNavigationItemWithLeftTitle:@"Rooms"];

    __weak typeof(self)weakself = self;
    [self initHeaderViewWithCompletionHandler:^(UIButton *leftButton, UIButton *rightButton) {
        [leftButton setTitle:@"Remove Room" forState:UIControlStateNormal];
        [rightButton setTitle:@"Add Room" forState:UIControlStateNormal];
        
        [leftButton addTarget:self action:@selector(removeRoom:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addTarget:self action:@selector(addRoom:) forControlEvents:UIControlEventTouchUpInside];
        
        weakself.removeButton = leftButton;
        [weakself updateCurrentRoomInfo];
    }];
    
    __weak typeof(self) weakSelf = self;
    self.didAddAccessory = ^(){
        [weakSelf updateCurrentAccessories];
    };
}

- (void)updatePrimaryHome {
    if (self.homeManager.primaryHome) {
        self.currentRoom = self.homeManager.primaryHome.roomForEntireHome;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *currentRoomName = [userDefault objectForKey:self.homeManager.primaryHome.name];
        if (currentRoomName) {
            if ([currentRoomName isEqualToString:self.homeManager.primaryHome.roomForEntireHome.name]) {
                self.currentRoom = self.homeManager.primaryHome.roomForEntireHome;
            } else {
                for (HMRoom *room in self.homeManager.primaryHome.rooms) {
                    if ([currentRoomName isEqualToString:room.name]) {
                        self.currentRoom = room;
                        break;
                    }
                }
            }
        }
        
        [self updateCurrentRoomInfo];
        [self updateCurrentAccessories];
        
    } else {
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"No home" message:nil style:SMAlertViewStyleActionSheet];
        [alertView addAction:[SMAlertAction actionWithTitle:@"OK" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

- (void)updateAccessory {
    [self updateCurrentAccessories];
}

- (void)updateCurrentRoomInfo {
    self.textLabel.text = [NSString stringWithFormat:@"current room：%@", self.currentRoom.name];
    
    self.dataList = self.currentRoom.accessories;
    if ([self.currentRoom isEqual:self.homeManager.primaryHome.roomForEntireHome]) {
        self.removeButton.enabled = NO;
    } else {
        self.removeButton.enabled = YES;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.currentRoom.name forKey:self.homeManager.primaryHome.name];
}

- (void)updateCurrentAccessories {    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)leftButtonItemPressed:(id)sender {
    if (self.homeManager.primaryHome.rooms.count > 0) {
        
        HMRoom *roomForEntireHome = [self.homeManager.primaryHome roomForEntireHome];
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;

        [alertView addAction:[SMAlertAction actionWithTitle:roomForEntireHome.name style:SMAlertActionStyleDefault selected:[self.currentRoom.name isEqualToString:roomForEntireHome.name] handler:^(SMAlertAction * _Nonnull action) {
            weakSelf.currentRoom = roomForEntireHome;
            [weakSelf.tableView reloadData];
            [weakSelf updateCurrentRoomInfo];
            [weakSelf updateCurrentAccessories];
        }]];
        
        for (HMRoom *room in self.homeManager.primaryHome.rooms) {
            NSString *roomName = room.name;
            BOOL selected = [self.currentRoom.name isEqualToString:roomName];
            [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault  selected:selected handler:^(SMAlertAction * _Nonnull action) {
                for (HMRoom *room in weakSelf.homeManager.primaryHome.rooms) {
                    if ([room.name isEqualToString:action.title]) {
                        weakSelf.currentRoom = room;
                        [weakSelf.tableView reloadData];
                        [weakSelf updateCurrentRoomInfo];
                        [weakSelf updateCurrentAccessories];
                        break;
                    }
                }
            }]];
        }
        
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
        [alertView show];
    }
}

- (void)rightButtonItemPressed:(id)sender {
    SMAddAccessoryViewController *vc = [[SMAddAccessoryViewController alloc] initWithHomeManager:self.homeManager];
    vc.didAddAccessory = self.didAddAccessory;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)addRoom:(id)sender {
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Kitchen, Living Room";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    __weak typeof(self) weakSelf = self;
    [alertView addAction:[SMAlertAction actionWithTitle:@"Confirm" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        [weakSelf.homeManager.primaryHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                weakSelf.currentRoom = room;
                [weakSelf updateCurrentRoomInfo];
                [weakSelf updateCurrentAccessories];
            }
        }];
    }]];
    [alertView show];
}

- (void)removeRoom:(id)sender {
    if (self.homeManager.primaryHome) {
        SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to remove '%@' from your home?", self.currentRoom.name] style:SMAlertViewStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;
        [alertView addAction:[SMAlertAction actionWithTitle:@"Remove" style:SMAlertActionStyleConfirm
                                                    handler:^(SMAlertAction * _Nonnull action) {
                                                        [self.homeManager.primaryHome removeRoom:weakSelf.currentRoom completionHandler:^(NSError * _Nullable error) {
                                                            if (error) {
                                                                NSLog(@"%@", error);
                                                            } else {
                                                                if (weakSelf.homeManager.primaryHome.rooms.count) {
                                                                    weakSelf.currentRoom = weakSelf.homeManager.primaryHome.rooms.firstObject;
                                                                    [weakSelf updateCurrentRoomInfo];
                                                                    [weakSelf updateCurrentAccessories];
                                                                }
                                                            }
                                                        }];
                                                    }]];
        [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel
                                                    handler:nil]];
        [alertView show];
    }
}

@end
