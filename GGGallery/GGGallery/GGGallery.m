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
    NSInteger _currentPage;
    NSInteger _numberOfPage;
    UIView *_bottomView;
    UILabel *_titleLabel;
    UIPageControl *_pageControl;
    CATransition *_animation;
}

#pragma mark ---------------初始化---------------
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
        
        _animation = [[CATransition alloc] init];
        _animation.duration = 0.5;
        _animation.speed = 0.3;
    }
    return self;
}

#pragma mark -----------设置了dataSource-----------
- (void)setDataSource:(id<GGGalleryDataSource>)dataSource {
    _dataSource = dataSource;
    if ([_dataSource respondsToSelector:@selector(numberOfPageInGallery:)]) {
        _numberOfPage = [_dataSource numberOfPageInGallery:self];
        if (_numberOfPage >= 1) { // 初始化第一页
            if ([_dataSource respondsToSelector:@selector(gallery:titleAtPage:)]) {
                [self addBottomView];
                [self addTitleLabel];
            }
            [self showDataAtPage:0];
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
    _animation.type = _animationType;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        _animation.subtype = kCATransitionFromRight;
        _currentPage = (_currentPage + 1) % _numberOfPage;
    } else {
        _animation.subtype = kCATransitionFromLeft;
        _currentPage = (_currentPage - 1 + _numberOfPage) % _numberOfPage;
    }
    [self.layer addAnimation:_animation forKey:nil];
    [self showDataAtPage:_currentPage];
}
- (void)showDataAtPage:(NSInteger)page {
    // 图片是必须显示的
    self.image = [_dataSource gallery:self imageAtPage:page];
    
    if ([_dataSource respondsToSelector:@selector(gallery:titleAtPage:)]) {
        _titleLabel.text = [_dataSource gallery:self titleAtPage:page];
    }
    if (_needPageControl) {
        _pageControl.currentPage = page;
    }
}


#pragma mark -----------设置了delegate-----------
- (void)setDelegate:(id<GGGalleryDelegate>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(gallery:didSelectedPage:)]) {
        // 添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [self addGestureRecognizer:tapGesture];
    }
}
- (void)clickImage {
    [_delegate gallery:self didSelectedPage:_currentPage];
}

#pragma mark ---------------设置了needPageControl---------------
- (void)setNeedPageControl:(BOOL)needPageControl {
    _needPageControl = needPageControl;
    if (needPageControl) {
        [self addBottomView];
        [self addPageControl];
        _pageControl.numberOfPages = _numberOfPage;
    } else {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
}

#pragma mark ---------------添加视图的方法---------------
- (void)addBottomView {
    if (_bottomView == nil) {
        CGFloat viewHeight = 40;
        _bottomView = [[UIView alloc] init];
        [self addSubview:_bottomView];
        
        // 添加约束
        addConstraints(self, _bottomView, @"H:|[view]|");
        addConstraints(self, _bottomView, [NSString stringWithFormat:@"V:[view(%lf)]|", viewHeight]);
        // 添加渐变背景
        CAGradientLayer *layer = [[CAGradientLayer alloc] init];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, viewHeight);
        [_bottomView.layer addSublayer:layer];
        layer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor blackColor].CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1);
    }
}
- (void)addPageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        [_bottomView addSubview:_pageControl];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        addConstraints(_bottomView, _pageControl, @"H:[view]-20-|");
        addConstraints(_bottomView, _pageControl, @"V:|[view]|");
    }
}
- (void)addTitleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_bottomView addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor whiteColor];
        addConstraints(_bottomView, _titleLabel, @"H:|-30-[view]");
        addConstraints(_bottomView, _titleLabel, @"V:|[view]|");
    }
}
// 简化添加约束的方法，传入父视图，子视图，以及约束语句VFL
void addConstraints(UIView *view, UIView *subView, NSString *format) {
    subView.translatesAutoresizingMaskIntoConstraints = NO;  // ....这句真是重中之重
    NSDictionary *views = @{@"view" : subView};
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
}

@end
