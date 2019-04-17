//
//  SMAccessoryViewController.m
//  SMAPP
//
//  Created by Sichen on 14/4/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import "SMAccessoryDetailViewController.h"
#import "SMServiceViewController.h"

@interface SMAccessoryDetailViewController ()

@end

@implementation SMAccessoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessory.name;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessory.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    HMService *service = self.accessory.services[indexPath.row];
    cell.textLabel.text = service.name;
    cell.detailTextLabel.text = service.localizedDescription;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMServiceViewController *viewController = [[SMServiceViewController alloc] init];
    viewController.service = self.accessory.services[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
