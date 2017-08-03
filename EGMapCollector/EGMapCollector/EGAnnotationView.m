//
//  EGAnnotationView.m
//  EGMapCollector
//
//  Created by EG on 2017/8/2.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "EGAnnotationView.h"

@interface EGAnnotationView ()

/**top View*/
@property (strong, nonatomic)UIView *topView;

/**title Lable*/
@property (strong, nonatomic)UILabel *titleLabel;

/**switch*/
@property (strong, nonatomic)UIButton *button;

@end

@implementation EGAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.draggable = YES;
        self.image = [UIImage imageNamed:@"fence"];
        [self addSubview:self.topView];
    }
    return self;
}

    //处理按钮点击不到
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        CGPoint stationPoint = [self.button convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.button.bounds, stationPoint)) {
              view = self.button;
          }
     }
    
    return view;
}

    //未调用
- (void)setDragState:(MKAnnotationViewDragState)dragState {
    [super setDragState:dragState];
}

    //调用
- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated {
    [super setDragState:newDragState animated:animated];
    switch (newDragState) {
        case MKAnnotationViewDragStateNone:
            NSLog(@"MKAnnotationViewDragStateNone");
            break;
            
        case MKAnnotationViewDragStateStarting:
            self.image = [UIImage imageNamed:@"fence_start"];
            NSLog(@"MKAnnotationViewDragStateStarting");
            break;
            
        case MKAnnotationViewDragStateDragging:
            self.image = [UIImage imageNamed:@"fence_dragging"];
            NSLog(@"MKAnnotationViewDragStateDragging");
            break;
            
        case MKAnnotationViewDragStateCanceling:
            NSLog(@"MKAnnotationViewDragStateCanceling");
            break;
            
        case MKAnnotationViewDragStateEnding:
            self.image = [UIImage imageNamed:@"fence_end"];
            NSLog(@"MKAnnotationViewDragStateEnding");
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.image = [UIImage imageNamed:@"fence_selected"];
        if ([self.delegate respondsToSelector:@selector(didSelectedAnnotationView:)]) {
            [self.delegate didSelectedAnnotationView:self];
        }
    }else {
        self.image = [UIImage imageNamed:@"fence"];
        if ([self.delegate respondsToSelector:@selector(didDeselectedAnnotationView:)]) {
            [self.delegate didDeselectedAnnotationView:self];
        }
    }

}

- (void)buttonClick {
    self.dragState = MKAnnotationViewDragStateNone;

    if ([self.delegate respondsToSelector:@selector(didClickedAnnotationViewButton:)]) {
        [self.delegate didClickedAnnotationViewButton:self];
    }
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    self.titleLabel.text = annotation.title;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(-4, -30, 28, 30)];
        _topView.backgroundColor = [UIColor redColor];
        [_topView addSubview:self.titleLabel];
        [_topView addSubview:self.button];
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 10)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:4];
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _button.tintColor = [UIColor yellowColor];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _button.center = CGPointMake(15, 18);
    }
    return _button;
}
@end
