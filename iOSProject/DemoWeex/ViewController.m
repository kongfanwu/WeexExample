//
//  ViewController.m
//  DemoWeex
//
//  Created by KFW on 2018/9/3.
//  Copyright © 2018年 KFW. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import <WeexSDK/WXEventModuleProtocol.h>
#import "FWEvent.h"
#import "FWTestViewController.h"
#import "HomeViewController.h"
#import "DKWXBaseViewController.h"
#import "DKWXViewController.h"

@interface ViewController () <WXEventModuleProtocol>
@property(nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
/** <##> */
@property (nonatomic, strong) DKWXBaseViewController *homeVC;
@end

@implementation ViewController
- (void)dealloc {
    [_instance destroyInstance];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor redColor] size:CGSizeMake(self.navigationController.navigationBar.frame.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:241/255.f green:111/255.f blue:66/255.f alpha:1];
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBarHidden = YES;
    
    
//    self.navigationController.extendedLayoutIncludesOpaqueBars = YES;
//    self.navigationController.navigationBar.translucent = NO;
    
    
//    _instance = [[WXSDKInstance alloc] init];
//    _instance.viewController = self;
//    _instance.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
////    _instance.frame = self.view.bounds;
//
//    __weak typeof(self) weakSelf = self;
//    _instance.onCreate = ^(UIView *view) {
//        [weakSelf.weexView removeFromSuperview];
//        weakSelf.weexView = view;
//        [weakSelf.view addSubview:weakSelf.weexView];
//    };
//
//    _instance.onFailed = ^(NSError *error) {
//        //process failure
//    };
//
//    _instance.renderFinish = ^ (UIView *view) {
//        //process renderFinish
//    };
//
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/components/DKLogin" withExtension:@"js"];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/index" withExtension:@"js"];
//    [_instance renderWithURL:url options:nil data:nil];
    
    [self performSelector:@selector(a) withObject:nil afterDelay:1];
}



- (void)a {
    
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dist/components/HelloWorld" withExtension:@"js"];
    DKWXBaseViewController *homeVC = [[DKWXBaseViewController alloc] initWithSourceURL:url];
    self.homeVC = homeVC;
    homeVC.showStatusBarBackground = NO;
    __weak typeof(self) _self = self;
    [homeVC renderWeexViewComplete:^{
        __strong typeof(_self) self = _self;
        [self.navigationController pushViewController:homeVC animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.homeVC postParam:@{@"key":@"value"}];
        });
    }];
    
//    __weak typeof(self) _self = self;
//    DKWXViewController *vc = [[DKWXViewController alloc] initWithUrl:url];
//    [vc createWxInstanceComplete:^{
//        __strong typeof(_self) self = _self;
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
