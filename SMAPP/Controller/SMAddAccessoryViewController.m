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

@interface SMAddAccessoryViewController () <HMAccessoryBrowserDelegate>

@property (nonatomic, strong) HMAccessoryBrowser *accessoryBrowser;
@property (nonatomic, strong) NSMutableArray *accessoryArray;

@end

@implementation SMAddAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add";
    
//    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemPressed:)];
//    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
    
    [self.accessoryBrowser startSearchingForNewAccessories];
}

//- (void)doneItemPressed:(id)sender {
//    [self.accessoryBrowser stopSearchingForNewAccessories];
//    [self dismissViewControllerAnimated:YES completion:self.didAddAccessory];
//}

- (NSMutableArray *)accessoryArray {
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    
    return _accessoryArray;
}

#pragma mark - HMAccessoryBrowserDelegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    [self.accessoryArray addObject:accessory];
    [self.tableView reloadData];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    [self.accessoryArray removeObject:accessory];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    HMAccessory *accessory = self.accessoryArray[indexPath.row];
    cell.textLabel.text = accessory.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMAccessory *accessory = [self.accessoryArray objectAtIndex:indexPath.row];
    
    [[HMHomeManager sharedManager].primaryHome addAccessory:accessory completionHandler:^(NSError *error) {
        
        if (error) {
            NSLog(@"error in adding accessory: %@", error);
        } else {
            NSLog(@"add accessory success");
            [tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateAccessory object:nil];
        }
    }];
}

@end
