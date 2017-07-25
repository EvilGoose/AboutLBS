//
//  SettingTableViewController.m
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.callBack) {
        self.callBack(UserSelectedAction1);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.textLabel.text = @"text";
    }
    return cell;
}


@end
