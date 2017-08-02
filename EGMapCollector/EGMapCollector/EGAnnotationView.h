//
//  EGAnnotationView.h
//  EGMapCollector
//
//  Created by EG on 2017/8/2.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import <MapKit/MapKit.h>

@class EGAnnotationView;
@protocol EGAnnotationViewDelegate <NSObject>

- (void)didSelectedAnnotationView:(EGAnnotationView *)view;

- (void)didDeselectedAnnotationView:(EGAnnotationView *)view;

- (void)didClickedAnnotationViewButton:(EGAnnotationView *)view;

@end

@interface EGAnnotationView : MKAnnotationView


/**delegate*/
@property (weak, nonatomic)id<EGAnnotationViewDelegate> delegate;

@end
