//
//  SMSettingsViewController.m
//  SMAPP
//
//  Created by Jason on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMSettingsViewController.h"
#import "const.h"

@interface SMSettingsViewController ()

@end

@implementation SMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
        cell.textLabel.font = FONT_BODY;
        cell.textLabel.textColor = COLOR_TITLE;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"My Devices";
            break;
        case 1:
            cell.textLabel.text = @"App Settings";
            break;
        case 2:
            cell.textLabel.text = @"Help";
            break;
        case 3:
            cell.textLabel.text = @"Term and Conditions";
            break;
        case 4:
            cell.textLabel.text = @"About SMAPP";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
