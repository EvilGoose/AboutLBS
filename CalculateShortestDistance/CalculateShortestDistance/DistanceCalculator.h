//
//  DistanceCalculator.h
//  CalculateShortestDistance
//
//  Created by EG on 2017/7/8.
//  Copyright © 2017年 EGMade. All rights reserved.
//	 计算点到多边形的距离

#import <Foundation/Foundation.h>

@interface DistanceCalculator : NSObject

+ (CGFloat)calculatePoint:(CGPoint)point distanceFrom:(NSArray<NSValue *> *)corners;

@end
