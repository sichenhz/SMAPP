//
//  SMSettingsViewController.m
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMSettingsViewController.h"
#import "SMSettingsTableViewCell.h"
#import "HMHomeManager+Share.h"
#import "SMHomeListViewController.h"
#import "SMRoomListViewController.h"
#import "const.h"

@interface SMSettingsViewController ()

@end

@implementation SMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Menu";
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
    if (!cell) {
        cell = [[SMSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSMSettingsTableViewCell];
        cell.textLabel.font = FONT_BODY;
        cell.textLabel.textColor = COLOR_TITLE;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.iconView.image = [UIImage imageNamed:@"home"];
            cell.leftLabel.text = @"Home Settings";
            break;
        case 1:
            cell.iconView.image = [UIImage imageNamed:@"room"];
            cell.leftLabel.text = @"Room Settings";
            break;
        case 2:
            cell.iconView.image = [UIImage imageNamed:@"settings"];
            cell.leftLabel.text = @"Settings";
            break;
        case 3:
            cell.iconView.image = [UIImage imageNamed:@"help"];
            cell.leftLabel.text = @"Help";
            break;
        case 4:
            cell.iconView.image = [UIImage imageNamed:@"about"];
            cell.leftLabel.text = @"About";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            {
                SMHomeListViewController *HomeListVC = [[SMHomeListViewController alloc] init];
                [self.navigationController pushViewController:HomeListVC animated:YES];
            }
            break;
        case 1:
        {
            SMRoomListViewController *roomListVC = [[SMRoomListViewController alloc] initWithHome:[HMHomeManager sharedManager].primaryHome];
            [self.navigationController pushViewController:roomListVC animated:YES];
        }
            break;
        case 2:
        {
            //
        }
            break;
        case 3:
        {
            //
        }
            break;
        case 4:
        {
            //
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
