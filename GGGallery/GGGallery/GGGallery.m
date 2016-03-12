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
    CGFloat _bottomViewHeight;
    UIView *_bottomView;
    UILabel *_titleLabel;
    UIPageControl *_pageControl;
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
    CATransition *animation = [[CATransition alloc] init];
    animation.type = _animationType;
    animation.duration = 0.5;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        animation.subtype = kCATransitionFromRight;
        _currentPage = (_currentPage + 1) % _numberOfPage;
    } else {
        animation.subtype = kCATransitionFromLeft;
        _currentPage = (_currentPage - 1 + _numberOfPage) % _numberOfPage;
    }
    [self.layer addAnimation:animation forKey:nil];
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
        NSLog(@"%@", _pageControl);
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
        _bottomViewHeight = 40;
        _bottomView = [[UIView alloc] init];
        [self addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor blueColor];
//        _bottomView.alpha = 0.5;
        
        // 添加约束
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;  // ....这句真是重中之重
        NSDictionary *views = @{@"view":_bottomView};
        addConstraints(self, views, @"H:|[view]|");
        addConstraints(self, views, [NSString stringWithFormat:@"V:[view(%lf)]|", _bottomViewHeight]);
    }
}
- (void)addPageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        [_bottomView addSubview:_pageControl];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{@"view":_pageControl};
        addConstraints(_bottomView, views, @"H:[view]-|");
        addConstraints(_bottomView, views, @"V:|[view]|");
    }
}
- (void)addTitleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_bottomView addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{@"view":_titleLabel};
        addConstraints(_bottomView, views, @"H:|-30-[view]");
        addConstraints(_bottomView, views, @"V:|[view]|");
    }
}

void addConstraints(UIView *view, NSDictionary *views, NSString *format) {
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
}
@end
