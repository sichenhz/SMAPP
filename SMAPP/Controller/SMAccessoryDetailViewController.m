//
//  SMAccessoryViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMAccessoryDetailViewController.h"
#import "SMServiceViewController.h"
#import "Const.h"
#import "SMAlertView.h"
#import "HMHomeManager+Share.h"

@interface SMAccessoryDetailViewController ()

@end

@implementation SMAccessoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.accessory.name;
    
    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.accessory.services.count;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = FONT_BODY;
        cell.textLabel.textColor = COLOR_TITLE;
    }

    switch (indexPath.section) {
        case 0:
        {
            HMService *service = self.accessory.services[indexPath.row];
            cell.textLabel.text = service.name;
            cell.detailTextLabel.text = service.localizedDescription;
            cell.detailTextLabel.textColor = COLOR_LINE;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default:
        {
            cell.textLabel.text = @"Room";
            cell.detailTextLabel.text = self.accessory.room.name;
            cell.detailTextLabel.textColor = COLOR_ORANGE;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            SMServiceViewController *viewController = [[SMServiceViewController alloc] init];
            viewController.service = self.accessory.services[indexPath.row];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
        {
            HMHomeManager *manager = [HMHomeManager sharedManager];
            
            SMAlertView *alertView = [SMAlertView alertViewWithTitle:nil message:nil style:SMAlertViewStyleActionSheet];
            
            [alertView addAction:[SMAlertAction actionWithTitle:@"Create New" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
                
                SMAlertView *alertView = [SMAlertView alertViewWithTitle:@"Add Room..." message:@"Please make sure the name is unique." style:SMAlertViewStyleAlert];
                
                [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Ex. Kitchen, Living Room";
                }];
                
                [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
                
                [alertView addAction:[SMAlertAction actionWithTitle:@"Save" style:SMAlertActionStyleConfirm handler:^(SMAlertAction * _Nonnull action) {
                    NSString *newName = alertView.textFields.firstObject.text;
                    [manager.primaryHome addRoomWithName:newName completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"%@", error);
                        } else {
                            [self assignAccessory:self.accessory toRoom:room];
                        }
                    }];
                }]];
                [alertView show];
                
            }]];
            
            for (HMRoom *room in manager.primaryHome.rooms) {
                NSString *roomName = room.name;
                [alertView addAction:[SMAlertAction actionWithTitle:roomName style:SMAlertActionStyleDefault handler:^(SMAlertAction * _Nonnull action) {
                    [self assignAccessory:self.accessory toRoom:room];
                }]];
            }
            [alertView addAction:[SMAlertAction actionWithTitle:@"Cancel" style:SMAlertActionStyleCancel handler:nil]];
            [alertView show];
        }
            break;
    }
}

- (void)assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room {
    
    [[HMHomeManager sharedManager].primaryHome assignAccessory:accessory toRoom:room completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"%@ room updated.", room.name);
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
