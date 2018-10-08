//
//  FWEvent.h
//  DemoWeex
//
//  Created by KFW on 2018/9/4.
//  Copyright © 2018年 KFW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXModuleProtocol.h"
#import <WeexSDK/WeexSDK.h>

@interface FWEvent : NSObject <WXModuleProtocol>

- (void)printLog:(NSString *)text callback:(WXModuleKeepAliveCallback)callback;
- (void)callback:(WXModuleKeepAliveCallback)callback;

@end
