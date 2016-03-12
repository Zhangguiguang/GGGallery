//
//  GGGallery.m
//  GGGallery
//
//  Created by 张贵广 on 3/12/16.
//  Copyright © 2016 HZNU. All rights reserved.
//

#import "GGGallery.h"

@implementation GGGallery
{
    NSInteger _currentIndex;
    NSInteger _numberOfPage;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        _animationType = @"push";
    }
    return self;
}

#pragma mark -----------设置了数据源-----------
- (void)setDataSource:(id<GGGalleryDataSource>)dataSource {
    _dataSource = dataSource;
    if ([_dataSource respondsToSelector:@selector(numberOfPageInGallery:)]) {
        _numberOfPage = [_dataSource numberOfPageInGallery:self];
        if (_numberOfPage >= 1) { // 设置初始化图片
            self.image = [_dataSource gallery:self imageAtPageIndex:0];
        }
        if (_numberOfPage >= 2) { // 当有两张以上的图片时, 才能左右滑动
            UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
            leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            [self addGestureRecognizer:leftSwipeGesture];
            UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
            rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
            [self addGestureRecognizer:rightSwipeGesture];
        }
    }
}
- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture {
    CATransition *animation = [[CATransition alloc] init];
    animation.type = _animationType;
    animation.duration = 1;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        animation.subtype = kCATransitionFromRight;
        _currentIndex = (_currentIndex + 1) % _numberOfPage;
    } else {
        animation.subtype = kCATransitionFromLeft;
        _currentIndex = (_currentIndex - 1 + _numberOfPage) % _numberOfPage;
    }
    
    [self.layer addAnimation:animation forKey:@""];
    self.image = [_dataSource gallery:self imageAtPageIndex:_currentIndex];
}

#pragma mark -----------设置了代理-----------
- (void)setDelegate:(id<GGGalleryDelegate>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(gallery:didSelectedPageAtIndex:)]) {
        // 添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [self addGestureRecognizer:tapGesture];
    }
}
- (void)clickImage {
    [_delegate gallery:self didSelectedPageAtIndex:_currentIndex];
}

@end
