//
//  XTPanInteractive.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/8.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "XTPanInteractive.h"
#import "XTCommonValue.h"

@interface XTPanInteractive ()
@property (nonatomic,strong) UIViewController *interactiveVC;
@property (nonatomic,assign) NSInteger completePointNum;
@property (nonatomic,assign) XTTransitionType transitionType;
@property (nonatomic,assign) BOOL isVertical;
@property (nonatomic,assign) BOOL isAccordant;
@property (nonatomic,assign) BOOL transitionComplete;
@property (nonatomic,strong) NSDictionary *completePointNumDic;
@end

@implementation XTPanInteractive

- (instancetype)initWithConfig:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        _interactiveVC = dic[@"interactiveVC"];
        _completePointNumDic = dic[@"completePointNum"];
        _transitionType = [dic[@"transitionType"] integerValue];
        _isVertical = [dic[@"isVertical"] boolValue];
        _isAccordant = [dic[@"isAccordToCoordinate"] boolValue];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_interactiveVC.view addGestureRecognizer:pan];
        
        _interactiveVC.XTGestureRecognizersArray = [NSMutableArray array];
        [_interactiveVC.XTGestureRecognizersArray addObject:pan];
    }
    return self;
}

-(void)handlePan:(UIPanGestureRecognizer *)pan{
    
    if (!self.completePointNum) {
        //计算完成交互的距离
        if ([self.completePointNumDic[@"absolutePointNum"] floatValue] > 0) {//默认先采用绝对距离值
            self.completePointNum = [self.completePointNumDic[@"absolutePointNum"] floatValue];
        }else{
            CGSize presentedViewSize = _interactiveVC.view.bounds.size;
            
            CGFloat totalPointNum;
            if ([self.completePointNumDic[@"ScreenHorW"] isEqualToString:@"H"]) {
                totalPointNum = presentedViewSize.height;
            }else{
                totalPointNum = presentedViewSize.width;
            }
            self.completePointNum = totalPointNum * [self.completePointNumDic[@"percent"] floatValue];
        }
    }
    
    CGPoint translation = [pan translationInView:[self.interactiveVC.view superview]];//只要下面一开始dismiss\pop的过程，interactiveVC.view.layer的position和anchor会立即切换到最终状态，而不是根据交互动作一点点变，因此某些改变position和anchorPoint的动画（XTCubeAnimation）会出现view已经不在手指下面的情况，造成translation = {nan, nan}的情况，无法进行交互。因此计算动作在[self.interactiveVC.view superview]上的位移更可靠。

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.interactiving = YES;
            switch (self.transitionType) {

                case XTDismiss:
                    [self.interactiveVC dismissViewControllerAnimated:YES completion:nil];
                    break;

                case XTPop:
                    [self.interactiveVC.navigationController popViewControllerAnimated:YES];
                    break;
                default:
                    break;
            }
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            CGFloat distance = self.isVertical?translation.y:translation.x;
            distance = self.isAccordant?distance:(-distance);
            CGSize interactiveVCSize = self.interactiveVC.view.bounds.size;
            CGFloat percent = distance/(self.isVertical?interactiveVCSize.height:interactiveVCSize.width);
            percent = fminf((fmaxf(percent, 0)), 1);
            self.transitionComplete = (distance >= self.completePointNum);
            [self updateInteractiveTransition:percent];
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            self.interactiving = NO;
            if (!self.transitionComplete || pan.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
                [[NSNotificationCenter defaultCenter] postNotificationName:XTTransitionFinishInteractiveTransition object:[NSString stringWithFormat:@"%p",self.interactiveVC]];
            }
        }
            break;
        default:
            break;
    }
}

@end
