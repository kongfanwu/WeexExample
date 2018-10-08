//
//  HomeViewController.m
//  DemoWeex
//
//  Created by KFW on 2018/9/25.
//  Copyright © 2018 KFW. All rights reserved.
//

#import "HomeViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface HomeViewController ()
@property(nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
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
    };
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/components/Home" withExtension:@"js"];
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/index" withExtension:@"js"];
    [_instance renderWithURL:url options:nil data:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
