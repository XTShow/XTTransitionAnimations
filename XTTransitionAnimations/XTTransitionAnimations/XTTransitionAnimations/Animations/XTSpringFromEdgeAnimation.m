//
//  XTSpringFromBottom.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "XTSpringFromEdgeAnimation.h"
#import "XTCommonValue.h"

//the damping ratio for the spring animation in presenting/pushing
#define XTPresentDampingRatio 0.5

//the damping ratio for the spring animation in dismissing/poping
#define XTDismissDampingRatio 0.4

//the duration of custom transition animation, in seconds
#define XTTransitionDuration 0.8

@interface XTSpringFromEdgeAnimation ()
@property (nonatomic,assign) XTTransitionType transitionType;
@property (nonatomic,assign) BOOL isInteract;
@property (nonatomic,assign) NSInteger aniType;
@end

@implementation XTSpringFromEdgeAnimation

-(instancetype)initWithConfig:(NSDictionary *)dic{

    self = [super init];
    if (self) {
        _transitionType = [dic[@"transitionType"] integerValue];
        _aniType = [dic[@"animatedType"] integerValue];
        _isInteract = [dic[@"interact"] boolValue];
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return XTTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
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

    [containerView addSubview:fromVC.view];
    CGRect toVCFinalFrame = [transitionContext finalFrameForViewController:toVC];
    switch (self.aniType) {
        case XTSpringFromBottom:
            toVC.view.frame = CGRectOffset(toVCFinalFrame, 0, toVCFinalFrame.size.height);
            break;
            
        case XTSpringFromLeft:
            toVC.view.frame = CGRectOffset(toVCFinalFrame, -toVCFinalFrame.size.width, 0);
            break;
            
        case XTSpringFromTop:
            toVC.view.frame = CGRectOffset(toVCFinalFrame, 0, -toVCFinalFrame.size.height);
            break;
            
        case XTSpringFromRight:
            toVC.view.frame = CGRectOffset(toVCFinalFrame, toVCFinalFrame.size.width, 0);
            break;
            
        default:
            break;
    }
    
    [containerView addSubview:toVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:XTPresentDampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.frame = toVCFinalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

-(void)dismissFor:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGRect fromVCInitFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect fromVCItemFrame = CGRectZero;
    switch (self.aniType) {
        case XTSpringFromBottom:
            fromVCItemFrame = CGRectOffset(fromVCInitFrame, 0, fromVCInitFrame.size.height);
            break;
            
        case XTSpringFromLeft:
            fromVCItemFrame = CGRectOffset(fromVCInitFrame, -fromVCInitFrame.size.width, 0);
            break;
            
        case XTSpringFromTop:
            fromVCItemFrame = CGRectOffset(fromVCInitFrame, 0, -fromVCInitFrame.size.height);
            break;
            
        case XTSpringFromRight:
            fromVCItemFrame = CGRectOffset(fromVCInitFrame, fromVCInitFrame.size.width, 0);
            break;
            
        default:
            break;
    }
    
    if (self.isInteract) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.view.frame = fromVCItemFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    }else{
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:XTDismissDampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromVC.view.frame = fromVCItemFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }

}

@end
