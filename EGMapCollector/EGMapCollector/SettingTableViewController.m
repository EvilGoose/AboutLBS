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
@property (strong, nonatomic)NSArray *titles;

/**标题与选项映射 字典*/
@property (strong, nonatomic)NSDictionary *titlesMapDict;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能选择";
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.callBack) return;
    NSNumber *result = self.titlesMapDict[self.titles[indexPath.row]];
    self.callBack(result.integerValue);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}


- (NSArray<NSString *>*)titles {
    if (!_titles) {
        _titles = @[
                    @"定位",
                    @"测距",
                    @"方向检测",
                    @"区域检测",
                    @"地理编码",
                    @"反地理编码",
                    @"添加系统大头针",
                    @"添加自定义大头针",
                    @"添加系统覆盖",
                    @"添加自定义覆盖",
                    @"路线规划",
                    @"找餐厅"
                    ];
	}
    
    return _titles;
}

- (NSDictionary *)titlesMapDict {
    if (!_titlesMapDict) {
        _titlesMapDict = @{
                    @"定位":@(kUserSelectedLocation),
                    @"测距":@(kUserSelectedCaculateDistance),
                    @"方向检测":@(kUserSelectedGetDirection),
                    @"区域检测":@(kUserSelectedJudgeZone),
                    @"添加系统大头针":@(kUserSelectedAddAnnotation),
                    @"添加自定义大头针":@(kUserSelectedAddCustomAnnotation),
                    @"添加系统覆盖":@(kUserSelectedAddOverlay),
                    @"地理编码":@(kUserSelectedGeocoder),
                    @"反地理编码":@(kUserSelectedDegeocoder),
                    @"路线规划":@(kUserSelectedGuide),
                    @"添加自定义覆盖":@(kUserSelectedGradientLine),
                    @"找餐厅":@(kUserSelectedShowPOIS)
                    };
    }
    return _titlesMapDict;
}

@end
