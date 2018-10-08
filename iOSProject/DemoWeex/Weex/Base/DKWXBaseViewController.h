//
//  DKWXBaseViewController.h
//  DemoWeex
//
//  Created by KFW on 2018/9/25.
//  Copyright © 2018 KFW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXSDKInstance.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DKWXComplete)(void);

@interface DKWXBaseViewController : UIViewController <UIGestureRecognizerDelegate>

/** 是否显示状态栏背景 默认yes */
@property (nonatomic) BOOL showStatusBarBackground;
/** 是否显示假象导航 默认yes */
@property (nonatomic) BOOL showNavigationBar;
// weex 实例
@property (nonatomic, strong, readonly) WXSDKInstance *instance;
/** 当前js文件名 */
@property (nonatomic, copy, readonly) NSString *pageName;
/** 接收weex参数 */
@property (nonatomic, strong) NSDictionary *cacheParam;

/**
 * @abstract initializes the viewcontroller with bundle url.
 *
 * @param sourceURL The url of bundle rendered to a weex view.
 *
 * @return a object the class of WXBaseViewController.
 *
 */
- (instancetype)initWithSourceURL:(NSURL *)sourceURL;

/**
 初始化weex view

 @param complete 成功后的回调，最好这里做 push 操作。防止push过去在渲染js闪烁效果
 */
- (void)renderWeexViewComplete:(DKWXComplete)complete;

/**
 * @abstract refreshes the weex view in controller.
 */
- (void)refreshWeex;

/**
 发送参数给weex
 
 @param param 参数
 */
- (void)postParam:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
