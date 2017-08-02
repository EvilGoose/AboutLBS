
    //
//  EGMapView.m
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "EGMapView.h"

@interface EGMapView ()

@end

@implementation EGMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setShowsUserLocation:YES];
     }
    return self;
}

#pragma mark - map view delegate

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}


@end
