//
//  DKParamEvent.m
//  DemoWeex
//
//  Created by KFW on 2018/10/8.
//  Copyright © 2018 KFW. All rights reserved.
//

#import "DKParamEvent.h"
#import "DKWXBaseViewController.h"

@implementation DKParamEvent

WX_EXPORT_METHOD(@selector(param:callback:))
- (void)param:(NSDictionary *)param callback:(WXModuleKeepAliveCallback)callback {
    NSLog(@"%@", param);
    // 寻找当前实例并设置param
    NSString *pageName = param[@"pageName"];
    if ([UIApplication.sharedApplication.delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        NSArray *vcs = ((UINavigationController *)UIApplication.sharedApplication.delegate.window.rootViewController).viewControllers;
        [vcs enumerateObjectsUsingBlock:^(UIViewController *_Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([vc isKindOfClass:[DKWXBaseViewController class]]) {
                if ([((DKWXBaseViewController *)vc).pageName isEqualToString:pageName]) {
                    ((DKWXBaseViewController *)vc).cacheParam = param[@"data"];
                    *stop = YES;
                }
            }
        }];
    }
    
    if (callback) callback(@"1", NO);
}

@end
