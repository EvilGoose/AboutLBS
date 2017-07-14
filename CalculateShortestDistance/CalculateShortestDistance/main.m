//
//  main.m
//  CalculateShortestDistance
//
//  Created by EG on 2017/7/8.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>
#import "DistanceCalculator.h" 


    //计算某两点所在直线的平行线对应y轴交点
void parallel (double x1, double y1, double x2, double y2, double delta)
{

    double b =  delta / sin(atan2((y2 - y1), (x2 - x1)));
    
    printf("get b is %f %f", atan2((y2 - y1), (x2 - x1)), b);
    
        //    b2 = sqrt(pow(k, 2) * pow(delta, 2)  +pow(delta, 2)) + b1;
    Point parallelPoint0;
    Point parallelPoint1;
    parallelPoint0.v = x1 * 2 + b - x2;
    parallelPoint0.h = y1 * 2 - y2;

    parallelPoint1.v = x2 * 2 + b - x1;
    parallelPoint1.h = y2 * 2 - y1;
   
//    printf("%hd %hd ; %hd %hd \n",  parallelPoint0.v,  parallelPoint0.h,  parallelPoint1.v,  parallelPoint1.h);
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
            // insert code here...
        /*
        NSArray *array = @[
                           [NSValue valueWithPoint: CGPointMake(5, 5)],
                           [NSValue valueWithPoint: CGPointMake(0, 10)],
                           [NSValue valueWithPoint: CGPointMake(0, 15)],
                           [NSValue valueWithPoint: CGPointMake(5, 20)],
                           [NSValue valueWithPoint: CGPointMake(15, 20)],
                           [NSValue valueWithPoint: CGPointMake(20, 15)],
                           [NSValue valueWithPoint: CGPointMake(20, 10)],
                           [NSValue valueWithPoint: CGPointMake(15, 5)]
                           ];
		 NSLog(@"result %f",  [DistanceCalculator calculatePoint:CGPointMake(25 , 20) distanceFrom:array]);
        */
        
         parallel(5, 0, 0, 10, sqrt(5)/2);
        
     }
    return 0;
}
