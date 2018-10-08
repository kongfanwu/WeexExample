//
//  DKWXNavigation.m
//  DemoWeex
//
//  Created by KFW on 2018/9/5.
//  Copyright © 2018年 KFW. All rights reserved.
//

#import "DKWXNavigation.h"
#import "DKWXBaseViewController.h"

@implementation DKWXNavigation

- (NSString *)urlLastPath:(NSString *)url {
    NSRange range = [url rangeOfString:@"dist"];
    if (range.length > 0 && range.location != NSNotFound) {
        NSString *lastPath = [url substringFromIndex:range.location];
        NSArray *lastPathArray = [lastPath componentsSeparatedByString:@"."];
        if (lastPathArray.count == 2) {
            return lastPathArray.firstObject;
        }
        return nil;
    }
    return nil;
}

- (void)pushViewControllerWithParam:(NSDictionary *)param
                         completion:(WXNavigationResultBlock)block
                      withContainer:(UIViewController *)container {
    NSLog(@"pushViewControllerWithParam");
    NSString *urlLastPath = [self urlLastPath:param[@"url"]];
    NSURL *url = [[NSBundle mainBundle] URLForResource:urlLastPath withExtension:@"js"];
    DKWXBaseViewController *homeVC = [[DKWXBaseViewController alloc] initWithSourceURL:url];
    // 上一页传值给下一页
    if ([container isKindOfClass:[DKWXBaseViewController class]]) {
        homeVC.cacheParam = ((DKWXBaseViewController *)container).cacheParam;
    }
    
    [homeVC renderWeexViewComplete:^{
        [container.navigationController pushViewController:homeVC animated:YES];
    }];
}

/**
 * @abstract Pops the top view controller from the navigation stack.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)popViewControllerWithParam:(NSDictionary *)param
                        completion:(WXNavigationResultBlock)block
                     withContainer:(UIViewController *)container {
    NSLog(@"popViewControllerWithParam");
    // 下一页传值给上一页
    if ([container.navigationController.viewControllers.lastObject isKindOfClass:[DKWXBaseViewController class]] && [container isKindOfClass:[DKWXBaseViewController class]]) {
        ((DKWXBaseViewController *)container.navigationController.viewControllers.lastObject).cacheParam = ((DKWXBaseViewController *)container).cacheParam;
        
    }
    
    [container.navigationController popViewControllerAnimated:YES];
    // 显示导航栏
    if (![container.navigationController.topViewController isKindOfClass:[DKWXBaseViewController class]]) {
        container.navigationController.navigationBarHidden = NO;
    }
}

@end
