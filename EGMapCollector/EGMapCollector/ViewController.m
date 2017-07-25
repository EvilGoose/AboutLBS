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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet EGMapView *mapView;

@end

@implementation ViewController

- (IBAction)optionsClick:(UIBarButtonItem *)sender {
    if ([sender isEqual:self.navigationItem.leftBarButtonItem]) {
         [self presentAlert];
        
    }else {
        [self.navigationController pushViewController:
         [SettingTableViewController new] animated:YES];
        
    }
}

- (void)presentAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"action1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
