//
//  EGOverlay.m
//  EGMapCollector
//
//  Created by EG on 2017/8/3.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "EGOverlay.h"

@interface EGOverlay ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) MKMapRect boundingMapRect;

@end

@implementation EGOverlay
@synthesize coordinate = _coordinate;
@synthesize boundingMapRect = _boundingMapRect;

#pragma mark - Initalize

- (instancetype)initWithRect:(MKMapRect)rect {
    if (self = [super init]) {
        self.boundingMapRect = rect;
      }
    return self;
}

@end
