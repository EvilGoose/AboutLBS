//
//  EGPOIAnnotationView.h
//  EGMapCollector
//
//  Created by EG on 2017/8/5.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import <MapKit/MapKit.h>

@class EGPOIAnnotationView;
@protocol EGPOIAnnotationViewDelegate <NSObject>

- (void)didClickedAnnotationViewPathConfigureButton:(EGPOIAnnotationView *)view;

@end

@interface EGPOIAnnotationView : MKAnnotationView


/**annotation*/
@property (weak, nonatomic)id<MKAnnotation> POIAnnotation;

/**delegate*/
@property (weak, nonatomic)id<EGPOIAnnotationViewDelegate> delegate;

@end
