//
//  CLLocation+Transformation.h
//  EGMapCollector
//
//  Created by EG on 2017/8/12.
//  Copyright © 2017年 EGMade. All rights reserved.
//	坐标转换

/*
 在地图上绘制大头针或者是通过一组坐标绘制路径时，
 使用的并不是WGS-84标准的大地坐标，而是做过转化的坐标，
 我们称这一类非真实位置的坐标为“火星坐标”(当)；
 但是作为数据在各处流动的时候，我们希望使用的是统一的标准
 */

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Transformation)

/**
 判断该地点是否在中国大陆
	
 @param placeMark 反地理编码得到的State信息
 @return 如果在大陆，返回YES，反之为NO
 */
+ (BOOL)locationInMainlandChina:(CLPlacemark *)placeMark;

/**从火星坐标系(GCJ-02) 到 大地坐标系(WGS-84) 的转换算法*/
- (CLLocation *)transformMarsToEarth;

/**从大地坐标系(WGS-84) 到 火星坐标系(GCJ-02) 的转换算法 */
- (CLLocation *)transformEarthToMars;

/**从百度坐标系 (BD-09) 到 大地坐标系(WGS-84) 的转换算法*/
- (CLLocation *)transformBaiduToEarth;

/**从大地坐标系(WGS-84) 到 百度坐标系(BD-09) 的转换算法*/
- (CLLocation *)transformEarthToBaidu;

@end
