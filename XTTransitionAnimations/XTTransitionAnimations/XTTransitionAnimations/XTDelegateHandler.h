//
//  XTDelegateHandler.h
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+XTTransitionAnimations.h"

@interface XTDelegateHandler : NSObject
<
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate
>

/**
 生成一个用于集中处理代理UIViewControllerTransitioningDelegate和UINavigationControllerDelegate的对象。

 @param aniType 动画种类
 @param vc 被presented/push的VC
 @param transitionType 转场方式（present\dismiss\push\pop）
 @param isInteract 转场动画是否可交互
 @return 根据参数生产的XTDelegateHandler的实例对象
 */


/**
 Generates an object that centrally handles the UIViewControllerTransitioningDelegate and UINavigationControllerDelegate.

 @param aniType The type of transition animation
 @param vc VC which you want to push/present
 @param transitionType Type of current transition(present\dismiss\push\pop etc.)
 @param isInteract Whether transition animation is interactive
 @return An object that centrally handles the UIViewControllerTransitioningDelegate and UINavigationControllerDelegate
 */
- (instancetype)initWithAnimatedType:(XTAnimationType)aniType presentedVC:(UIViewController *)vc transitionType:(XTTransitionType)transitionType interact:(BOOL)isInteract;

@end
