//
//  AppDelegate.m
//  UMengDemo
//
//  Created by San Zhang on 3/7/17.
//  Copyright © 2017 UMeng. All rights reserved.
//

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMShare/UMShare.h>
#import <UMPush/UMessage.h>
#import <UMErrorCatch/UMErrorCatch.h>
#import <UserNotifications/UserNotifications.h>


//Demo viewcontroller
#import "UMSRootViewController.h"
#import "UMessageViewController.h"
#import "UMAnalyticsViewController.h"

#import "AppDelegate.h"

#define UMENG_APPKEY @"58edd022f29d9826f000139e"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 重要：友盟的Analytics，Push和Share三个产品已采用组件化形式集成并统一初始化，开发者可自由选择所需组件，各组件只需要配置各自相关设置即可。
    // 注释中标注required为必需保留设置，标注optinal表示可选设置。
    
    // init all components of umeng
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置对发送的日志加密传输
#ifdef UM_Swift
    [UMCommonSwiftInterface setLogEnabledWithBFlag:YES];
    [UMCommonSwiftInterface initWithAppkeyWithAppKey:UMENG_APPKEY channel:@"App Store"];
#else
    [UMConfigure setLogEnabled:YES];    // debug: only for console log, must be remove in release version
    [UMConfigure initWithAppkey:UMENG_APPKEY channel:@"App Store"]; // required
#endif
    //错误分析的库必须加在UMConfigure initWithAppkey，否则没法兼容UApp的excetion和singal的兼容
    //调试模式此函数不起作用
    [UMErrorCatch initErrorCatch];
    // Analytics's setting
//    [MobClick setAppVersion:XcodeAppVersion];   // optional:
//  [MobClick setScenarioType:E_UM_GAME];       // optional: 仅适用于游戏场景，应用统计不用设置
    
    
    // Share's setting
    [self setupUSharePlatforms];   // required: setting platforms on demand
    [self setupUShareSettings];
    
    // Push's basic setting
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
#ifdef UM_Swift
    [UMessageSwiftInterface registerForRemoteNotificationsWithLaunchOptionsWithLaunchOptions:launchOptions entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
#else
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
#endif
    
    // optional: 若需要使用Push的高级功能，请参考如下函数实现。
    //[self setupPushAdvanceFunctionWithLaunchOptions:launchOptions];
    
    
    
    
    // Create demo window and controller
    [self createDemoViewController];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#ifdef UM_Swift
    [UMessageSwiftInterface setAutoAlertWithValue:NO];
    [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
#else
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
#endif
    
//    self.userInfo = userInfo;
//    //定制自定的的弹出框
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
//                                                            message:@"Test On ApplicationStateActive"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//
//        [alertView show];
//
//    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
#ifdef UM_Swift
        [UMessageSwiftInterface setAutoAlertWithValue:NO];
        [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
#else
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
#endif
        
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
#ifdef UM_Swift
        [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
#else
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
#endif
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)setupUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)setupUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 钉钉的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
    
    
    /* 设置易信的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置点点虫（原来往）的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置领英的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    
    /* 设置Twitter的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    
    /* 设置Facebook的appKey和UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:nil];
    
    /* 设置Pinterest的appKey */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    
    /* dropbox的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    
    /* vk的appkey */
    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}

// Push 高级功能设置，如果使用"交互式"的通知(iOS 8.0 and later)，请参考下面函数注释部分的代码。
- (void)setupPushAdvanceFunctionWithLaunchOptions:(NSDictionary *_Nullable)launchOptions
{
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
//    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
//    
//    if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10))
//    {
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"打开应用";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"忽略";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
//        actionCategory1.identifier = @"category1";//这组动作的唯一标示
//        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
//        entity.categories=categories;
//    }
//    
//    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
//    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10)
//    {
//        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
//        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
//        
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
//        entity.categories=categories;
//    }
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//        }else
//        {
//        }
//    }];
}


// demo viewconroller create.
-(void)createDemoViewController
{
    //1.创建标签控制器
    UITabBarController *tabController = [[UITabBarController alloc]init];
    
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.f/255.f green:134.f/255.f blue:220.f/255.f alpha:1.f];
    
    UIOffset offset;
    offset.horizontal = 0.0;
    offset.vertical = -15.0;
    
    //2.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //3.设置rootViewController
    self.window.rootViewController = tabController;
    
    //4 设置Analytics的界面
    //4.1设置Analytics的界面
    UIViewController *analyticsVC=[[UMAnalyticsViewController alloc]init];
    analyticsVC.view.backgroundColor=[UIColor whiteColor];
    analyticsVC.tabBarItem.title=@"Analytics";
    [analyticsVC.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [analyticsVC.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    analyticsVC.tabBarItem.titlePositionAdjustment = offset;
    analyticsVC.tabBarItem.tag = 1;
    //analyticsVC.tabBarItem.image=[UIImage imageNamed:@"xxx"];
    
    //4.2设置UShare的界面
    UINavigationController *ushareVC = [[UINavigationController alloc] initWithRootViewController:[UMSRootViewController new]];
    ushareVC.tabBarItem.title=@"UShare";
    [ushareVC.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [ushareVC.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    ushareVC.tabBarItem.titlePositionAdjustment = offset;
    ushareVC.tabBarItem.tag = 2;
    //ushareVC.tabBarItem.image=[UIImage imageNamed:@"xxx"];
    
    
    //4.3设置UPush的界面
    UMessageViewController *pushVC = [[UMessageViewController alloc]init];
    pushVC.tabBarItem.title=@"Push";
    [pushVC.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [pushVC.tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    pushVC.tabBarItem.titlePositionAdjustment = offset;
    pushVC.tabBarItem.tag = 3;
    //pushVC.tabBarItem.image=[UIImage imageNamed:@"XXX"];
    
    //5.创建tabController的内嵌viewControllers
    tabController.viewControllers=@[analyticsVC,ushareVC,pushVC];
    
    //6.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
}

@end
