//
//  CircleTransition.m
//  遮罩转场动画Demo
//
//  Created by M on 2017/7/10.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "CircleTransition.h"
#import "ViewController.h"
#import "SecondViewController.h"

@interface CircleTransition ()

@property (nonatomic,strong) id<UIViewControllerContextTransitioning> transitionContext;// 动画执行过程中的上下文

@end

@implementation CircleTransition

// 这个协议方法返回动画的执行时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .7f;
}

// CoreAnimation 的代码就是写在这里了
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    /*
     transitionContext 是动画执行过程中的上下文。通过 UIViewControllerContextTransitioning 你可以拿到执行动画的容器 containerView 。所有动画必须发生在这个容器上。除了可以拿到 containerView ，你还可以获取：
     UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
      
     UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
      
     UIView *fromView = [transitionContext UITransitionContextFromViewControllerKey];
      
     UIView *toView = [transitionContext UITransitionContextToViewControllerKey];”
     
     */
    self.transitionContext = transitionContext;
    
    ViewController *fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];// 获取进行push操作的视图控制器
    SecondViewController *toVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];// 获取被push出来的视图控制器
    UIView *containerView = [transitionContext containerView];
    UIButton *button = fromVC.button;
    
    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:button.frame];// bezierPathWithOvalInRect 用一个rect创建一个椭圆path的方法
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    // 创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行
    // 通过确定初始点所在的象限位置，从而确定终点位置，从而计算出半径 —— 也就是最小能覆盖整个界面的圆。
    CGPoint finalPoint;
    // 判断触发点在哪个象限.从而计算出覆盖的最大半径
    if (button.frame.origin.x > (toVC.view.bounds.size.width * .5)) {
        if (button.frame.origin.y < (toVC.view.bounds.size.height * .5)) {// 第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        } else {// 第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    } else {
        if (button.frame.origin.y < (toVC.view.bounds.size.height * .5)) {// 第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        } else {// 第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));// 半径 根据勾股定理计算
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;// 将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(maskFinalBP.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}


#pragma mark - CABasicAnimation的Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}














































@end
