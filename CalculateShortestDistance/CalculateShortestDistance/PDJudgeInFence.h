//
//  PDJudgeInFence.h
//  GDUMini
//
//  Created by EG on 2017/5/2.
//  Copyright © 2017年 ProFlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDJudgeInFence : NSObject


/**
 判断一个点是够在某多边形内部

 @param array 多边形的各个叫对应的坐标
 @param point 改点
 @return 如果在为YES 反之为NO
 */
+ (BOOL)array:(NSArray <NSValue *>*)array containsPoint:(CGPoint)point;

@end
