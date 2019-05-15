//
//  SMAddViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMAddAccessoryViewController.h"
#import "HMHomeManager+Share.h"
#import "Const.h"
#import "UIViewController+Show.h"

@interface SMAddAccessoryViewController () <HMAccessoryBrowserDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) HMAccessoryBrowser *accessoryBrowser;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SMAddAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    self.navigationItem.title = @"Add";
    self.dataList = [NSMutableArray array];
    
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![viewController isEqual:self]) {
        [self.accessoryBrowser stopSearchingForNewAccessories];
    } else {
        [self.accessoryBrowser startSearchingForNewAccessories];
    }
}


#pragma mark - HMAccessoryBrowserDelegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    [self.dataList addObject:accessory];
    [self.tableView reloadData];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    [self.dataList removeObject:accessory];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kUITableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = FONT_BODY;
        cell.textLabel.textColor = COLOR_TITLE;
    }
    HMAccessory *accessory = self.dataList[indexPath.row];
    cell.textLabel.text = accessory.name;
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMAccessory *accessory = [self.dataList objectAtIndex:indexPath.row];
    
    [[HMHomeManager sharedManager].primaryHome addAccessory:accessory completionHandler:^(NSError *error) {
        if (error) {
            [self showError:error];
        } else {
            [tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:self userInfo:@{@"accessory" : accessory}];
        }
    }];
}

@end
