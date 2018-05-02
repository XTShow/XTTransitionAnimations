//
//  UINavigationController+XTTransitionAnimations.h
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/8.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCommonValue.h"

@interface UINavigationController (XTTransitionAnimations)

/**
 根据animatedType定制push时的转场动画，默认pop返回时有配套的转场动画。

 @param viewController push到的VC
 @param aniType 动画种类
 @param isInteract 转场动画是否可交互
 */


/**
 According to the animatedType to customize the transition animation when push, in default, there is matching transition animation for pop.

 @param viewController Pushed VC(viewController)
 @param aniType The type of transition animation
 @param isInteract Whether transition animation is interactive
 */
-(void)XT_PushViewController:(UIViewController *)viewController animatedType:(XTAnimationType)aniType interact:(BOOL)isInteract;

@end
