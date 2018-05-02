//
//  ShowVC.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/8.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "ShowVC.h"
#import "UIViewController+XTTransitionAnimations.h"

@interface ShowVC ()
@property (nonatomic,assign) BOOL hasSetUI;
@end

@implementation ShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //自定义Dismiss的转场动画
    //customize Dismiss transition animation
    //[self XT_ConfigureDismissWithAnimatedType:XTSpringFromTop interact:YES];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.hasSetUI) {
        [self setupUI];
        self.hasSetUI = YES;
    }
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    imgView.frame = self.view.bounds;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 88, self.view.frame.size.height - 50, 88, 50)];
    [dismissBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    dismissBtn.layer.masksToBounds = YES;
    dismissBtn.layer.cornerRadius = 5;
    [dismissBtn setBackgroundColor:[UIColor darkTextColor]];
    [self.view addSubview:dismissBtn];
    [dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
