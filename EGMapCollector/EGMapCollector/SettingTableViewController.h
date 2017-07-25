//
//  SettingTableViewController.h
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

typedef void(^callBack)(UserSelectedAction action);

@interface SettingTableViewController : UITableViewController

/**反馈*/
@property (copy, nonatomic)callBack callBack;

@end
