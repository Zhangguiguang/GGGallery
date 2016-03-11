//
//  ViewController.m
//  GGGallery
//
//  Created by 张贵广 on 3/11/16.
//  Copyright © 2016 HZNU. All rights reserved.
//

#import "ViewController.h"
#import "testClass.h"

@interface ViewController ()
@property (nonatomic, strong) testClass *test;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    int a = 3;
    int b = 4;
    _sum = a + b;
    NSLog(@"sum = %d", _sum);
    
    [self sayByeBye];
    [self sayHello];
}

- (void)sayByeBye {
    NSLog(@"ByeBye");
}
- (void)sayHello {
    NSLog(@"hello");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
