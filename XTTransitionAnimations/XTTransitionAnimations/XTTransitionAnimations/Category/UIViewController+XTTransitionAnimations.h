//
//  UIViewController+XTTransitionAnimations.h
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCommonValue.h"

@interface UIViewController (XTTransitionAnimations)

/**
 存放InteractiveObj中生成的GestureRecognizer
 */

/**
Store GestureRecognizers generated in InteractiveObj
*/
@property (nonatomic,strong) NSMutableArray *XTGestureRecognizersArray;

/**
 根据animatedType定制present时的转场动画，默认dismiss返回时有配套的转场动画。

 @param viewControllerToPresent 弹出的VC
 @param aniType 动画种类
 @param isInteract 转场动画是否可交互
 @param completion 完成动画时的回调
 */

/**
 According to the animatedType to customize the transition animation when present,in default,there is matching transition animation for dismiss.
 
 @param viewControllerToPresent Presented VC(viewController)
 @param aniType The type of transition animation
 @param isInteract Whether transition animation is interactive
 @param completion The block to execute after the presentation finishes
 */
-(void)XT_PresentViewController:(UIViewController *)viewControllerToPresent animatedType:(XTAnimationType)aniType interact:(BOOL)isInteract completion:(void (^)(void))completion;


/**
 如果不想使用present配套的转场动画 或 只需要dismiss时出现转场动画，可使用该方法单独定制dismiss时的转场动画。
（1.建议在需要dismiss的VC初始化完成后，视图展示之前，例如viewWillAppear中调用该方法完成配置，否则会出现交互部分仍按XT_PresentViewController中设置的配套动画执行的情况;
 2.不建议某些关联性较强的present和dismiss动画，例如XTCardSpringFromBottom等，使用此方法定制动画，视觉效果会很差;
 3.在正确位置调用该方法完成配置后，需要dismiss时直接调用系统的popViewControllerAnimated:方法即可。）
 
 @param aniType 动画种类
 @param isInteract 转场动画是否可交互
 */

/**
 If you don't want to use the transition animation which match by present or you only need transition animation when dismiss, you can use this method to customize the transition animation when dismiss.
 (1.It is recommended that you can call this method to complete configuration between the VC which will dismiss initialization and view will display, like in viewWillAppear ,otherwise ,the interactive part will still execute according to the matching animation which set in XT_PresentViewController;
  2.It is not recommended that some present and dismiss animations which have strong correlation, such as XTCardSpringFromBottom etc., use this method to customize transition animation, the visual effect will be poor;
  3.If you call this method in correct way, you can directly call system's popViewControllerAnimated: when dismiss.)

 @param aniType The type of transition animation
 @param isInteract Whether transition animation is interactive
 */
-(void)XT_ConfigureDismissWithAnimatedType:(XTAnimationType)aniType interact:(BOOL)isInteract;
@end
