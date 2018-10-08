//
//  DKWXViewController.h
//  DemoWeex
//
//  Created by KFW on 2018/9/27.
//  Copyright © 2018 KFW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Complete)(void);

@interface DKWXViewController : UIViewController

/** 是否显示状态栏背景 默认yes */
@property (nonatomic) BOOL showStatusBarBackground;
/** 是否显示假象导航 默认yes */
@property (nonatomic) BOOL showNavigationBar;

- (instancetype)initWithUrl:(NSURL *)url;
- (void)createWxInstanceComplete:(Complete)complete;

@end

NS_ASSUME_NONNULL_END
