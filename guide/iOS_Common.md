

# SDK导入

友盟组件化SDKs当前只支持手动集成，cocoapod集成方式后续会推出。



## 手动集成

手动集成步骤如下：

1. 选择SDK功能组件并下载，解压.zip文件得到相应组件包(例如：UMCommon.framework，UMAnalytics.framework， UMPush.framework等)。

2. Xcode`File` —> `Add Files to "Your Project"`，在弹出Panel选中所下载组件包－>`Add`。（注：选中“Copy items if needed”）

3. 添加依赖库，在项目设置`target` -> 选项卡`General` ->` Linked Frameworks and Libraries`

     `CoreTelephony.framework` 获取运营商标识 

     `libz.tbd`  数据压缩

     `libsqlite.tbd`  数据缓存

     `SystemConfiguration.framework `  判断网络状态

如下：

![Screen Shot 2017-03-07 at 6.25.12 PM](/Users/sanzhang/Desktop/Screen Shot 2017-03-07 at 6.25.12 PM.png)



## 其它功能库

- 地理位置信息：在工程plist文件中添加如下配置：

```plist
<key>NSLocationAlwaysUsageDescription</key>
<string>location obtain</string>
```

> 最终需要用户授权才可获得位置信息



## 升级旧版SDK到组件化SDK

如果您的APP已经导入过【友盟+】应用统计，push，分享SDKs，升级请按下述步骤：

1. 先将原友盟SDK删除，包括libMobClickLibrary.a 和MobClick.h文件或UMMobClick.framework等。
2. 按照手动集成方式重新集成。
3. 使用新的SDK初始化代码（见下节）。

注 ：升级SDK，不会影响【友盟+】应用统计的正常使用。



# SDKs初始化

在工程的 `AppDelegate.m` 文件中引入相关组件头文件 ，且在 `application:didFinishLaunchingWithOptions:` 方法中添加如下代码：

```objective-c
#import <UMCommon/UMCommon.h>			// 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>		// 统计组件
#import <UMSocialCore/UMSocialCore.h>	 // 分享组件
#import <UMPush/UMessage.h>				// Push组件
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库 
/* 开发者可根据功能需要引入相应组件头文件，并导入相应组件库*/
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
  
  	// 配置友盟SDK产品并并统一初始化
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO. 
	// [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    [UMConfigure initWithAppkey:@"Your appkey" channel:@"App Store"]; 
  	/* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
  
  
    // 统计组件配置
  	// [MobClick setScenarioType:E_UM_GAME];  // optional: 仅适用于游戏场景，应用统计不用设置
	[MobClick setAppVersion:XcodeAppVersion]; // optional: 设置使用shortversion，默认为buildversion
  
  
    // Push组件基本功能配置
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
          // 用户选择了接收Push消息
        }else{
          // 用户拒绝接收Push消息
        }
    }];
  
  
  // 请参考「Share详细介绍-初始化第三方平台」
  // 分享组件配置，因为share模块配置可选三方平台较多，代码基本跟原版一样，也可下载demo查看
    [self configUSharePlatforms];   // required: setting platforms on demand
  
  // ...
}
```

> 完成上述步骤，友盟产品的初始化就完成了，对于各组件产品的其它设置或高级功能请查看具体组件详细内容。



## IDFA说明

从组件化产品开始，友盟SDK默认采集idfa标识，用来更准确的分析核对数据。对于应用本身没有获取idfa的情况，建议将应用提交至AppStore时按如下方式配置：（以避免被苹果以“应用不含广告功能，但获取了广告标示符IDFA”的而拒绝其上架。）









# 技术支持

- [友盟开发者社区](http://bbs.umeng.com/)
- 联系客服：[**联系客服](https://service.taobao.com/support/minerva/robot.htm?spm=0.0.0.0.Q6TuTf&sourceId=1523174451)
- Email：support@umeng.com

☺为了能够尽快响应您的反馈，请提供您的appkey及console中的详细出错日志，您所提供的内容越详细越有助于我们帮您解决问题。常见问题请阅读友盟论坛中[统计SDK常见问题索引](http://bbs.umeng.com/thread-5421-1-1.html)。
