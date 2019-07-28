//
//  SMRoomListViewController.m
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMRoomListViewController.h"
#import "Const.h"
#import "SMAlertView.h"
#import "SMHomeListTableViewCell.h"
#import "Masonry.h"
#import "SMRoomSettingViewController.h"
#import "UIViewController+Show.h"

@interface SMRoomListViewController ()

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) HMHome *home;

@end

@implementation SMRoomListViewController

- (instancetype)initWithHome:(HMHome *)home {
    if (self = [super init]) {
        _home = home;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Rooms";
    
    [self initNavigationItems];
    
    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView = [[UIView alloc] init]; // remove the lines
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentRooms:) name:kDidUpdateRoomName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentRooms:) name:kDidUpdateRoom object:nil];
    
    [self updateCurrentRooms];
}

- (void)initNavigationItems {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD}];
    
    UIImage *image = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemPressed:)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateNormal)];
    [rightbuttonItem setTitleTextAttributes:@{NSFontAttributeName : FONT_H2_BOLD, NSForegroundColorAttributeName : COLOR_ORANGE} forState:(UIControlStateHighlighted)];
    self.navigationItem.rightBarButtonItems = @[rightbuttonItem];
}

- (void)updateCurrentRooms {
    self.dataList = [NSMutableArray array];
    [self.dataList addObject:self.home.roomForEntireHome];
    [self.dataList addObjectsFromArray:self.home.rooms];
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)updateCurrentRooms:(NSNotification *)notification {
    [self updateCurrentRooms];
}

#pragma mark - Action

- (void)rightButtonItemPressed:(id)sender {    
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ex. Kitchen, Living Room";
    }];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Save" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
        NSString *newName = alertView.textFields.firstObject.text;
        __weak typeof(self) weakSelf = self;
        [self.home addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
            if (error) {
                [weakSelf showError:error];
            } else {
                [weakSelf updateCurrentRooms];
            }
        }];
    }]];
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMHomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMHomeListTableViewCell];
    if (!cell) {
        cell = [[SMHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
    }
    
    HMRoom *room = self.dataList[indexPath.row];
    cell.leftLabel.text = room.name;
    cell.selectedImageView.hidden = YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kUITableViewHeaderView];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kUITableViewHeaderView];
    }
    header.textLabel.text = @"Room list:";
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FONT_BODY_BOLD;
    header.textLabel.textColor = COLOR_TITLE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMRoom *room = self.dataList[indexPath.item];
    SMRoomSettingViewController *settingVC = [[SMRoomSettingViewController alloc] initWithRoom:room];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
