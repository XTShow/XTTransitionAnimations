//
//  XTCubeAnimation.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/16.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "XTCubeAnimation.h"
#import "XTCommonValue.h"

//the duration of custom transition animation, in seconds
#define XTTransitionDuration 0.8

//the m34 of view rotate transform
#define XTTransitionM34 1.0/(fromViewInitFrame.size.width * 700/414)

@interface XTCubeAnimation ()

@property (nonatomic,assign) XTTransitionType transitionType;
@property (nonatomic,assign) BOOL isInteract;

@end

@implementation XTCubeAnimation
- (instancetype)initWithConfig:(NSDictionary *)dic{
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
    [self animationFor:transitionContext];   
}

#pragma mark - 辅助方法
-(void)animationFor:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect fromViewInitFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    
    CATransform3D baseViewTrans = CATransform3DIdentity;
    baseViewTrans.m34 = XTTransitionM34;
    
    CGRect toViewInitFrame;
    CGPoint fromViewAnchorPoint;
    CGPoint toViewAnchorPoint;
    CGPoint fromViewInitPosition;
    CGPoint toViewInitPosition;
    CATransform3D toViewInitTrans;
    CATransform3D fromViewFinalTrans;
    CATransform3D toViewFinalTrans;
    CGPoint fromViewFinalPosition;
    CGPoint toViewFinalPosition;

    switch (self.transitionType) {
        case XTPush:{
            toViewInitFrame = CGRectOffset(fromViewInitFrame, fromViewInitFrame.size.width, 0);
            fromViewAnchorPoint = CGPointMake(1, 0.5);
            toViewAnchorPoint = CGPointMake(0, 0.5);
            fromViewInitPosition = CGPointMake(fromViewInitFrame.size.width, fromViewInitFrame.size.height/2 + fromViewInitFrame.origin.y);
            toViewInitPosition = CGPointMake(fromViewInitPosition.x, toViewFinalFrame.size.height/2 + toViewFinalFrame.origin.y);
            toViewInitTrans = CATransform3DRotate(baseViewTrans, -M_PI_2, 0, 1, 0);
            fromViewFinalTrans = CATransform3DRotate(baseViewTrans, M_PI_2, 0, 1, 0);
            toViewFinalTrans = CATransform3DRotate(baseViewTrans, 0, 0, 1, 0);
            fromViewFinalPosition = CGPointMake(0, fromViewInitPosition.y);
            toViewFinalPosition = CGPointMake(0, toViewInitPosition.y);
        }
            break;
          
        case XTPop:{
            toViewInitFrame = CGRectOffset(fromViewInitFrame, -fromViewInitFrame.size.width, 0);
            fromViewAnchorPoint = CGPointMake(0, 0.5);
            toViewAnchorPoint = CGPointMake(1, 0.5);
            fromViewInitPosition = CGPointMake(0, fromViewInitFrame.size.height/2 + fromViewInitFrame.origin.y);
            toViewInitPosition = CGPointMake(0, toViewFinalFrame.size.height/2 + toViewFinalFrame.origin.y);
            toViewInitTrans = CATransform3DRotate(baseViewTrans, M_PI_2, 0, 1, 0);
            fromViewFinalTrans = CATransform3DRotate(baseViewTrans, -M_PI_2, 0, 1, 0);
            toViewFinalTrans = CATransform3DRotate(baseViewTrans, 0, 0, 1, 0);
            fromViewFinalPosition = CGPointMake(fromViewInitFrame.size.width, fromViewInitPosition.y);
            toViewFinalPosition = CGPointMake(toViewFinalFrame.size.width, toViewInitPosition.y);
        }
            break;
            
        case XTPresent:{
            toViewInitFrame = CGRectOffset(fromViewInitFrame, 0, -toViewFinalFrame.size.height);
            fromViewAnchorPoint = CGPointMake(0.5, 0);
            toViewAnchorPoint = CGPointMake(0.5, 1);
            fromViewInitPosition = CGPointMake(fromViewInitFrame.size.width/2, 0);
            toViewInitPosition = CGPointMake(toViewFinalFrame.size.width/2, 0);
            toViewInitTrans = CATransform3DRotate(baseViewTrans, -M_PI_2, 1, 0, 0);
            fromViewFinalTrans = CATransform3DRotate(baseViewTrans, M_PI_2, 1, 0, 0);
            toViewFinalTrans = CATransform3DRotate(baseViewTrans, 0, 1, 0, 0);
            fromViewFinalPosition = CGPointMake(fromViewInitFrame.size.width/2, fromViewInitFrame.size.height);
            toViewFinalPosition = CGPointMake(toViewFinalFrame.size.width/2, toViewFinalFrame.size.height);
        }
           break;
            
        case XTDismiss:{
            toViewInitFrame = CGRectOffset(fromViewInitFrame, 0, fromViewInitFrame.size.height);
            fromViewAnchorPoint = CGPointMake(0.5, 1);
            toViewAnchorPoint = CGPointMake(0.5, 0);
            fromViewInitPosition = CGPointMake(fromViewInitFrame.size.width/2, fromViewInitFrame.size.height);
            toViewInitPosition = CGPointMake(toViewFinalFrame.size.width/2, toViewFinalFrame.size.height);
            toViewInitTrans = CATransform3DRotate(baseViewTrans, M_PI_2, 1, 0, 0);
            fromViewFinalTrans = CATransform3DRotate(baseViewTrans, -M_PI_2, 1, 0, 0);
            toViewFinalTrans = CATransform3DRotate(baseViewTrans, 0, 1, 0, 0);
            fromViewFinalPosition = CGPointMake(fromViewInitFrame.size.width/2, 0);
            toViewFinalPosition = CGPointMake(toViewFinalFrame.size.width/2, 0);
        }
            break;
            
        default:
            break;
    }
    
    fromView.frame = fromViewInitFrame;
    [containerView addSubview:fromView];
    
    toView.frame = toViewFinalFrame;
    [containerView addSubview:toView];
    
    fromView.layer.anchorPoint = fromViewAnchorPoint;
    toView.layer.anchorPoint = toViewAnchorPoint;
    
    fromView.layer.position = fromViewInitPosition;
    toView.layer.position = toViewInitPosition;
    
    toView.layer.transform = toViewInitTrans;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.layer.transform = fromViewFinalTrans;
        
        toView.layer.transform = toViewFinalTrans;
        
        fromView.layer.position = fromViewFinalPosition;
        
        toView.layer.position = toViewFinalPosition;

    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
            toVC.view.layer.position = CGPointMake(toViewFinalFrame.size.width/2, toViewFinalFrame.size.height/2 + toViewFinalFrame.origin.y);
            fromVC.view.layer.transform = CATransform3DIdentity;//完成转场后，要把fromVC的transform也还原，不然跨vc pop时，会出现该vc仍处于形变状态的情况
            toVC.view.layer.transform = CATransform3DIdentity;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}
@end
