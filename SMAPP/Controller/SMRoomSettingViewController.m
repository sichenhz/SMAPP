//
//  SMRoomSettingViewController.m
//  SMAPP
//
//  Created by Sichen on 15/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMRoomSettingViewController.h"
#import "Const.h"
#import "SMTextFieldTableViewCell.h"
#import "SMButtonTableViewCell.h"
#import "SMAlertView.h"
#import "UIViewController+Show.h"

@interface SMRoomSettingViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) HMRoom *room;

@end

@implementation SMRoomSettingViewController

- (instancetype)initWithRoom:(HMRoom *)room {
    if (self = [super init]) {
        _room = room;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.room.name;
    
    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView = [[UIView alloc] init]; // remove the lines
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

#pragma mark - Action

- (void)doneButtonPressed:(id)sender {
    
    SMTextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.room updateName:cell.textField.text completionHandler:^(NSError * _Nullable error) {
        if (error) {
            [self showError:error];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateRoomName object:self userInfo:@{@"room" : self.room}];
        }
    }];
}

- (void)removeRoom {
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to remove %@?", self.room.name];
    SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:message style:SMAlertViewStyleActionSheet];
    
    [alertView addAction:[SMAlertAction actionWithTitle:@"Remove" style:SMAlertActionStyleConfirm
                                                handler:^(SMAlertAction * _Nonnull action) {
                                                    [[HMHomeManager sharedManager].primaryHome removeRoom:self.room completionHandler:^(NSError * _Nullable error) {
                                                        if (error) {
                                                            [self showError:error];
                                                        } else {
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateRoom object:self userInfo:@{@"room" : self.room}];
                                                        }
                                                    }];
                                                }]];
    [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel
                                                handler:nil]];
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.room isEqual:[HMHomeManager sharedManager].primaryHome.roomForEntireHome]) {
        return 2;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            SMTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMTextFieldTableViewCell];
            if (!cell) {
                cell = [[SMTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyDone;
            }
            cell.textField.text = self.room.name;
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
                cell.backgroundColor = COLOR_BACKGROUND;
                cell.textLabel.font = FONT_BODY;
                cell.textLabel.textColor = COLOR_TITLE;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Take Photo...";
                    break;
                case 1:
                    cell.textLabel.text = @"Draw";
                    break;
                default:
                    cell.textLabel.text = @"Choose from Existing";
                    break;
            }
            return cell;
        }
            break;
        default:
        {
            SMButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMButtonTableViewCell];
            if (!cell) {
                cell = [[SMButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
                [cell.button setTitle:@"Remove Home" forState:UIControlStateNormal];
                __weak typeof(self) weakSelf = self;
                cell.cellPressed = ^{
                    [weakSelf removeRoom];
                };
            }
            return cell;
        }
            break;
    }
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
    
    switch (section) {
        case 0:
            header.textLabel.text = @"Name";
            break;
        case 1:
            header.textLabel.text = @"Floor Plan";
            break;
        default:
            header.textLabel.text = @"";
            break;
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FONT_BODY_BOLD;
    header.textLabel.textColor = COLOR_TITLE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
