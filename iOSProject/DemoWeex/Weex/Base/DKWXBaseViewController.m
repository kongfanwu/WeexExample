//
//  DKWXBaseViewController.m
//  DemoWeex
//
//  Created by KFW on 2018/9/25.
//  Copyright © 2018 KFW. All rights reserved.
//

#import "DKWXBaseViewController.h"

#import "WXBaseViewController.h"
#import "WXRootViewController.h"
//#import "WXSDKInstance_private.h"
#import "WXSDKEngine.h"
#import "WXSDKManager.h"
#import "WXUtility.h"
#import "WXPrerenderManager.h"
#import "WXMonitor.h"

@interface DKWXBaseViewController ()
@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, copy) DKWXComplete complete;
/** 当前js文件名 */
@property (nonatomic, copy) NSString *pageName;
@end

@implementation DKWXBaseViewController

- (void)dealloc
{
    [_instance destroyInstance];
    [self _removeObservers];
}

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    if ((self = [super init])) {
        self.sourceURL = sourceURL;
        self.hidesBottomBarWhenPushed = YES;
        self.showStatusBarBackground = YES;
        self.showNavigationBar = YES;
        
        self.pageName = [self pageNameFromUrl:self.sourceURL];
        
        [self _addObservers];
    }
    return self;
}

/**
 *  After setting the navbar hidden status , this function will be called automatically. In this function, we
 *  set the height of mainView equal to screen height, because there is something wrong with the layout of
 *  page content.
 */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ([self.navigationController isKindOfClass:[WXRootViewController class]]) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}

/**
 *  We assume that the initial state of viewController's navigtionBar is hidden.  By setting the attribute of
 *  'dataRole' equal to 'navbar', the navigationBar hidden will be NO.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.showStatusBarBackground) {
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, rectStatus.size.height)];
        statusBarView.backgroundColor = [UIColor colorWithRed:241/255.f green:111/255.f blue:66/255.f alpha:1];
        [self.view addSubview:statusBarView];
        
        if (self.showNavigationBar && self.navigationController.navigationBar) {
            CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
            UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarView.frame.size.height, self.view.bounds.size.width, rectOfNavigationbar.size.height + 4)];
            navBarView.backgroundColor = [UIColor colorWithRed:241/255.f green:111/255.f blue:66/255.f alpha:1];
            [self.view addSubview:navBarView];
        }
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self _renderWithURL:_sourceURL];
    if ([self.navigationController isKindOfClass:[WXRootViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _updateInstanceState:WeexInstanceAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self _updateInstanceState:WeexInstanceDisappear];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets safeArea = ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = self.view.safeAreaInsets;} else {i = UIEdgeInsetsMake(20, 0, 0, 0);} i;});
    _instance.frame = CGRectMake(0, safeArea.top, self.view.frame.size.width, self.view.frame.size.height - safeArea.top - safeArea.bottom);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self _updateInstanceState:WeexInstanceMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWeex
{
    [self _renderWithURL:_sourceURL];
}


/**
 发送参数给weex

 @param param 参数
 */
- (void)postParam:(NSDictionary *)param {
    [self.instance fireGlobalEvent:@"paramEvent" params:param];
}

/**
 初始化weex view
 
 @param complete 成功后的回调，最好这里做 push 操作。防止push过去在渲染js闪烁效果
 */
- (void)renderWeexViewComplete:(DKWXComplete)complete {
    self.complete = complete;
    [self _renderWithURL:_sourceURL];
}

- (void)addEdgePop
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)_renderWithURL:(NSURL *)sourceURL
{
    if (!sourceURL) {
        return;
    }
    
    [_instance destroyInstance];
    if([WXPrerenderManager isTaskReady:[self.sourceURL absoluteString]]){
        _instance = [WXPrerenderManager instanceFromUrl:self.sourceURL.absoluteString];
    }
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//    34
    _instance = [[WXSDKInstance alloc] init];
    //    _instance.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    _instance.frame = CGRectMake(0, rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.height - rectStatus.size.height);
    _instance.pageObject = self;
    _instance.pageName = sourceURL.absoluteString;
    _instance.viewController = self;
    
    NSString *newURL = nil;
    
    if ([sourceURL.absoluteString rangeOfString:@"?"].location != NSNotFound) {
        newURL = [NSString stringWithFormat:@"%@&random=%d", sourceURL.absoluteString, arc4random()];
    } else {
        newURL = [NSString stringWithFormat:@"%@?random=%d", sourceURL.absoluteString, arc4random()];
    }
    [_instance renderWithURL:[NSURL URLWithString:newURL] options:@{@"bundleUrl":sourceURL.absoluteString} data:nil];
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        
    };
    
    _instance.renderFinish = ^(UIView *view) {
        [weakSelf _updateInstanceState:WeexInstanceAppear];
        if (weakSelf.complete) weakSelf.complete();
    };
    
    if([WXPrerenderManager isTaskReady:[self.sourceURL absoluteString]]){
        WX_MONITOR_INSTANCE_PERF_START(WXPTJSDownload, _instance);
        WX_MONITOR_INSTANCE_PERF_END(WXPTJSDownload, _instance);
        WX_MONITOR_INSTANCE_PERF_START(WXPTFirstScreenRender, _instance);
        WX_MONITOR_INSTANCE_PERF_START(WXPTAllRender, _instance);
        [WXPrerenderManager renderFromCache:[self.sourceURL absoluteString]];
        return;
    }
}

- (void)_updateInstanceState:(WXState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;
        
        if (state == WeexInstanceAppear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        } else if (state == WeexInstanceDisappear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}

- (void)_appStateDidChange:(NSNotification *)notify
{
    if ([notify.name isEqualToString:@"UIApplicationDidBecomeActiveNotification"]) {
        [self _updateInstanceState:WeexInstanceForeground];
    } else if([notify.name isEqualToString:@"UIApplicationDidEnterBackgroundNotification"]) {
        [self _updateInstanceState:WeexInstanceBackground]; ;
    }
}

- (void)_addObservers
{
    for (NSString *name in @[UIApplicationDidBecomeActiveNotification,
                             UIApplicationDidEnterBackgroundNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_appStateDidChange:)
                                                     name:name
                                                   object:nil];
    }
}

- (void)_removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 获取js文件名

 @param url url
 @return pageName
 */
- (NSString *)pageNameFromUrl:(NSURL *)url {
    NSString *urlLastPath = url.absoluteString;
    NSArray *pathArray = [urlLastPath componentsSeparatedByString:@"/"];
    if (pathArray.count <= 0) {
        return nil;
    }
    
    NSArray *pathArray2 = [pathArray.lastObject componentsSeparatedByString:@"."];
    if (pathArray2.count <= 0) {
        return nil;
    }
    return pathArray2.firstObject;
}

@end
