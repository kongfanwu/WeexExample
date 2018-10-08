//
//  DKWeexEvent.m
//  DemoWeex
//
//  Created by KFW on 2018/9/5.
//  Copyright © 2018年 KFW. All rights reserved.
//

#import "DKWeexEvent.h"

@implementation DKWeexEvent

WX_EXPORT_METHOD(@selector(feedBackText:callback:))
- (void)feedBackText:(NSString *)text callback:(WXModuleKeepAliveCallback)callback {
    NSLog(@"%@", text);
    if (callback) callback(@"反馈成功", NO);
}

WX_EXPORT_METHOD(@selector(loginLogoNameCallback:))
- (void)loginLogoNameCallback:(WXModuleKeepAliveCallback)callback {
    if (callback) callback(@"guoxinhang_logo.png", NO);
}

WX_EXPORT_METHOD(@selector(getVersionCallback:))
- (void)getVersionCallback:(WXModuleKeepAliveCallback)callback {
    if (callback) callback(@"1.1.9", NO);
}

WX_EXPORT_METHOD(@selector(loginUserInfo:callback:))
- (void)loginUserInfo:(NSDictionary *)userInfo callback:(WXModuleKeepAliveCallback)callback {
    /*
     userName = 222;
     userpwd = ghy;
     */
    NSLog(@"%@", userInfo);
    
    if (callback) callback(@"1", NO);
}


@end
