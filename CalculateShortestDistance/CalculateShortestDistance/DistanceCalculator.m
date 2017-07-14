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
