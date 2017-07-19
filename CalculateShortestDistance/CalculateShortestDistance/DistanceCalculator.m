//
//  DistanceCalculator.m
//  CalculateShortestDistance
//
//  Created by EG on 2017/7/8.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "DistanceCalculator.h"
#import "PDJudgeInFence.h"

@implementation DistanceCalculator

/*
 ↑        ___________ M
 |       ∕                     ∖   *(b)
 |     ∕                          ∖
 |   ∕       *(a)                  ∖ N
 |   ∖                               ∕
 |    	 ∖                           ∕
 |         ∖____________∕
 |⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯→
 
 对于a点，仅计算其到各边的最短距离;⏐
 对于b点，需要通过遍历，获取到离其最近的两个点：M，N，计算b到线段MN的最短距离
 */
+ (CGFloat)calculatePoint:(CGPoint)point distanceFrom:(NSArray<NSValue *> *)corners {
    double distance;
    double minDistance0 = -1;
    double minDistance1 = -1;
    
    CGPoint corner;
    
    NSValue *pointA;
    NSValue *pointB;
    
    for (NSValue *value in corners) {
        corner = [value pointValue];
        
        distance = getDistance(point.x, point.y, corner.x, corner.y);
        NSLog(@"distance %f", distance);
        
        if (minDistance0 == -1) {
            minDistance0 = distance;
            pointA = value;
         }
        
        if (minDistance1 == -1) {
            minDistance1 = distance;
         }

        if (minDistance0 >= distance) {
            minDistance1 = minDistance0;
            pointB = pointA;
            
            minDistance0 = distance;
            pointA = value;
        }
    }
    
    double result;
	result = distanceToSegDist(point.x, point.y,
                                pointA.pointValue.x, pointA.pointValue.y,
                                pointB.pointValue.x, pointB.pointValue.y);
    
    if ([PDJudgeInFence array:corners containsPoint:point]) {
        return - result;
    }else {
        return result;
    }
}

+ (CGFloat)calculateInsidePoint:(CGPoint)point shortestDistanceFrom:(NSArray<NSValue *> *)corners {
    double distance;
    CGFloat minDistance = -1;
    NSValue *pointA;
    NSValue *pointB;
    
        //    for (NSValue *obj in corners) {
        //        corner = [obj CGPointValue];
        //        distance = getDistance(point.x, point.y, corner.x, corner.y);
        //        if (minDistance == -1) {
        //            minDistance = distance;
        //        }
        //        minDistance = minDistance < distance ? minDistance : distance;
        //    }
    
    for (int i = 0; i < corners.count; i ++) {
        pointA = corners[i];
        if ((i + 1) == corners.count) {
            pointB = corners.firstObject;
        }else {
            pointB = corners[i + 1];
        }
        
        distance = distanceToSegDist(point.x, point.y,
                                     pointA.pointValue.x, pointA.pointValue.y,
                                     pointB.pointValue.x, pointB.pointValue.y);
        
        if (minDistance == -1) {
            minDistance = distance;
        }
        minDistance = minDistance < distance ? minDistance : distance;
        i ++;
    }
    
    return minDistance;
}

    //计算两点间距离
double getDistance( double x1, double y1, double x2, double y2 )
{
    return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
}

    //点到线段的距离
double distanceToSegDist(double x, double y, double x1, double y1, double x2, double y2)
{
    double cross = (x2 - x1) * (x - x1) + (y2 - y1) * (y - y1);
	if (cross <= 0) return sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));
    
    double d2 = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
    if (cross >= d2) return sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));
    
    double r = cross / d2;
    double px = x1 + (x2 - x1) * r;
    double py = y1 + (y2 - y1) * r;
    return sqrt((x - px) * (x - px) + (y - py) * (y - py));
 }

@end
