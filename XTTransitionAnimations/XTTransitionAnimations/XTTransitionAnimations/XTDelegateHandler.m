//
//  XTDelegateHandler.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "XTDelegateHandler.h"
#import "XTBaseInteractiveObj.h"

@interface XTDelegateHandler()
@property (nonatomic,assign) XTAnimationType aniType;
@property (nonatomic,assign) BOOL isInteract;
@property (nonatomic,weak) UIViewController *presentedVC;
@property (nonatomic,strong) XTBaseInteractiveObj *interactiveObj;
@property (nonatomic,assign) NSInteger transitionType;
@property (nonatomic,strong) NSDictionary *aniConfigDic;
@end

@implementation XTDelegateHandler

- (instancetype)initWithAnimatedType:(XTAnimationType)aniType presentedVC:(UIViewController *)presentedVC transitionType:(XTTransitionType)transitionType interact:(BOOL)isInteract{
    self = [super init];
    if (self) {
        
        _aniType = aniType;
        _isInteract = isInteract;
        _presentedVC = presentedVC;
        _transitionType = transitionType;
        
        NSString *aniConfigDicPath = [[NSBundle mainBundle] pathForResource:@"XTAnimationsConfig" ofType:@"plist"];
        NSDictionary *aniConfigDic = [NSDictionary dictionaryWithContentsOfFile:aniConfigDicPath];
        self.aniConfigDic = aniConfigDic[[self convertAnimationTypeEnumToStr:aniType]];
        
        [self createInteractiveObj];
        
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    NSDictionary *dic = @{
                          @"transitionType":[NSNumber numberWithInteger:XTPresent],
                          @"animatedType":[NSNumber numberWithInteger:self.aniType],
                          @"interact":[NSNumber numberWithBool:self.isInteract?self.interactiveObj.interactiving:self.isInteract],
                          };
    id obj = [self createObjWithClassName:self.aniConfigDic[@"animationClass"][@"className"] selectorName:@"initWithConfig:" params:dic];
    
    return obj;

}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    NSDictionary *dic = @{
                          @"transitionType":[NSNumber numberWithInteger:XTDismiss],
                          @"animatedType":[NSNumber numberWithInteger:self.aniType],
                          @"interact":[NSNumber numberWithBool:self.isInteract?self.interactiveObj.interactiving:self.isInteract],
                          };
    id obj = [self createObjWithClassName:self.aniConfigDic[@"animationClass"][@"className"] selectorName:@"initWithConfig:" params:dic];
    
    return obj;
    
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.interactiveObj) {
        return self.interactiveObj.interactiving?self.interactiveObj:nil;
    }
    return nil;
}

//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source{
//
//
//    return nil;
//}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    
    XTTransitionType transitiongType;
    if (operation == UINavigationControllerOperationPush) {
        transitiongType = XTPush;
    }else{
        transitiongType = XTPop;
    }
    
    NSDictionary *dic = @{
                          @"transitionType":[NSNumber numberWithInteger:transitiongType],
                          @"animatedType":[NSNumber numberWithInteger:self.aniType],
                          @"interact":[NSNumber numberWithBool:self.isInteract?self.interactiveObj.interactiving:self.isInteract],
                          };
    id obj = [self createObjWithClassName:self.aniConfigDic[@"animationClass"][@"className"] selectorName:@"initWithConfig:" params:dic];
    
    return obj;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    if (self.interactiveObj) {
        return self.interactiveObj.interactiving?self.interactiveObj:nil;
    }
    return nil;
}


#pragma mark - 辅助方法
- (void)createInteractiveObj{

    if (self.isInteract) {
        
        XTTransitionType disappearType = 0;
        switch (self.transitionType) {
            case XTPush:
            case XTPop:
                disappearType = XTPop;
                break;
                
            case XTPresent:
            case XTDismiss:
                disappearType = XTDismiss;
                break;
                
            default:
                break;
        }

        NSString *interClassName = self.aniConfigDic[@"interactiveClass"][@"className"];
        
        NSDictionary *dic = @{
                              @"interactiveVC":self.presentedVC,
                              @"completePointNum":self.aniConfigDic[@"interactiveClass"][@"completePointNum"],//这里应该放到interObj中计算，因为有的view不是全屏幕,当前获取的还不是变化后的view实际的frame
                              @"transitionType":[NSNumber numberWithInteger:disappearType],
                              @"isVertical":[NSNumber numberWithBool:[self.aniConfigDic[@"interactiveClass"][@"isVertical"] boolValue]],
                              @"isAccordToCoordinate":[NSNumber numberWithBool:[self.aniConfigDic[@"interactiveClass"][@"isAccordToCoordinate"] boolValue]]
                              };
        
        id obj = [self createObjWithClassName:interClassName selectorName:@"initWithConfig:" params:dic];
        
        self.interactiveObj = obj;
        
    }
    
}

-(id)createObjWithClassName:(NSString *)className selectorName:(NSString *)selectorName params:(NSDictionary *)params{
    
    Class class = NSClassFromString(className);
    if (!class) {
        return nil;
    }
    id allocObj = [class alloc];
    SEL objInitSEL = NSSelectorFromString(selectorName);
    IMP objInitImp = [allocObj methodForSelector:objInitSEL];
    id (*objInitFunc)(id,SEL,NSDictionary *) = (void *)objInitImp;
    id obj = objInitFunc(allocObj,objInitSEL,params);
    return obj;
    
}

-(NSString *)convertAnimationTypeEnumToStr:(XTAnimationType)anitype{
    switch (anitype) {
        case 0:
            return @"XTSpringFromBottom";
            break;
            
        case 1:
            return @"XTSpringFromRight";
            break;
            
        case 2:
            return @"XTSpringFromTop";
            break;
            
        case 3:
            return @"XTSpringFromLeft";
            break;
            
        case 4:
            return @"XTRoundExpand";
            break;
            
        case 5:
            return @"XTCardSpringFromBottom";
            break;
            
        case 6:
            return @"XTCubeRotateFromRight";
            break;
            
        case 7:
            return @"XTCubeRotateFromTop";
            break;
            
        default:
            return nil;
            break;
    }
    
}

@end
