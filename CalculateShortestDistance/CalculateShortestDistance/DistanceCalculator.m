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
    
//    NSLog(@"Nearest point %@ %@", pointA, pointB);
    
    double result;
	result = distanceToSegDist(point.x, point.y,
                                pointA.pointValue.x, pointA.pointValue.y,
                                pointB.pointValue.x, pointB.pointValue.y);
    
    if (result == 0) {
            //钝角三角形
        Point c = {point.x, point.y};
        Point a = {pointA.pointValue.x, pointA.pointValue.y};
        Point b = {pointB.pointValue.x, pointB.pointValue.y};
        result = calculateDistanceFromLine(a, b, c);
    }
    
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
    return sqrt((x - px) * (x - px) + (py - y1) * (py - y1));
}

double calculateDistanceFromLine(Point p1,Point p2,Point q)
{
    int flag=1;
    double k;
    Point s;
    
    if(p1.v==p2.v)//与x轴垂直
      {
        
        s.h=p1.v;
        
        s.h=q.h;
        
        flag=0;
        
      }
    
    if(p1.h==p2.h)//与y轴垂直
      {
        
        s.v=q.v;
        
        s.h=p1.h;
        
        flag=0;
        
      }
    
    
    if(flag)
      {
        
        k=(p2.h-p1.h)/(p2.v-p1.v);//计算直线斜率
        
        s.v=(k*k*p1.v+k*(q.h-p1.h)+q.v)/(k*k+1);
        
        s.h=k*(s.v-p1.v)+p1.h;
        
      }
    
    if(MIN(p1.v,p2.v)<=s.v && s.v<=MAX(p1.v,p2.v))
        
        return sqrt((q.v-s.v)*(q.v-s.v)+(q.h-s.h)*(q.h-s.h));//两点间距离公式。垂线在线段之间
    
    else
        
        return MIN(sqrt((q.v-p1.v)*(q.v-p1.v)+(q.h-p1.h)*(q.h-p1.h)),sqrt((q.v-p2.v)*(q.v-p2.v)+(q.h-p2.h)*(q.h-p2.h)));
}

@end
