//
//  CardPresentationController.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/11.
//  Copyright © 2018年 XTShow. All rights reserved.
//


/**
 UIPresentationController可以理解成iOS8.0之后对原有的animationControllerForPresentedController和animationControllerForDismissedController方法的简易版封装；由原有的两个方法整个到一个代理方法中，因此返回一个服从xx协议的对象就可以，因此对转场动画的处理，在一个对象中就能完成。
 UIPresentationController可以独立完成转场动画的处理，而不需要依附于服从UIViewControllerAnimatedTransitioning协议的动画对象。
 但是UIPresentationController无法完成交互式的动画；如果想实现交互式转场动画，就需要与动画对象一同使用：此时注意containerView上view的添加，因为动画对象中和此处的containerView是一个，两者间要各司其职，避免重复添加或处理
 */
#import "XTCardPresentationController.h"
#import "XTCommonValue.h"

#define XTCardViewCornerRadius 5

@interface XTCardPresentationController ()
@property (nonatomic,strong) UIView *visualEffectViewBgView;

@end

@implementation XTCardPresentationController

#pragma mark - 过程监听
- (void)presentationTransitionWillBegin{
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = self.containerView.frame;
    
    UIView *visualEffectViewBgView = [[UIView alloc] initWithFrame:self.containerView.frame];
    self.visualEffectViewBgView = visualEffectViewBgView;
    [visualEffectViewBgView addSubview:effectView];
    
    [self.containerView addSubview:visualEffectViewBgView];//此处的self.containerView和动画对象中的containerView是一个；先调用此处
    [self.containerView addSubview:self.presentedView];
    
    visualEffectViewBgView.alpha = 0;
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        visualEffectViewBgView.alpha = 0.8;
        
        self.presentingViewController.view.transform = CGAffineTransformScale(self.presentingViewController.view.transform, 0.92, 0.92);
        
        //圆角即时完成，没有动画
        self.presentingViewController.view.layer.masksToBounds = YES;
        self.presentingViewController.view.layer.cornerRadius = XTCardViewCornerRadius;
        
        self.presentedViewController.view.layer.masksToBounds = YES;
        self.presentedViewController.view.layer.cornerRadius = XTCardViewCornerRadius;
        
    } completion:nil];
    
}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    if (!completed) {
        [self.visualEffectViewBgView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin{
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.visualEffectViewBgView.alpha = 0;
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [self.visualEffectViewBgView removeFromSuperview];
        self.presentingViewController.view.layer.masksToBounds = NO;
        self.presentingViewController.view.layer.cornerRadius = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.presentingViewController.view];
    }
}

#pragma mark - 其他协议方法
-(CGRect)frameOfPresentedViewInContainerView{
    return CGRectMake(0, XTSHeight/8, XTSwidth, XTSHeight * 7/8);
}

//-(UIView *)presentedView{
//    self.presentedViewController.view.layer.masksToBounds = YES;
//    self.presentedViewController.view.layer.cornerRadius = XTCardViewCornerRadius;
//    return self.presentedViewController.view;
//}
@end
