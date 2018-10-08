//
//  DKUtils.m
//  DemoWeex
//
//  Created by KFW on 2018/9/28.
//  Copyright © 2018 KFW. All rights reserved.
//

#import "DKUtils.h"

@implementation DKUtils

WX_EXPORT_METHOD(@selector(greeting:))
- (void)greeting:(WXModuleKeepAliveCallback)callback {
    if (callback) callback(@"guoxinhang_logo.png", NO);
}

@end
