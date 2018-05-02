//
//  UIViewController+XTTransitionAnimations.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "UIViewController+XTTransitionAnimations.h"
#import "XTDelegateHandler.h"
#import <objc/runtime.h>

static NSString * const XT_DelegateHandlerKey = @"XT_DelegateHandlerKey";
static NSString * const XTGestureRecognizersArrayKey = @"XTGestureRecognizersArrayKey";

@interface UIViewController ()
@property (nonatomic,strong) XTDelegateHandler *XT_DelegateHandler;
@end

@implementation UIViewController (XTTransitionAnimations)

-(void)XT_PresentViewController:(UIViewController *)viewControllerToPresent animatedType:(XTAnimationType)aniType interact:(BOOL)isInteract completion:(void (^)(void))completion{
    XTDelegateHandler *delegateHandler = [[XTDelegateHandler alloc] initWithAnimatedType:aniType presentedVC:viewControllerToPresent transitionType:XTPresent interact:isInteract];
    self.XT_DelegateHandler = delegateHandler;
    viewControllerToPresent.transitioningDelegate = delegateHandler;
    if ([self checkPresentationController:aniType]) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    }
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

-(void)XT_ConfigureDismissWithAnimatedType:(XTAnimationType)aniType interact:(BOOL)isInteract{
    
    for (UIGestureRecognizer *ges in self.XTGestureRecognizersArray) {
        [self.view removeGestureRecognizer:ges];
    }
    
    XTDelegateHandler *delegateHandler = [[XTDelegateHandler alloc] initWithAnimatedType:aniType presentedVC:self transitionType:XTDismiss interact:isInteract];
    self.XT_DelegateHandler = delegateHandler;
    self.transitioningDelegate = delegateHandler;
    if ([self checkPresentationController:aniType]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
}

#pragma mark - 辅助方法
-(BOOL)checkPresentationController:(XTAnimationType)anitype{
    NSArray *needPresentationControllerArray = @[
                                                [NSNumber numberWithInteger:XTCardSpringFromBottom]
                                                ];
    return [needPresentationControllerArray containsObject:[NSNumber numberWithInteger:anitype]];
}

#pragma mark - make property in Runtime
-(void)setXT_DelegateHandler:(XTDelegateHandler *)XT_DelegateHandler{
    objc_setAssociatedObject(self, &XT_DelegateHandlerKey, XT_DelegateHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(XTDelegateHandler *)XT_DelegateHandler{
    return objc_getAssociatedObject(self, &XT_DelegateHandlerKey);
}

-(void)setXTGestureRecognizersArray:(NSMutableArray *)XTGestureRecognizersArray{
    objc_setAssociatedObject(self, &XTGestureRecognizersArrayKey, XTGestureRecognizersArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)XTGestureRecognizersArray{
    return objc_getAssociatedObject(self, &XTGestureRecognizersArrayKey);
}
@end
