//
//  EGPOIAnnotation.h
//  EGMapCollector
//
//  Created by EG on 2017/8/5.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EGPOIAnnotation : NSObject<MKAnnotation>

/**原有属性*/
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

/**自定义属性*/
@property (nonatomic, assign)CGFloat distance;

+ (NSString *_Nullable)reusedID;

@end
