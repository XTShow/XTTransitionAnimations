//
//  XTCubeAnimation.h
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/16.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XTCubeAnimation : NSObject
<
UIViewControllerAnimatedTransitioning
>

- (instancetype)initWithConfig:(NSDictionary *)dic;
@end
