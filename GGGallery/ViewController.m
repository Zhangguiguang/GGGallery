//
//  ViewController.m
//  GGGallery
//
//  Created by 张贵广 on 3/11/16.
//  Copyright © 2016 HZNU. All rights reserved.
//

#import "ViewController.h"
#import "GGGallery.h"

@interface ViewController () <GGGalleryDataSource, GGGalleryDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GGGallery *gallery = [[GGGallery alloc] init];
    [self.view addSubview:gallery];
    gallery.frame = CGRectMake(0, 20, self.view.frame.size.width, 280);
    gallery.dataSource = self;
    gallery.delegate = self;
    gallery.needPageControl = YES;
}

- (NSInteger)numberOfPageInGallery:(GGGallery *)gallery {
    return 3;
}

- (UIImage *)gallery:(GGGallery *)gallery imageAtPage:(NSInteger)page {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", page]];
}

- (NSString *)gallery:(GGGallery *)gallery titleAtPage:(NSInteger)page {
    return [NSString stringWithFormat:@"标题 %ld", page];
}

- (void)gallery:(GGGallery *)gallery didSelectedPage:(NSInteger)page {
    NSLog(@"%ld", page);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
