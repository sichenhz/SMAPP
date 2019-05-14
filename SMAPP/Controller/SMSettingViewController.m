//
//  SMSettingViewController.m
//  SMAPP
//
//  Created by Jason on 6/5/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMSettingViewController.h"
#import "Const.h"

@interface SMSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HMHome *home;
@property (nonatomic, strong) HMRoom *room;

@end

@implementation SMSettingViewController

- (instancetype)initWithHome:(HMHome *)home {
    if (self = [super init]) {
        _home = home;
    }
    return self;
}

- (instancetype)initWithRome:(HMRoom *)room {
    if (self = [super init]) {
        _room = room;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.tableView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    self.tableView.tableFooterView = [[UIView alloc] init]; // remove the lines
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
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
        cell.textLabel.font = FONT_BODY;
        cell.textLabel.textColor = COLOR_TITLE;
    }

    switch (indexPath.section) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.home.name;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            break;
        case 2:
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        default:
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 172;
    } else {
        return 44;
    }
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
        case 2:
            header.textLabel.text = @"Home Notes";
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

@end
