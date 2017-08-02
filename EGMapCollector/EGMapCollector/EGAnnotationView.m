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
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self addSubview:self.topView];
        if ([self.delegate respondsToSelector:@selector(didSelectedAnnotationView:)]) {
            [self.delegate didSelectedAnnotationView:self];
        }
    }else {
        [self.topView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(didDeselectedAnnotationView:)]) {
            [self.delegate didDeselectedAnnotationView:self];
        }
    }

}

- (void)buttonClick {
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
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _topView.backgroundColor = [UIColor redColor];
        [_topView addSubview:self.titleLabel];
        [_topView addSubview:self.button];
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:4];
    }
    return _titleLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _button.center = CGPointMake(15, 20);
    }
    return _button;
}
@end
