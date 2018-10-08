//
//  DKWXViewController.m
//  DemoWeex
//
//  Created by KFW on 2018/9/27.
//  Copyright © 2018 KFW. All rights reserved.
//

#import "DKWXViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import <WeexSDK/WXEventModuleProtocol.h>

@interface DKWXViewController () <WXEventModuleProtocol>
@property(nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
/** <#type#> */
@property (nonatomic, copy) Complete complete;
/** <##> */
@property (nonatomic, strong) NSURL *url;
@end

@implementation DKWXViewController

- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.url = url;
        self.showStatusBarBackground = YES;
        self.showNavigationBar = YES;
    }
    return self;
}



- (void)createWxInstanceComplete:(Complete)complete{
    self.complete = complete;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = CGRectMake(0, 20, size.width, size.height - 20);
    //    _instance.frame = self.view.bounds;
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        if (weakSelf.complete) weakSelf.complete();
    };
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/components/DKLogin" withExtension:@"js"];
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/index" withExtension:@"js"];
    [_instance renderWithURL:self.url options:nil data:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    if (self.showStatusBarBackground) {
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, rectStatus.size.height)];
        statusBarView.backgroundColor = [UIColor colorWithRed:241/255.f green:111/255.f blue:66/255.f alpha:1];
        [self.view addSubview:statusBarView];
        
        if (self.showNavigationBar && self.navigationController.navigationBar) {
            CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
            UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarView.frame.size.height, self.view.bounds.size.width, rectOfNavigationbar.size.height + 4)];
            navBarView.backgroundColor = [UIColor colorWithRed:241/255.f green:111/255.f blue:66/255.f alpha:1];
            [self.view addSubview:navBarView];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



@end
