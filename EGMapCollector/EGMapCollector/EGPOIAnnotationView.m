//
//  EGPOIAnnotationView.m
//  EGMapCollector
//
//  Created by EG on 2017/8/5.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "EGPOIAnnotationView.h"
#import "EGPOIAnnotation.h"

@interface EGPOIAnnotationView()

/**top View*/
@property (strong, nonatomic)UIView *topView;

/**title Lable*/
@property (strong, nonatomic)UILabel *titleLabel;

/**sub Lable*/
@property (strong, nonatomic)UILabel *subLabel;

/**switch*/
@property (strong, nonatomic)UIButton *button;

@end

@implementation EGPOIAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.draggable = YES;
        self.image = [UIImage imageNamed:@"restaurant"];
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

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    self.titleLabel.text = annotation.title;
    self.subLabel.text = annotation.subtitle;
    self.POIAnnotation = annotation;
}

#pragma mark -  click

- (void)buttonClick {
    if ([self.delegate respondsToSelector:@selector(didClickedAnnotationViewPathConfigureButton:)]) {
        [self.delegate didClickedAnnotationViewPathConfigureButton:self];
    }
}

- (void)tapTopView {
    self.selected = YES;
}

#pragma mark - lazy

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(-60, -43, 120, 40)];
        _topView.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:self.titleLabel];
        [_topView addSubview:self.subLabel];
        [_topView addSubview:self.button];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopView)];
        [_topView addGestureRecognizer:tap];
        
        _topView.layer.cornerRadius = 5;
        _topView.layer.borderWidth = 1;
        _topView.layer.borderColor = [UIColor blackColor].CGColor;
        [_topView clipsToBounds];
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 75, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.userInteractionEnabled = YES;
     }
    return _titleLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 75, 10)];
        _subLabel.font = [UIFont systemFontOfSize:6];
        _subLabel.textColor = [UIColor blackColor];
        _subLabel.userInteractionEnabled = YES;
     }
    return _subLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor blueColor];
        [_button setTitle:@"到这去" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:10];
        _button.tintColor = [UIColor yellowColor];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        _button.frame = CGRectMake(75, 5, 40, 30);
        _button.layer.cornerRadius = 5;
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = [UIColor blackColor].CGColor;
        [_button clipsToBounds];
    }
    return _button;
}

@end
