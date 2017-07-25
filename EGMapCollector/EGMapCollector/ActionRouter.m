//
//  ActionRouter.m
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "ActionRouter.h"

@implementation ActionRouter

#pragma mark - initial
static ActionRouter *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)router {
    return [[self alloc]init];
}
    // 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
