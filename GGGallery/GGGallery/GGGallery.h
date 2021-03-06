//
//  GGGallery.h
//  GGGallery
//
//  Created by 张贵广 on 3/12/16.
//  Copyright © 2016 HZNU. All rights reserved.
//

/*
 画廊效果, 支持多种动画过渡
 */

#import <UIKit/UIKit.h>

@protocol GGGalleryDelegate;
@protocol GGGalleryDataSource;

@interface GGGallery : UIImageView
@property (nonatomic, assign) id<GGGalleryDelegate> delegate;
@property (nonatomic, assign) id<GGGalleryDataSource> dataSource;

/**
 动画效果, 默认push, 其他值可以设为: fade, movein, reveal, cube, oglFlip, suckEffect,
 rippleEffect, pageCurl, pageUnCurl, cameralIrisHollowOpen, cameraIrisHollowClose
 */
@property (nonatomic, strong) NSString *animationType;

@property (nonatomic, assign) BOOL needPageControl;

@end

#pragma mark ---------------协议和代理的定义---------------
@protocol GGGalleryDataSource <NSObject>
@required
- (NSInteger)numberOfPageInGallery:(GGGallery *)gallery;
- (UIImage *)gallery:(GGGallery *)gallery imageAtPage:(NSInteger)page;
@optional
- (NSString *)gallery:(GGGallery *)gallery titleAtPage:(NSInteger)page;
@end

@protocol GGGalleryDelegate <NSObject>
- (void)gallery:(GGGallery *)gallery didSelectedPage:(NSInteger)page;
@end