//
//  XTCardPresentAnimation.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "XTCardPresentAnimation.h"
#import "XTCommonValue.h"

//the damping ratio for the spring animation in presenting/pushing
#define XTPresentDampingRatio 0.5

//the damping ratio for the spring animation in dismissing/poping
#define XTDismissDampingRatio 0.4

//the duration of custom transition animation, in seconds
#define XTTransitionDuration 0.8

//ratio of the distance from top of card view to top of screen to the height of screen
#define XTCardMargin 1/10.0

@interface XTCardPresentAnimation ()
@property (nonatomic,assign) XTTransitionType transitionType;
@property (nonatomic,assign) BOOL isInteract;
@property (nonatomic,strong) UIView *visualEffectViewBgView;

@end

@implementation XTCardPresentAnimation

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
    //黑色模糊蒙层
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = containerView.frame;
    
    UIView *visualEffectViewBgView = [[UIView alloc] initWithFrame:containerView.frame];
    self.visualEffectViewBgView = visualEffectViewBgView;
    [visualEffectViewBgView addSubview:effectView];
    visualEffectViewBgView.alpha = 0;
    [containerView addSubview:visualEffectViewBgView];

    CGRect toVCFinalFrame = CGRectMake(0, XTSHeight * XTCardMargin, XTSwidth, XTSHeight * (1-XTCardMargin));
    toVC.view.frame = CGRectOffset(toVCFinalFrame, 0, toVCFinalFrame.size.height);
    [containerView addSubview:toVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:XTPresentDampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.frame = toVCFinalFrame;
        visualEffectViewBgView.alpha = 0.8;
        fromVC.view.transform = CGAffineTransformScale(fromVC.view.transform, 0.92, 0.92);
        
        fromVC.view.layer.masksToBounds = YES;
        fromVC.view.layer.cornerRadius = 5;
        
        toVC.view.layer.masksToBounds = YES;
        toVC.view.layer.cornerRadius = 5;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

-(void)dismissFor:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = containerView.frame;
    
    UIView *visualEffectViewBgView = [[UIView alloc] initWithFrame:containerView.frame];
    self.visualEffectViewBgView = visualEffectViewBgView;
    [visualEffectViewBgView addSubview:effectView];
    visualEffectViewBgView.alpha = 0.8;
    [containerView addSubview:visualEffectViewBgView];

    [containerView addSubview:fromVC.view];
    
    CGRect fromVCInitFrame = [transitionContext initialFrameForViewController:fromVC];

    if (self.isInteract) {
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.view.frame = CGRectOffset(fromVCInitFrame, 0, fromVCInitFrame.size.height);
            
            self.visualEffectViewBgView.alpha = 0;
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {//此处标识的是动画是否完成，与转场是否完成无关
            [self animationCompleteFor:transitionContext];
        }];

    }else{
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:XTDismissDampingRatio initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromVC.view.frame = CGRectOffset(fromVCInitFrame, 0, fromVCInitFrame.size.height);
            
            self.visualEffectViewBgView.alpha = 0;
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self animationCompleteFor:transitionContext];
        }];
        
    }

}

#pragma mark - 辅助方法
- (void)animationCompleteFor:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!transitionContext.transitionWasCancelled) {
        [self.visualEffectViewBgView removeFromSuperview];
        toVC.view.layer.masksToBounds = NO;
        toVC.view.layer.cornerRadius = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:toVC.view];
    }
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}
@end
