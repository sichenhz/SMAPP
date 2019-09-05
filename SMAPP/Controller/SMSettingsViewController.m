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
#import "const.h"

@interface SMSettingsViewController ()

@end

@implementation SMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
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
            cell.iconView.image = [UIImage imageNamed:@"set"];
            cell.leftLabel.text = @"Home settings";
            break;
        case 1:
            cell.iconView.image = [UIImage imageNamed:@"set"];
            cell.leftLabel.text = @"Floor settings";
            break;
        case 2:
            cell.iconView.image = [UIImage imageNamed:@"set"];
            cell.leftLabel.text = @"Room Settings";
            break;
        case 3:
            cell.iconView.image = [UIImage imageNamed:@"set"];
            cell.leftLabel.text = @"Settings";
            break;
        case 4:
            cell.iconView.image = [UIImage imageNamed:@"set"];
            cell.leftLabel.text = @"Help";
            break;
        case 5:
            cell.iconView.image = [UIImage imageNamed:@"set"];
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
            //
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
        case 5:
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
