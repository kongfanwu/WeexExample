//
//  FWEvent.m
//  DemoWeex
//
//  Created by KFW on 2018/9/4.
//  Copyright © 2018年 KFW. All rights reserved.
//

#import "FWEvent.h"

@implementation FWEvent

// 暴露出需要透出到 JavaScript 调用的方法
WX_EXPORT_METHOD(@selector(printLog:callback:))
- (void)printLog:(NSString *)text callback:(WXModuleKeepAliveCallback)callback {
    NSLog(@"text:%@", text);
    callback(@"callback回调", NO);
}

WX_EXPORT_METHOD(@selector(callback:))
- (void)callback:(WXModuleKeepAliveCallback)callback {
    callback(@"callback", NO);
}

@end
