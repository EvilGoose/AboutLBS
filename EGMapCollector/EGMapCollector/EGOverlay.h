//
//  EGOverlay.h
//  EGMapCollector
//
//  Created by EG on 2017/8/3.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EGOverlay : NSObject<MKOverlay>

//必须实现的属性
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;

- (instancetype)initWithRect:(MKMapRect)rect;

@end
