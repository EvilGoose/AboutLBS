//
//  EGOverlayRenderer.m
//  EGMapCollector
//
//  Created by EG on 2017/8/3.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "EGOverlayRenderer.h"

@interface EGOverlayRenderer ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation EGOverlayRenderer

- (instancetype) initWithOverlay:(id<MKOverlay>)overlay{
    self = [super initWithOverlay:overlay];
    if (self){
        self.image = [UIImage imageNamed:@"MapHiddenBG.png"];
    }
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    @autoreleasepool {//CoreGraphics对象
        EGOverlay *overlay = (EGOverlay *)self.overlay;
        if (overlay == nil) return;
        
        
            // 绘制image
        CGContextMoveToPoint(context, 20, 100);
        CGContextAddLineToPoint(context, 100, 320);
        CGContextSetLineWidth(context, 12);
        [[UIColor brownColor]set];
        CGContextSetLineCap(context,kCGLineCapRound);
        CGContextStrokePath(context);
        
            //第二条线
        CGContextMoveToPoint(context, 40, 200);
        CGContextAddLineToPoint(context, 80, 100);
            //清空状态
        CGContextSetLineWidth(context, 1);[[UIColor blackColor]set];
        CGContextSetLineCap(context,kCGLineCapButt);
            //渲染
        CGContextStrokePath(context);
//			MKMapRect theMapRect = [self.overlay boundingMapRect];
//		  CGRect theRect = [self rectForMapRect:theMapRect];
//        CGImageRef imageReference = self.image.CGImage;
//        CGContextScaleCTM(context, 1.0, -1.0);
//        CGContextTranslateCTM(context, 0.0, -theRect.size.height);
//        CGContextDrawImage(context, theRect, imageReference);
    }
}

@end
