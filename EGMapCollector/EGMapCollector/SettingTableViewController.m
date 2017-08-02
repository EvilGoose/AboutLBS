//
//  SettingTableViewController.m
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

/**标题*/
@property (strong, nonatomic)NSDictionary *titles;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor]; 
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.callBack) return;
    NSNumber *result = self.titles[self.titles.allKeys[indexPath.row]];
    self.callBack(result.integerValue);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titles.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.textLabel.text = self.titles.allKeys[indexPath.row];
    }
    return cell;
}

- (NSDictionary *)titles {
    if (!_titles) {
        _titles = @{
                    @"定位":@(kUserSelectedLocation),
                    @"测距":@(kUserSelectedCaculateDistance),
                    @"方向检测":@(kUserSelectedGetDirection),
                    @"区域检测":@(kUserSelectedJudgeZone),
                    @"添加系统大头针":@(kUserSelectedAddAnnotation),
                    @"添加自定义大头针":@(kUserSelectedAddCustomAnnotation),
                    @"添加覆盖":@(kUserSelectedAddOverlay),
                    @"地理编码":@(kUserSelectedGeocoder),
                    @"反地理编码":@(kUserSelectedDegeocoder)
                    };
    }
    return _titles;
}

@end
