//
//  ParallelCaculator.m
//  CalculateShortestDistance
//
//  Created by EG on 2017/7/12.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "ParallelCaculator.h"

@implementation ParallelCaculator

typedef struct line{
    Point point1;
    Point point2;
}line;


    //计算某两点所在直线的平行线对应y轴交点
double parallel111 (double x1, double y1, double x2, double y2, double delta)
{
     double b =  delta / sin(atan2((y2 - y1), (x2 - x1)));
//    b2 = sqrt(pow(k, 2) * pow(delta, 2)  +pow(delta, 2)) + b1;

    return b;
}


    //计算两条直线的交点
Point getCross(line line1, line line2)
{
    Point CrossP;
        //y = a * x + b;
    int a1 = (line1.point1.h - line1.point2.h) / (line1.point1.v - line1.point2.v);
    int b1 = line1.point1.h - a1 * (line1.point1.v);
    
    int a2 = (line2.point1.h - line2.point2.h) / (line2.point1.v - line2.point2.v);
    int b2 = line2.point1.h - a1 * (line2.point1.v);
    
    CrossP.v = (b1 - b2) / (a2 - a1);
    CrossP.h = a1 * CrossP.v + b1;
    
    return CrossP;
}

@end
