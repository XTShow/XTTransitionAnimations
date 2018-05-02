//
//  XTBaseInteractiveObj.h
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/9.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+XTTransitionAnimations.h"

@interface XTBaseInteractiveObj : UIPercentDrivenInteractiveTransition

/**
 是否处于交互中，用于区分VC当前应该通过交互完成转场动画，还是直接完成转场动画
 */

/**
 Whether current VC is in interaction, used to distinguish whether VC should complete transition animation through interaction, or directly.
 */
@property (nonatomic,assign) BOOL interactiving;

@end
