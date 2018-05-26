//
//  UINavigationController+XTTransitionAnimations.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/8.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "UINavigationController+XTTransitionAnimations.h"
#import "XTDelegateHandler.h"
#import <objc/runtime.h>

static NSString * const DelegateHandlerKey = @"DelegateHandlerKey";
static NSString * const DelegateHandlerArrayKey = @"DelegateHandlerArrayKey";
static NSString * const PresentedVCKey = @"PresentedVCKey";
static NSString * const ShouldRemoveDicKey = @"ShouldRemoveDicKey";

@interface UINavigationController ()
@property (nonatomic,strong) XTDelegateHandler *delegateHandler;
@property (nonatomic,strong) NSMutableArray *delegateHandlerArray;
@property (nonatomic,strong) UIViewController *presentedVC;
@property (nonatomic,strong) NSMutableDictionary *shouldRemoveDic;
@end

@implementation UINavigationController (XTTransitionAnimations)

+(void)load{
    
    Method orginalPushMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method exchangePushMethod = class_getInstanceMethod([self class], @selector(XT_PushViewController:animated:));
    method_exchangeImplementations(orginalPushMethod, exchangePushMethod);
    
    Method orginalPopMethod = class_getInstanceMethod([self class], @selector(popViewControllerAnimated:));
    Method exchangePopMethod = class_getInstanceMethod([self class], @selector(XT_PopViewControllerAnimated:));
    method_exchangeImplementations(orginalPopMethod, exchangePopMethod);
    
    Method orginalPopToMethod = class_getInstanceMethod([self class], @selector(popToViewController:animated:));
    Method exchangePopToMethod = class_getInstanceMethod([self class], @selector(XT_PopToViewController:animated:));
    method_exchangeImplementations(orginalPopToMethod, exchangePopToMethod);
    
    Method orginalPopToRootMethod = class_getInstanceMethod([self class], @selector(popToRootViewControllerAnimated:));
    Method exchangePopToRootMethod = class_getInstanceMethod([self class], @selector(XT_PopToRootViewControllerAnimated:));
    method_exchangeImplementations(orginalPopToRootMethod, exchangePopToRootMethod);
    
    Method orginalDeallocMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method exchangeDeallocMethod = class_getInstanceMethod([self class], @selector(XT_Dealloc));
    method_exchangeImplementations(orginalDeallocMethod, exchangeDeallocMethod);
}


-(void)XT_PushViewController:(UIViewController *)viewController animatedType:(XTAnimationType)aniType interact:(BOOL)isInteract{
    
    if (!self.delegateHandlerArray) {
        self.delegateHandlerArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticedFinishInteractiveTransition:) name:XTTransitionFinishInteractiveTransition object:nil];
    }
    
    XTDelegateHandler *delegateHandler = [[XTDelegateHandler alloc] initWithAnimatedType:aniType presentedVC:viewController transitionType:XTPush interact:isInteract];
    self.presentedVC = viewController;
    self.delegateHandler = delegateHandler;
    self.delegate = delegateHandler;

    NSArray *VCArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%p",self.topViewController],[NSString stringWithFormat:@"%p",viewController],nil];

    NSDictionary *dic = @{
                          @"VCArray":VCArray,
                          @"delegateObj":delegateHandler,
                          };
    NSMutableDictionary *numtableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.delegateHandlerArray addObject:numtableDic];
    
    [self pushViewController:viewController animated:YES];
}

#pragma mark - 辅助方法
-(id)checkDelegateHandlerAndDeleteFrom:(UIViewController *)fromVC To:(UIViewController *)toVC{
    
    id delegateObj;
    
    for (NSMutableDictionary *dic in self.delegateHandlerArray) {
        NSArray *VCArray = dic[@"VCArray"];
        
        if ([VCArray containsObject:[NSString stringWithFormat:@"%p",fromVC]] & [VCArray containsObject:[NSString stringWithFormat:@"%p",toVC]]) {
            delegateObj = dic[@"delegateObj"];
            self.shouldRemoveDic = dic;
            break;
        }
    }
    
    return delegateObj;
}

-(void)noticedFinishInteractiveTransition:(NSNotification *)noti{
    NSString *interacVCAddress = [NSString stringWithFormat:@"%@",noti.object];
    
    if ([interacVCAddress isEqualToString:[NSString stringWithFormat:@"%p",self.presentedVC]]) {
        [self.delegateHandlerArray removeObject:self.shouldRemoveDic];
    }
}

#pragma mark - swizzle selector in Runtime

-(void)XT_PushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    id delegateObj;
    for (NSMutableDictionary *dic in self.delegateHandlerArray) {
        NSArray *VCArray = dic[@"VCArray"];
        
        if ([VCArray containsObject:[NSString stringWithFormat:@"%p",self.topViewController]] & [VCArray containsObject:[NSString stringWithFormat:@"%p",viewController]]) {
            delegateObj = dic[@"delegateObj"];
            break;
        }
    }
    
    self.delegate = delegateObj;
    [self XT_PushViewController:viewController animated:animated];
}

-(UIViewController *)XT_PopViewControllerAnimated:(BOOL)animated{
    
    UIViewController *popToVC;
    if (self.viewControllers.count >= 2) {//在navVC的rootVC上（没有pop的VC），也可以调用该方法，防止崩溃
        popToVC = self.viewControllers[self.viewControllers.count - 2];
    }

    id delegateObj = [self checkDelegateHandlerAndDeleteFrom:self.topViewController To:popToVC];
    
    self.delegate = delegateObj?delegateObj:self.delegate;
    
    return [self XT_PopViewControllerAnimated:animated];
}

-(NSArray<UIViewController *> *)XT_PopToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    id delegateObj = [self checkDelegateHandlerAndDeleteFrom:self.topViewController To:viewController];
    self.delegate = delegateObj?delegateObj:self.delegate;
    
    return [self XT_PopToViewController:viewController animated:animated];
}

-(NSArray<UIViewController *> *)XT_PopToRootViewControllerAnimated:(BOOL)animated{
    
    UIViewController *popToVC = self.viewControllers.firstObject;
    id delegateObj = [self checkDelegateHandlerAndDeleteFrom:self.topViewController To:popToVC];
    
    self.delegate = delegateObj?delegateObj:self.delegate;
    
    return [self XT_PopToRootViewControllerAnimated:animated];
}

-(void)XT_Dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XTTransitionFinishInteractiveTransition object:nil];
    [self XT_Dealloc];
}

#pragma mark - make property in Runtime
-(void)setDelegateHandler:(XTDelegateHandler *)delegateHandler{
    objc_setAssociatedObject(self, &DelegateHandlerKey, delegateHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(XTDelegateHandler *)delegateHandler{
    return objc_getAssociatedObject(self, &DelegateHandlerKey);
}


-(void)setDelegateHandlerArray:(NSMutableArray *)delegateHandlerArray{
    objc_setAssociatedObject(self, &DelegateHandlerArrayKey, delegateHandlerArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)delegateHandlerArray{
    return objc_getAssociatedObject(self, &DelegateHandlerArrayKey);
}


-(void)setPresentedVC:(UIViewController *)presentedVC{
    objc_setAssociatedObject(self, &PresentedVCKey, presentedVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewController *)presentedVC{
    return objc_getAssociatedObject(self, &PresentedVCKey);
}

-(void)setShouldRemoveDic:(NSMutableDictionary *)shouldRemoveDic{
    objc_setAssociatedObject(self, &ShouldRemoveDicKey, shouldRemoveDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)shouldRemoveDic{
    return objc_getAssociatedObject(self, &ShouldRemoveDicKey);
}
@end
