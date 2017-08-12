//
//  CLLocation+Transformation.m
//  EGMapCollector
//
//  Created by EG on 2017/8/12.
//  Copyright © 2017年 EGMade. All rights reserved.
// 	

#import "CLLocation+Transformation.h"

@implementation CLLocation (Transformation)

/**是否定位在中国大陆*/
+ (BOOL)locationInMainlandChina:(CLPlacemark *)placeMark {
    NSString *ocean = placeMark.addressDictionary[@"Ocean"];
    NSString *state = placeMark.addressDictionary[@"State"];

    NSArray *mainLand = @[@"北京市",@"天津市",@"上海市",@"重庆市",
                          @"Beijing",@"Tianjin",@"Shanghai",@"Chongqing",
                           
                          @"黑龙江省",@"吉林省",@"辽宁省",
                          @"Heilong Jiang",@"Jilin",@"Liaoning",
                          
                          @"陕西省",@"甘肃省",@"青海省",
                          @"Shanxi",@"Gansu",@"Qinghai",
                          
                          @"山东省",@"山西省",@"河北省",@"河南省",
                          @"Shandong",@"Shaanxi",@"Hebei",@"Henan",
                          
                          @"湖北省",@"湖南省",@"安徽省",@"江西省",
                          @"Hubei",@"Hunan",@"Anhui",@"Jiangxi",
                          
                          @"浙江省",@"江苏省",@"福建省",@"广东省",@"广西省",
                          @"Zhejiang",@"Jiangsu",@"Fujian",@"Guangdong",@"Guangxi",
                          
                          @"四川省",@"贵州省",@"云南省",@"海南省",
                          @"Sichuan",@"Guizhou",@"Yunnan",@"Hainan",
                          
                          @"内蒙古自治区",@"西藏自治区",@"新疆维吾尔自治区",@"宁夏回族自治区",
                          @"Nei Mongol",@"Xizang",@"Xinjiang",@"Ningxia",
                          
                          @"南海",@"东海",@"黄海",@"渤海",
                          @"South China Sea",@"East China Sea",@"Yellow Sea",@"Bohai Sea",
                          ];
    
    if (state && [mainLand containsObject:state]) {
        return YES;
    }else if (ocean && [mainLand containsObject:ocean]) {
        return YES;
    }else {
        return NO;
    }
}

/**从火星坐标系(GCJ-02) 到 大地坐标系(WGS-84) 的转换算法*/
- (CLLocation *)transformMarsToEarth{
 	return nil;
}

/**从大地坐标系(WGS-84) 到 火星坐标系(GCJ-02) 的转换算法 */
- (CLLocation *)transformEarthToMars{
	return nil;
}

/**从百度坐标系 (BD-09) 到 大地坐标系(WGS-84) 的转换算法*/
- (CLLocation *)transformBaiduToEarth{
	return nil;
}

/**从大地坐标系(WGS-84) 到 百度坐标系(BD-09) 的转换算法*/
- (CLLocation *)transformEarthToBaidu {
    return nil;
}

@end
