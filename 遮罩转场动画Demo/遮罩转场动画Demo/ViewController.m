//
//  ViewController.m
//  遮罩转场动画Demo
//
//  Created by M on 2017/7/10.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "CircleTransition.h"

@interface ViewController ()<UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;// 代理需要在这里设置  保证代理设置在当前显示的视图控制器上
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor redColor];
    self.button.frame = CGRectMake(self.view.frame.size.width - 45, 27, 30, 30);
    [self.view addSubview:self.button];
    
    [self.button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)push {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        CircleTransition *circle = [CircleTransition new];
        return circle;
    } else {
        return nil;
    }
}


@end
