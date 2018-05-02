//
//  XTRoundExpandAnimation.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/8.
//  Copyright © 2018年 XTShow. All rights reserved.
//

//iOS11及以上，XTRoundExpandAnimation暂不支持可交互特性（layer动画内部不再支持进度控制）
//iOS11 and later, XTRoundExpandAnimation do not support interactive features temporarily（core of layer animation do not support control progress）
#import "XTRoundExpandAnimation.h"
#import "XTCommonValue.h"

//the damping ratio for the spring animation in presenting/pushing
#define XTPresentDampingRatio 0.5

//the damping ratio for the spring animation in dismissing/poping
#define XTDismissDampingRatio 0.4

//the duration of custom transition animation, in seconds
#define XTTransitionDuration 0.8

//timing function for transiton animation in presenting/pushing
#define XTPresentTimingFunction [CAMediaTimingFunction functionWithControlPoints:.9 :0.25 :.57 :.81]

//timing function for transiton animation in dismissing/poping
#define XTDismissTimingFunction [CAMediaTimingFunction functionWithControlPoints:.23 :1.12 :.68 :.92]

@interface XTRoundExpandAnimation ()
<
CAAnimationDelegate
>
@property (nonatomic,assign) XTTransitionType transitionType;
@property (nonatomic,strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic,assign) BOOL isInteract;

@end

@implementation XTRoundExpandAnimation

-(instancetype)initWithConfig:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        _transitionType = [dic[@"transitionType"] integerValue];
        _isInteract = [dic[@"interact"] boolValue];
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return XTTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
    switch (self.transitionType) {
            
        case XTPresent:
        case XTPush:
            [self presentFor:transitionContext];
            break;
            
        case XTDismiss:
        case XTPop:
            [self dismissFor:transitionContext];
            break;
            
        default:
            break;
    }
    
}

- (void)animationEnded:(BOOL) transitionCompleted{
    NSLog(@"%s",__func__);
}

#pragma mark - 动画实现

-(void)presentFor:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = toViewFinalFrame;
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithArcCenter:toVC.view.center radius:1 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pathAni = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAni.delegate = self;
    pathAni.timingFunction = XTPresentTimingFunction;
    pathAni.duration = [self transitionDuration:transitionContext];
    pathAni.removedOnCompletion = NO;
    pathAni.fillMode = kCAFillModeForwards;
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithArcCenter:toVC.view.center radius:sqrt(XTSwidth * XTSwidth + XTSHeight * XTSHeight)/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    pathAni.toValue = (__bridge id _Nullable)finalPath.CGPath;
    [maskLayer addAnimation:pathAni forKey:[NSString stringWithFormat:@"%@",self.class]];
}

-(void)dismissFor:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithArcCenter:fromVC.view.center radius:sqrt(XTSwidth * XTSwidth + XTSHeight * XTSHeight)/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    fromVC.view.layer.mask = maskLayer;

    CABasicAnimation *pathAni = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAni.delegate = self;
    if (!self.isInteract) {
        pathAni.timingFunction = XTDismissTimingFunction;
    }
    pathAni.duration = [self transitionDuration:transitionContext];
    pathAni.removedOnCompletion = NO;
    pathAni.fillMode = kCAFillModeForwards;

    UIBezierPath *finalPath = [UIBezierPath bezierPathWithArcCenter:fromVC.view.center radius:1 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    pathAni.toValue = (__bridge id _Nullable)finalPath.CGPath;
    [maskLayer addAnimation:pathAni forKey:[NSString stringWithFormat:@"%@",self.class]];

}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        BOOL completeResult;
        if (@available(iOS 11.0, *)) {
            completeResult = YES;//iOS11及以上，layer动画的进度无法控制，就会出现实际上进度未超过完成标志位，但动画同样执行完成，但最后转场动画是取消的，会闪回到开始动画前，体验不好，此处特殊处理下。
        }else{
            completeResult = ![self.transitionContext transitionWasCancelled];
        }
        [self.transitionContext completeTransition:completeResult];
        
        switch (self.transitionType) {
            case XTPresent:
            case XTPush:
                [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
                break;

            case XTDismiss:
            case XTPop:
                [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
                break;

            default:
                break;
        }
        
    }
}

@end
