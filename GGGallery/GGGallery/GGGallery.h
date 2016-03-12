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
@end

@protocol GGGalleryDataSource <NSObject>
- (NSInteger)numOfPage;
- (UIImage *)gallery:(GGGallery *)gallery imageAtPageIndex:(NSInteger)index;
- (NSString *)gallery:(GGGallery *)gallery titleAtPageIndex:(NSInteger)index;
@end

@protocol GGGalleryDelegate <NSObject>
- (void)gallery:(GGGallery *)gallery didSelectedPageAtIndex:(NSInteger)index;
@end