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
    
    gallery.animationType = @"push";
    gallery.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    gallery.dataSource = self;
    gallery.delegate = self;
}

- (NSInteger)numberOfPageInGallery:(GGGallery *)gallery {
    return 6;
}

- (UIImage *)gallery:(GGGallery *)gallery imageAtPageIndex:(NSInteger)index {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", index]];
}

- (void)gallery:(GGGallery *)gallery didSelectedPageAtIndex:(NSInteger)index {
    NSLog(@"%ld", index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
