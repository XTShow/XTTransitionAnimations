//
//  XTCommonValue.h
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/20.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - XTAnimationsConfig.plist Configuration Instructions
/**
 XTAnimationsConfig.plist用于配置每个动画类型（XTAnimationType）；
 其中包含多个字典，每个字典对应一个动画种类；
 字典中包含以下参数：
    animationClass：实现该动画需要的类的类名（Animations文件夹中的各个类）；
    interactiveClass：实现交互所需的配置；
        className：该动画实现交互所需的类的类名（Interactive文件夹中的各个类）；
        isVertical：由于一般的交互是通过手势控制的，而且大多与手势的移动距离有关，因此该属性配置当前交互的进度是与竖直方向还是水平方向的位移有关；
        isAccordToCoordinate：动画完成进度的变化趋势是否与屏幕的坐标体系一致，即位移为正值逐渐变大时，是否完成进度也在逐渐变大；
        completePointNum：动画完成所需要位移的点数；
            ScreenHorW：点数是基于屏幕的高还是宽来计算（W:宽；H:高）；
            percent：点数占屏幕宽或高的百分比；（通过以上两个参数计算完成过场动画所需的位移点数）
            absolutePointNum：输入具体的点数，位移距离达到指定点数则当前动画达到完成条件（优先于以上两个参数生效）
 
 如果你想自定义新的动画，只需完成该配置文件，并生成动画对象（例如Animations文件夹中的类）,如需新的交互方式，只需生成继承于XTBaseInteractiveObj类的交互对象（例如Interactive文件夹中的类），最后维护convertAnimationTypeEnumToStr方法，你就可以使用本框架统一的api来调用你自己的转场动画了！
 */
/**
 XTAnimationsConfig.plist is used to configure each XTAnimationType;
 It contains several dictionaries, each correspond to a XTAnimationType;
 A dictionary contains following parameters:
     animationClass:The class name of the class which can implement the animation(the various classes in the Animations folder);
     interactiveClass:The configuration requied to implement interactive;
        className:The class name of the class which can implement the interactive for animation(the various classes in the Interactive folder);
        isVertical:Because the general interaction is controlled by gestures and is related to the distance of the movement of the gesture, so this value configures the progress of the transition animation is related to the displacement in the vertical or in the horizontal;
        isAccordToCoordinate:Configures whether the change trend of the animation completion is same as the screen coordinate, that is, when the displacement is positive and gradually larger, the completion progress of transition animation is gradually larger or smaller;
        completePointNum:The points number required for complete the transition animation;
        ScreenHorW:The points number is calculated based on the height or width of the screen;(W:width;H:height)
        percent:The percentage of point number to the width or height of the screen;(calculates the points number required complete transition through the above two parameters)
        absolutePointNum:Specifies the points number, if the displacement distance reaches the points number, the current transition animation reaches the completion condition;(priority is given to the above two parameters)
 
 If you want to customize a new animation, just complete the configuration file and create an animation object(such as the class in the Animations folder); if you need new interaction method, simply create an interactive object that is inherits from XTBaseInteractiveObj(such as the class in the Interactive folder); in finally, maintain the convertAnimationTypeEnumToStr selector, you can use the api of this framework to implement yourself transition animation!
 */

#pragma mark - 枚举类型
/**
 动画种类
 (1.修改顺序或新增时，请注意维护convertAnimationTypeEnumToStr方法；
  2.新增时，请完成XTAnimationsConfig.plist中对应的配置。)
 */

/**
 Type for transition animation
 (1.When changing order or adding, please pay attention to maintaining selector convertAnimationTypeEnumToStr;
  2.When adding, please complete corresponding configuration in XTAnimationsConfig.plist.)
 */
typedef NS_ENUM(NSInteger,XTAnimationType) {
    XTSpringFromBottom,
    XTSpringFromRight,
    XTSpringFromTop,
    XTSpringFromLeft,
    XTRoundExpand,
    XTCardSpringFromBottom,
    XTCubeRotateFromRight,
    XTCubeRotateFromTop,
};

/**
 过渡方式
 */

/**
 Type of current transition
 */
typedef NS_ENUM(NSInteger,XTTransitionType) {
    XTPresent,
    XTDismiss,
    XTPush,
    XTPop
};

#pragma mark - 系统长度
#define XTSwidth [UIScreen mainScreen].bounds.size.width
#define XTSHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - NSNotificationName
#define XTTransitionFinishInteractiveTransition @"XTTransitionFinishInteractiveTransition"


@interface XTCommonValue : NSObject

@end
