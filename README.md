# XTTransitionAnimations
XTTransitionAnimations can let you implement a custom transition animation by **only One line of code**.

[中文说明](www.baidu.com)
### Features
- Implement a custom transition animation by only one line of code, and it is very similar to the iOS system's present and push transiton api. Low learning cost;
- Support configure parameters about animation, such as duration, damping ratio, timing function, etc.;
- The interactivity of transition animations is configurable;
- Low invasive, does not interfere with the UI;
- There is matching transition animation for dismiss/pop in default, it also can be configured separately;
- For interactive animation, elastic animation and linear animation are automatically switched.



![Spring From Bottom(present,interact,XTSpringFromEdgeAnimation)](https://upload-images.jianshu.io/upload_images/2161270-a9dbba841b96a9de.gif?imageMogr2/auto-orient/strip "Spring From Bottom(present,interact,XTSpringFromEdgeAnimation)")
![Spring From Right(push,interact,XTSpringFromEdgeAnimation)](https://upload-images.jianshu.io/upload_images/2161270-28ffdce62291c86d.gif?imageMogr2/auto-orient/strip "Spring From Right(push,interact,XTSpringFromEdgeAnimation)")
![Round Spring Expand(present,interact,XTRoundExpandAnimation)](https://upload-images.jianshu.io/upload_images/2161270-71823a5915a28193.gif?imageMogr2/auto-orient/strip "Round Spring Expand(present,interact,XTRoundExpandAnimation)")
![Card Spring From Bottom(present,interact,XTCardPresentAnimation)](https://upload-images.jianshu.io/upload_images/2161270-a68f887515a46c8e.gif?imageMogr2/auto-orient/strip "Card Spring From Bottom(present,interact,XTCardPresentAnimation)")
![Cube Rotate From Right(push,interact,XTCubeAnimation)](https://upload-images.jianshu.io/upload_images/2161270-0db54858452f2582.gif?imageMogr2/auto-orient/strip "Cube Rotate From Right(push,interact,XTCubeAnimation)")
![Cube Rotate From Top(present,interact,XTCubeAnimation)](https://upload-images.jianshu.io/upload_images/2161270-38cdedeba3e67d77.gif?imageMogr2/auto-orient/strip "Cube Rotate From Top(present,interact,XTCubeAnimation)")



#### Just implement an animation object to customize your own transition animation
XTTransitionAnimations supporets expansion animation type. The main process is as follows:
1. Create an animation object which implement the effect you want and conforms to UIViewControllerAnimatedTransitioning(such as the class in the Animations folder);
2. (Optional) If the interactive method that the gesture-slide distance controls the transition animation progress does not meet your needs, you can create a subclass from XTBaseInteractiveObj to customize your own interactive method;
3. Complete the basic configuration in XTAnimationsConfig.plist for your own animation;
4. Finally maintain the convertAnimationTypeEnumToStr: selector (convert the enumerated type to a string).

Now, you can use the api of this framework to implement yourself transition animation!

#### The usefulness of the XTAnimationsConfig.plist
- XTAnimationsConfig.plist is used to configure each XTAnimationType;
- It contains several dictionaries, each correspond to a XTAnimationType;
- A dictionary contains following parameters:
  - animationClass:The class name of the class which can implement the animation(the various classes in the Animations folder);
  - interactiveClass:The configuration requied to implement interactive;
    - className:The class name of the class which can implement the interactive for animation(the various classes in the Interactive folder);
    - isVertical:Because the general interaction is controlled by gestures and is related to the distance of the movement of the gesture, so this value configures the progress of the transition animation is related to the displacement in the vertical or in the horizontal;
    - isAccordToCoordinate:Configures whether the change trend of the animation completion is same as the screen coordinate, that is, when the displacement is positive and gradually larger, the completion progress of transition animation is gradually larger or smaller;
    - completePointNum:The points number required for complete the transition animation;
      - ScreenHorW:The points number is calculated based on the height or width of the screen;(W:width;H:height);
      - percent:The percentage of point number to the width or height of the screen;(calculates the points number required complete transition through the above two parameters);
      - absolutePointNum:Specifies the points number, if the displacement distance reaches the points number, the current transition animation reaches the completion condition;(priority is given to the above two parameters);

### How To Get Started
1. Download the XTTransitionAnimations zip and try out the example app;
2. Drag the folder "XTTransitionAnimations" which in the project folder "XTTransitionAnimations" into your project;

### How To Use

````
#import "UIViewController+XTTransitionAnimations.h"
#import "UINavigationController+XTTransitionAnimations.h"

[self XT_PresentViewController:vc animatedType:XTSpringFromBottom interact:NO completion:nil];
[self.navigationController XT_PushViewController:vc animatedType:XTRoundExpand interact:YES];
````
#### Api Document
###### Present
````
/**
 According to the animatedType to customize the transition animation when present,in default,there is matching transition animation for dismiss.
 
 @param viewControllerToPresent Presented VC(viewController)
 @param aniType The type of transition animation
 @param isInteract Whether transition animation is interactive
 @param completion The block to execute after the presentation finishes
 */
-(void)XT_PresentViewController:(UIViewController *)viewControllerToPresent animatedType:(XTAnimationType)aniType interact:(BOOL)isInteract completion:(void (^)(void))completion;
````

###### Custom Dismiss
````
/**
 If you don't want to use the transition animation which match by present or you only need transition animation when dismiss, you can use this method to customize the transition animation when dismiss.
 (1.It is recommended that you can call this method to complete configuration between the VC which will dismiss initialization and view will display, like in viewWillAppear ,otherwise ,the interactive part will still execute according to the matching animation which set in XT_PresentViewController;
  2.It is not recommended that some present and dismiss animations which have strong correlation, such as XTCardSpringFromBottom etc., use this method to customize transition animation, the visual effect will be poor;
  3.If you call this method in correct way, you can directly call system's popViewControllerAnimated: when dismiss.)

 @param aniType The type of transition animation
 @param isInteract Whether transition animation is interactive
 */
-(void)XT_ConfigureDismissWithAnimatedType:(XTAnimationType)aniType interact:(BOOL)isInteract;
````

###### Push
````
/**
 According to the animatedType to customize the transition animation when push, in default, there is matching transition animation for pop.

 @param viewController Pushed VC(viewController)
 @param aniType The type of transition animation
 @param isInteract Whether transition animation is interactive
 */
-(void)XT_PushViewController:(UIViewController *)viewController animatedType:(XTAnimationType)aniType interact:(BOOL)isInteract;
````
