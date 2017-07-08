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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
            // insert code here...
        NSArray *array = @[
                           [NSValue valueWithPoint: CGPointMake(0, 10)],
                           [NSValue valueWithPoint: CGPointMake(0, 15)],
                           [NSValue valueWithPoint: CGPointMake(5, 20)],
                           [NSValue valueWithPoint: CGPointMake(15, 20)],
                           [NSValue valueWithPoint: CGPointMake(20, 15)],
                           [NSValue valueWithPoint: CGPointMake(20, 10)],
                           [NSValue valueWithPoint: CGPointMake(15, 5)],
                           [NSValue valueWithPoint: CGPointMake(5, 5)]
                           ];
        NSLog(@"result %f",  [DistanceCalculator calculatePoint:CGPointMake(5, 0) distanceFrom:array]);
        
     }
    return 0;
}
