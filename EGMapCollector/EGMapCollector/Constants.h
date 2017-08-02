//
//  Constants.h
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef enum : NSUInteger {
    kUserSelectedNone = 0,
    kUserSelectedLocation,
    kUserSelectedCaculateDistance,
    kUserSelectedGetDirection,
    kUserSelectedJudgeZone,
    kUserSelectedAddAnnotation,
    kUserSelectedAddCustomAnnotation,
    kUserSelectedAddOverlay,
    kUserSelectedGeocoder,
    kUserSelectedDegeocoder,
} UserSelectedAction;


#endif /* Constants_h */
