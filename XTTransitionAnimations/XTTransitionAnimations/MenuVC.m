//
//  MenuVC.m
//  XTTransitionAnimations
//
//  Created by XTShow on 2018/4/4.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "MenuVC.h"
#import "UIViewController+XTTransitionAnimations.h"
#import "UINavigationController+XTTransitionAnimations.h"
#import "ShowVC.h"

static NSString *tableViewCellID = @"tableViewCellID";

@interface MenuVC ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic,strong) NSArray *animationsNameArray;
@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    /**
     1.此处的是否可交互，默认指的是dismiss可交互(present目前还未找到较适合交互的转场动画方式);
     2.实现弹性动画与交互时为线性动画的自动切换；
     3.每个动画中的参数可配置
     */
    self.animationsNameArray = @[
                                 @"Spring From Bottom(present,no-interact,XTSpringFromEdgeAnimation)",
                                 @"Spring From Bottom(present,interact,XTSpringFromEdgeAnimation)",
                                 @"Round Spring Expand(present,no-interact,XTRoundExpandAnimation)",
                                 @"Round Spring Expand(present,interact,XTRoundExpandAnimation)",
                                 @"Card Spring From Bottom(present,no-interact,XTCardPresentAnimation)",
                                 @"Card Spring From Bottom(present,interact,XTCardPresentAnimation)",
                                 
                                 @"Spring From Right(push,interact,XTSpringFromEdgeAnimation)",
                                 @"Round Spring Expand(push,interact,XTRoundExpandAnimation)",
                                 @"Cube Rotate From Right(push,interact,XTCubeAnimation)",
                                 @"Cube Rotate From Top(present,interact,XTCubeAnimation)",
                                 ];
    [self setupUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)setupUI{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tableView.rowHeight = 66;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.animationsNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
    }
    
    cell.textLabel.text = self.animationsNameArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ShowVC *vc = [ShowVC new];
    switch (indexPath.row) {
        case 0:
            [self XT_PresentViewController:vc animatedType:XTSpringFromBottom interact:NO completion:nil];
            break;
            
        case 1:
            [self XT_PresentViewController:vc animatedType:XTSpringFromBottom interact:YES completion:nil];
            break;
            
        case 2:
            [self XT_PresentViewController:vc animatedType:XTRoundExpand interact:NO completion:nil];
            break;
            
        case 3:
            [self XT_PresentViewController:vc animatedType:XTRoundExpand interact:YES completion:nil];
            break;
            
        case 4:
            [self XT_PresentViewController:vc animatedType:XTCardSpringFromBottom interact:NO completion:nil];
            break;
            
        case 5:
            [self XT_PresentViewController:vc animatedType:XTCardSpringFromBottom interact:YES completion:nil];
            break;
            
        case 6:
            [self.navigationController XT_PushViewController:vc animatedType:XTSpringFromRight interact:YES];
            break;
            
        case 7:
            [self.navigationController XT_PushViewController:vc animatedType:XTRoundExpand interact:YES];
            break;
            
        case 8:
            [self.navigationController XT_PushViewController:vc animatedType:XTCubeRotateFromRight interact:YES];
            break;
            
        case 9:
            [self XT_PresentViewController:vc animatedType:XTCubeRotateFromTop interact:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;

}

@end
