//
//  PDJudgeInFence.m
//  GDUMini
//
//  Created by EG on 2017/5/2.
//  Copyright © 2017年 ProFlight. All rights reserved.
//

#import "PDJudgeInFence.h"

@implementation PDJudgeInFence

int pnpoly (int nvert, double_t *vertx, double_t *verty, float testx, float testy) {
    int i, j, c = 0;
    
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
        if (((verty[i]>testy) != (verty[j]>testy)) && (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]))
            c = !c;
    }
    return c;
}

+ (BOOL)array:(NSArray<NSValue *> *)array containsPoint:(CGPoint)point {
    __block double max_X = 0;
    __block double max_Y = 0;
    __block double min_X = 0;
    __block double min_Y = 0;
    __block  CGPoint  anglePoint;
    
    NSMutableArray *valueArray_X = [NSMutableArray array];
    NSMutableArray *valueArray_Y = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        anglePoint = [obj pointValue];
        
        [valueArray_X addObject:@(anglePoint.x)];
        [valueArray_Y addObject:@(anglePoint.y)];
        
        if (anglePoint.x > max_X) {
            max_X = anglePoint.x;
        }
        
        if (anglePoint.x < min_X) {
            min_X = anglePoint.x;
        }
        
        if (anglePoint.y > max_Y) {
            max_Y = anglePoint.y;
        }
        
        if (anglePoint.y < min_Y) {
            min_Y = anglePoint.y;
        }
    }];
    
    if (point.x > max_X || point.y > max_Y || point.x < min_X || point.y < min_Y)  return NO;
    
    int count = (int)array.count;
    double_t array_x[count];
    double_t array_y[count];

    for (int i = 0; i < valueArray_X.count; i ++) {
        array_x[i] = [valueArray_X[i] doubleValue];
        array_y[i] = [valueArray_Y[i] doubleValue];
    }
    
    int result = pnpoly((int)array.count, array_x, array_y, point.x, point.y);

    if (result % 2 == 1) return YES;

    return NO;
}



@end
