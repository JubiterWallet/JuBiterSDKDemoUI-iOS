//
//  JUBNavigationController.m
//  JuBiterSDKUI
//
//  Created by zhangchuan on 2020/8/21.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import "JUBNavigationController.h"

@interface JUBNavigationController ()

@end

@implementation JUBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

////导航控制器里面
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//
//    NSLog(@"自定义pushViewController被调用");
//
//    if ([NSThread isMainThread]) {
//        NSLog(@"自定义pushViewController被调用--主线程");
//    } else {
//        NSLog(@"自定义pushViewController被调用--子线程");
//    }
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [super pushViewController:viewController animated:YES];
//    });
//
//}

@end
