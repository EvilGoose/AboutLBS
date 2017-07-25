//
//  ViewController.m
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "ViewController.h"

#import "EGMapView.h"
#import "SettingTableViewController.h"
#import "ActionRouter.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet EGMapView *mapView;

/**add annotation mark*/
@property (assign, nonatomic)BOOL addMark;

@end

@implementation ViewController

- (IBAction)optionsClick:(UIBarButtonItem *)sender {
    if ([sender isEqual:self.navigationItem.leftBarButtonItem]) {
         [self presentAlert];
        
    }else {
        SettingTableViewController *settingController = [SettingTableViewController new];
        [self.navigationController pushViewController:settingController animated:YES];

        settingController.callBack = ^(UserSelectedAction action) {
            
        };        
    }
}

- (void)presentAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"功能选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
