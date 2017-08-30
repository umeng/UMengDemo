

# iOS SDK集成



友盟SDKs支持两种集成方式，

### CocoaPods 自动集成 （推荐）

使用自动集成方式可最大程度简化集成过程，避免工程手动添加配置项，并可及时更新到最新稳定版本。具体步骤如下:

1. 在工程Podfile文件中，按功能添加相应组件，例如：

   ``` pod &#39;UMCommon&#39;
   pod 'UMCommon'	   友盟公共组件，必选
   pod 'UMAnalytics'  统计功能

   #...  后续会加入 Push推送，Share分享等组件
   ```

> U-Share组件请参考「Share详细介绍-通过Cocoapods集成」。

2. 在terminal下执行如下命令：

     `pod update`

3. 完成上一步后，直接进入`二.初始化代码`



### 手动集成

1. 选择SDK功能组件并下载，解压.zip文件得到相应组件包(例如：UMCommon.framework，UMAnalytics.framework， UMPush.framework等)。

2. Xcode`File` —> `Add Files to "Your Project"`，在弹出Panel选中所下载组件包－>`Add`。（注：选中“Copy items if needed”）

3. 添加依赖库，在项目设置`target` -> 选项卡`General` ->` Linked Frameworks and Libraries`

     `CoreTelephony.framework` 获取运营商标识 

     `libz.tbd`  数据压缩

     `libsqlite.tbd`  数据缓存

     `SystemConfiguration.framework`  判断网络状态

如下：

![Screen Shot 2017-03-07 at 6.25.12 PM](/Users/sanzhang/Desktop/Screen Shot 2017-03-07 at 6.25.12 PM.png)



### 其它功能库

- 地理位置信息：在工程plist文件中添加如下配置：

```plist
<key>NSLocationAlwaysUsageDescription</key>
<string>location obtain</string>
```

> 最终需要用户授权才可获得位置信息



### 注：原【友盟+】SDK升级到组件化SDK

如果您的APP已经导入过【友盟+】应用统计，push，分享SDKs，升级请按下述步骤：

1. 先将原友盟SDK删除，包括libMobClickLibrary.a 和MobClick.h文件或UMMobClick.framework等。
2. 按照手动集成方式重新集成。
3. 使用新的SDK初始化代码（见下节）。

注 ：升级SDK，不会影响【友盟+】应用统计的正常使用。



## SDKs初始化

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
  // 分享组件配置，因为share模块配置可选三方平台较多，基本代码跟原版一样，也可下载demo查看
    [self configUSharePlatforms];   // required: setting platforms on demand
  
  // ...
}
```

> 完成上述步骤，友盟产品的初始化就完成了，对于各组件产品的其它设置或高级功能请查看具体组件详细内容。





## 统计详细功能



### 页面统计

在ViewController类的`viewWillAppear:` 和 `viewWillDisappear:`中配对调用如下方法：

```objective-c
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[MobClick beginLogPageView:@"Pagename"]; //("Pagename"为页面名称，可自定义)
}
```

```objective-c
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	[MobClick endLogPageView:@"Pagename"];
}
```

**页面统计的常见问题可参考友盟开发者社区：** [页面访问路径中你需要了解的知识点](http://bbs.umeng.com/thread-6281-1-1.html) ，[页面访问路径常见问题详解](http://bbs.umeng.com/thread-12608-1-1.html)



### 错误收集

统计SDK默认是开启Crash收集机制的，如果开发者需要关闭Crash收集机制则设置如下：

```objective-c
[MobClick setCrashReportEnabled:NO];   // 关闭Crash收集
```

[如何定位错误？](http://dev.umeng.com/analytics/reports/errors#2)

**错误统计的常见问题参见友盟开发者社区：** [友盟错误分析常见问题汇总](http://bbs.umeng.com/thread-6310-1-1.html)



### 账号统计

友盟在统计用户时以设备为标准，若需要统计应用自身的账号，下述两种API任选其一接口：

```objective-c
// PUID：用户账号ID.长度小于64字节
// Provider：账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节 ; 

[MobClick profileSignInWithPUID:@"UserID"];
[MobClick profileSignInWithPUID:@"UserID" provider:@"WB"];
```

Signoff调用后，不再发送账号内容。

```
[MobClick profileSignOff];
```



### 自定义事件

> 使用自定义事件功能请先登陆[友盟官网](http://www.umeng.com/)，在“统计分析->设置->事件”（子账户由于权限限制可能无法看到“设置”选项，请联系主帐号开通权限。）页面中添加相应的事件id（事件id可用英文或数字，不要使用中文和特殊字符且不能使用英文句号“.”您可以使用下划线“_”），然后服务器才会对相应的事件请求进行处理。
>
> id， ts， du是保留字段，不能作为event id及key的名称

普通事件

```objective-c
[MobClick event:@"eventID"];

// [MobClick event:@"eventID" acc:2];
```



事件属性

```objective-c
// 例如下面代码pruchase为事件ID，而type，quantity为属性信息。
NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
[MobClick event:@"purchase" attributes:dict];    

// [MobClick event:@"pay" attributes:@{@"book" : @"Swift Fundamentals"} counter:110];
```

> 注：属性中的key－value必须为String类型, 每个应用至多添加500个自定义事件，key不能超过10个.

**自定义事件使用中的问题请参见友盟开发者社区：** [自定义事件常见问题](http://bbs.umeng.com/thread-5417-1-1.html)，[关于自定义事件的那些事儿](http://bbs.umeng.com/thread-11284-1-1.html)





## 集成测试服务

集成测试是通过收集和展示已注册测试设备发送的日志，来检验SDK集成有效性和完整性的一个服务。 所有由注册设备发送的应用日志将实时地进行展示，您可以方便地查看包括应用版本、渠道名称、自定义事件、页面访问情况等数据，提升集成与调试的工作效率。

> **注**: 使用集成测试的设备，其测试数据不会进入应用正式的统计后台，只在“管理--集成测试--实时日志”里查看

测试过程中在Xcode的console窗口查看日志信息，可以打开日志模式：

```objective-c
[MobClick setLogEnabled:YES]; 
```

使用集成测试服务请点击[集成测试](http://mobile.umeng.com/test_devices?ticket=ST-1450072700rPWK4t4q46xw-qpBXzk)。

集成中可能出现的问题，点击[这里](http://bbs.umeng.com/thread-6383-1-1.html) 。





## Dplus详细功能

使用Dplus功能需要在初始化代码中添加如下：

```objective-c
#import <UMAnalytics/DplusMobClick.h>		// 引入Dplus header file

[MobClick setScenarioType:E_UM_DPLUS];  	// 启用DPlus功能
```



### track事件

> - eventName – 事件名称。 
> - property – 事件的自定义属性（可以包含多对“属性名-属性值”），字典类型。

自定义track事件

```objective-c
// 记录一个dplus事件
[DplusMobClick track:@"pruchase"];

// 记录一个带有属性特征的Dplus事件， 例如以下代码发送了一个名为login的事件，它包含name和age两个自定义属性，其值分别为Tom和23。
[DplusMobClick track:@"login" property:@{@"Tom": @(23)}];
```



#### 标记超级属性

对Dplus的事件，可以设置持久化的超级属性，如果用户具有某些典型特征（例如账号信息），或者需要按照某些特征（例如广告来源）分析用户的行为，那么可通过以下方法为用户标记超级属性：

```objective-c
// 设置超级属性集, 标记超级属性后,该用户后续触发的所有行为事件都将自动包含这些属性；且这些属性存入系统文件，APP重启后仍然存在。
[DplusMobClick registerSuperProperty:@{@"user": @"sanzhang"}];
/*针对同一超级属性，设定的新值会改写旧值。*/
  
// 获取某一个超级属性值
NSString *aSPValue = [DplusMobClick getSuperProperty:@"user"];

// 获取所以超级属性值
NSDictionary *allSPMap = [DplusMobClick getSuperProperties];

// 删除某一个超级属性
[DplusMobClick unregisterSuperProperty:@"user"];

// 删除所有超级属性
[DplusMobClick clearSuperProperties];
```

超级属性会保存在系统存储区，并在用户后续行为事件中，自动包含该属性。这样分析数据时，就可按照“姓名”“年龄”对用户注册及后续行为进行查看和筛选。





## Push详细功能

## 项目设置
### 配置
点击Target------>Build Settings------>other Linker Flags中添加一个-lz
### 引入库文件
增加UserNotifications.framework到项目中。
具体操作如下：点击项目---->TARGET---->Build Phases---->Link Binary with Libraries ---->左侧+号---->搜索UserNotifications---->选中UserNotifications.framework---->点击Add
### 打开推送开关
点击项目---->TARGET---->Capabilities，将这里的Push Notification的开关打开，效果如图所示：
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMTAvMTIvMTZfMDBfMjJfNzg4XzQucG5nIl1d/4.png)
>**注意：一定要打开Push Notification,且两个steps都是正确的，否则会报如下错误:Code=3000 "未找到应用程序的“aps-environment”的授权字符串"**
>

## 初始化代码

在工程的 `AppDelegate.m` 文件中引入相关组件头文件 ，且在 `application:didFinishLaunchingWithOptions:` 方法中添加如下代码：

```objective-c
#import <UMCommon/UMCommon.h>     //友盟公共库
#import <UMPush/UMessage.h>       //友盟推送
#import <UserNotifications/UserNotifications.h>   //iOS10framework

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//设置 AppKey
[UMConfigure initWithAppkey:@"your appkey" channel:@"App Store"];
//for log
[UMConfigure setLogEnabled:YES];

//iOS10接收消息的代理
[UNUserNotificationCenter currentNotificationCenter].delegate=self;

//设置注册的参数，如果不需要自定义的特殊功能可以直接在registerForRemoteNotificationsWithLaunchOptions的Entity传入一个nil.
UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
//友盟推送的注册方法
[UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
if (granted) {
//点击允许
} else {
//点击不允许
}

}];
return YES;
}

```
## 接收通知

### 关闭友盟的弹出框

```objective-c
//关闭友盟自带的弹出框
[UMessage setAutoAlert:NO];

```

### 统计点击数

```objective-c
[UMessage didReceiveRemoteNotification:userInfo];

```
### 添加并运行接收通知与计数代码

```objective-c
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

[UMessage didReceiveRemoteNotification:userInfo];

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
//应用处于前台时的远程推送接受
//关闭U-Push自带的弹出框
[UMessage setAutoAlert:NO];
//必须加这句代码
[UMessage didReceiveRemoteNotification:userInfo];

}else{
//应用处于前台时的本地推送接受
}
//当应用处于前台时提示设置，需要哪个可以设置哪一个
completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
NSDictionary * userInfo = response.notification.request.content.userInfo;
if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//应用处于后台时的远程推送接受
//必须加这句代码
[UMessage didReceiveRemoteNotification:userInfo];

}else{
//应用处于后台时的本地推送接受
}
}

```
> 说明 
如需关闭推送，请使用unregisterForRemoteNotifications，(iOS10此功能存在系统bug,建议不要在iOS10使用。iOS10出现的bug会导致关闭推送后无法打开推送。)
> 至此，消息推送基本功能的集成已经完成。
> 
> 关于iOS如何在接收到推送后打开指定页面，可以看论坛帖子：[iOS如何调转跳转到指定页面](http://bbs.umeng.com/thread-7702-1-1.html)
> 
> 需要 Tag、Alias及自定义事件等请参照 **高级功能**。

## 高级功能
### 自定义推送显示按钮
> 推送消息被下拉、左划以及3D Touch设备的点击，可以执行预先设定好的操作，如确认、取消、快捷回复等。
> 
> 
如iOS10以下的系统效果下图所示：
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMDcvMTkvMTFfMzVfMjhfMTMxX2RlbW9fLnBuZyJdXQ/demo%E4%BF%AE%E6%94%B9%E5%A2%9E%E5%8A%A0.png)
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMDcvMTkvMTFfMzdfMzRfMjQ0X18ucG5nIl1d/%E4%BF%AE%E6%94%B9%E5%A2%9E%E5%8A%A0%E9%80%9A%E7%9F%A5%E6%A0%8F.png)

>如iOS10以上的系统3D Touch设备和非3D Touch设备，具体的效果如下所示。
>
>

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMTMvMTVfMjRfNTBfNDg4XzQuUE5HIl0sWyJwIiwidGh1bWIiLCI0NTB4NDUwPiJdXQ/4.PNG)
![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMTMvMTVfMjRfNTBfNDEwXzMuUE5HIl0sWyJwIiwidGh1bWIiLCI0NTB4NDUwPiJdXQ/3.PNG)

>**注意：使用此功能，设备的系统版本需在iOS8及以上**

### 编写策略代码
```objective-c

iOS10以前的UIUserNotificationAction相关属性
// 行为标识符，用于调用代理方法时识别是哪种行为。
@property (nonatomic, copy, readonly) NSString *identifier;
// 行为名称。
@property (nonatomic, copy, readonly) NSString *title;
// 即行为是否打开APP。
@property (nonatomic, assign, readonly) UIUserNotificationActivationMode activationMode;
// 是否需要解锁。
@property (nonatomic, assign, readonly, getter=isAuthenticationRequired) BOOL authenticationRequired;
// 这个决定按钮显示颜色，YES的话按钮会是红色。
@property (nonatomic, assign, readonly, getter=isDestructive) BOOL destructive;



iOS10的UNNotificationAction相关属性
// The unique identifier for this action.
@property (NS_NONATOMIC_IOSONLY, copy, readonly) NSString *identifier;

// The title to display for this action.
@property (NS_NONATOMIC_IOSONLY, copy, readonly) NSString *title;

// The options configured for this action.
@property (NS_NONATOMIC_IOSONLY, readonly) UNNotificationActionOptions options;

```
### 调用UPush的自定义注册方法
```objective-c
UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
//如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10)) {
UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
action1.identifier = @"action1_identifier";
action1.title=@"打开应用";
action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序

UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
action2.identifier = @"action2_identifier";
action2.title=@"忽略";
action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
action2.destructive = YES;
UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
actionCategory1.identifier = @"category1";//这组动作的唯一标示
[actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
entity.categories=categories;
}
//如果要在iOS10显示交互式的通知，必须注意实现以下代码
if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];

//UNNotificationCategoryOptionNone
//UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
entity.categories=categories;
}
//友盟推送的注册方法
[UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
if (granted) {
//点击允许
} else {
//点击不允许
}

}];

```
### 添加并运行接收通知代码
```objective-c
//iOS10以前接收的方法
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
//这个方法用来做action点击的统计
[UMessage sendClickReportForRemoteNotification:userInfo];
//下面写identifier对各个交互式的按钮进行业务处理
}


//iOS10以后接收的方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
NSDictionary * userInfo = response.notification.request.content.userInfo;
if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
[UMessage didReceiveRemoteNotification:userInfo];
if([response.actionIdentifier isEqualToString:@"*****你定义的action id****"])
{

}else
{


}
//这个方法用来做action点击的统计
[UMessage sendClickReportForRemoteNotification:userInfo];



}else{
//应用处于后台时的本地推送接受
}

}

```
### 在U-Push后台添加推送策略
登录账号并进入U-Push后台[]后，将提醒方式下方的Category ID 设置为需要推送的策略的id，如下图所示：
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMDcvMTkvMTNfMjRfMjlfNzQ0X18ucG5nIl1d/%E8%AE%BE%E7%BD%AE%E6%8F%90%E9%86%92%E6%96%B9%E5%BC%8F.png)
## 使用标签
###添加tag
>示例：将标签“男”绑定至该设备:


```objective-c
[UMessage addTags:@"男"
response:^(id responseObject, NSInteger remain, NSError *error) {
//add your codes
}];

```
>小提示：tag参数既可以是NSString的单个tag，也可以是NSArray,NSSet的tag集合哦！

###删除tag
>示例：将标签"男"从设备绑定中删除:


```objective-c
[UMessage removeTags:@"男"
response:^(id responseObject, NSInteger remain, NSError *error) {
//add your codes            
}];

```
>小提示：tag参数既可以是NSString的单个tag，也可以是NSArray,NSSet的tag集合哦！

###获取tag列表
>示例： 获取tag列表


```objective-c
[UMessage getTags:^(NSSet *responseTags, NSInteger remain, NSError *error) {
//add your codes
}];

```
```
>注意 

>1. 可以为单个tag（NSString）也可以为tag集合（NSArray、NSSet）
>2.  每台设备最多绑定1024个tag，超过1024个，绑定tag不再成功
>3. 单个tag最大允许长度50字节，编码UTF-8，超过长度自动截取


##使用别名
当需要将设备标记为别名时，可用。例如：账户绑定设备。
###添加别名(addAlias)
>示例： 将新浪微博的某用户绑定至设备，老的绑定的设备还在


```objective-c
[UMessage addAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
}];

```
>注意： 
>
>1. type的类型已经默认枚举好平台类型，在UMessage.h最上侧，形如:kUMessageAliasTypeSina
>2. type的类型如果默认的满足不了需求，可以自定义这个字段

###设置别名(setAlias)
>示例： 将新浪微博的某用户绑定至设备,覆盖老的，一一对应


```objective-c
[UMessage setAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
}];

```

###删除别名(removeAlias)
>示例： 将新浪微博的别名绑定删除


```objective-c
[[UMessage removeAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
}];

```
##其他设置

**设置地理位置信息**
```objective-c
[UMessage setLocation:location];

```
**设置是否允许SDK自动清空角标（默认开启）**
```objective-c
[UMessage setBadgeClear:NO];

```
**设置是否允许SDK当应用在前台运行收到Push时弹出Alert框（默认开启）**
```objective-c
[UMessage setAutoAlert:NO];

```
**自定义弹出框后，想补发前台的消息的点击统计**
```objective-c
[UMessage sendClickReportForRemoteNotification:userInfo]

```
##静默推送
>当app没有启动的时候或者被杀掉的时候将无法收到静默推送。

>静默推送必须实现  application:didReceiveRemoteNotification:fetchCompletionHandler:

![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTcvMDIvMjgvMTRfMjFfNTJfNDg2X18ucG5nIl1d/%E9%85%8D%E5%9B%BE.png)

静默推送除badge及自定义字段外，不应该包含其他字段（如果要badge，建议通过本地通知实现）。

如果只实现了application:didReceiveRemoteNotification:方法，没有实现application:didReceiveRemoteNotification:fetchCompletionHandler:将无法在后台是收到静默推送。

```objective-c
{
"appkey":"your appkey",
"production_mode":"false",
"timestamp":1474340669558,
"device_tokens":"your devicetoken",
"type":"unicast",
"payload":{
"aps":{
"content-available" : 1
}   
}
}

```

##测试与调试
###调试步骤
1、确认证书设置正确。参见 iOS 证书设置指南。
2、确认Provisioning Profile配置正确，并已更新
3、在友盟消息推送后台上传正确的 Push 证书
4、启动应用程序，并在选择接受推送通知
5、确认 App 是开启 Push 权限的
6、在网站后台选择对应的Device Token进行推送测试

### 如何获取设备的 DeviceToken
开发环境下：

方法1：在 didRegisterForRemoteNotificationsWithDeviceToken 中添加如下语句

```objective-c
NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
stringByReplacingOccurrencesOfString: @">" withString: @""]
stringByReplacingOccurrencesOfString: @" " withString: @""]);

```
以上方式都可在控制台获取一个长度为64的测试设备的DeviceToken串

生产环境下，用户需要用抓包工具、代理工具等自行获取device_token
##集成帮助
一、IOS为什么获取不到设备的DeviceToken[查看帮助](http://bbs.umeng.com/thread-6028-1-1.html)

二、IOS可以自定义App在前台接受到消息的弹出框么[查看帮助](http://bbs.umeng.com/forum.php?mod=viewthread&tid=6026&page=1&extra=#pid7923)

三、为什么集成完SDK后，App运行没有弹出打开通知的对话框[查看帮助](http://bbs.umeng.com/thread-6025-1-1.html)

四、为什么集成成功后iOS收不到推送通知[查看帮助](http://bbs.umeng.com/forum.php?mod=viewthread&tid=5428&extra=page%3D1%26filter%3Dtypeid%26typeid%3D25)

更多常见问题请点击访问：[友盟消息推送常见问题索引](http://bbs.umeng.com/thread-5911-1-1.html)

如果还有问题，请把您的问题发邮件至msg-support@umeng.com或者联系官网底部云客服系统（在线时间：工作日10：00~18:00）。如需要了解更多信息，请申请加入消息推送官方QQ群：196756762，（需提供友盟appkey），我们会尽快回复您。







## Share详细介绍
+ SDK目录结构
 
```
1. Document     - U-Share SDK文档
2. UMSocialDemo - U-Share SDK Demo（如点选下载）
3. UMSocial     - U-Share SDK核心目录
   UMSocialSDK       - U-Share SDK核心framework
   UMSocialUI        - U-Share 分享UI资源、分享面板framework
   SocialLibraries   - 所选择下载的第三方平台SDK及U-Share链接库
   UMSocialSDKPlugin - SDK需要的依赖插件
```

>> 其中UMSocialSDKPlugin/libUMSocialLog.a 用于生成开发者调试log，集成测试完毕后可将libUMSocialLog.a插件移除。


### 接入U-Share SDK

+ 将U-Share SDK添加到工程   
<img src="http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMjIvMThfMjBfMzdfMjRfNDE0NzQ1MzkwOTJfLnBpY19oZC5qcGciXV0/41474539092_.pic_hd.jpg" width="550" height="330">  

+ 添加项目配置

在Other Linker Flags加入-ObjC ，<label style="color:#FF0000;">注意不要写为-Objc</label> 

<img src="http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMjIvMThfMjBfNTBfNjQ0XzUxNDc0NTM5MjY5Xy5waWNfaGQuanBnIl1d/51474539269_.pic_hd.jpg" width="580" height="150">  

<label style="color:#FF0000;">-ObjC属于链接库必备参数，如果不加此项，会导致库文件无法被正确链接，SDK无法正常运行</label> 

+ 加入依赖系统库

<img src="http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMjkvMTdfMDNfMjdfNjg0X1FRMjAxNjA5MjlfMF8yeC5wbmciXV0/QQ20160929-0@2x.png" width="635" height="320"> 

加入以下系统库：

```
libsqlite3.tbd
CoreGraphics.framework
```

### 添加第三方平台依赖库
根据集成的不同平台加入相关的依赖库，未列出平台则不需添加
添加方式：选中项目Target -> General -> Linked Frameworks and Libraries列表中进行添加

+ 微信(完整版)-精简版无需添加以下依赖库

```
SystemConfiguration.framework
CoreTelephony.framework
libsqlite3.tbd
libc++.tbd
libz.tbd
```

+ QQ(完整版)-精简版无需添加以下依赖库

```
SystemConfiguration.framework
libc++.tbd 
```

+ 新浪微博(完整版)-精简版无需添加以下依赖库

```
SystemConfiguration.framework
CoreTelephony.framework
ImageIO.framework
libsqlite3.tbd
libz.tbd 
```

+ Twitter 

```
CoreData.framework 
```
> Twitter平台加入后需在Twitter目录右键->Add files to "Twitter"->添加TwitterKit.framework/Resources/TwitterKitResources.bundle。

+ 短信

```
MessageUI.framework
```

+ Pinterest

```
SafariServices.framework
```

+ VKontakte

```
CoreGraphics.framework
Security.framework
```



### 通过Cocoapods集成

```
target 'UMSocialDemo' do
    # U-Share SDK UI模块（分享面板，建议添加）
    pod ‘UMengUShare/UI’
    
    # 集成微信(精简版0.2M)
    pod ‘UMengUShare/Social/ReducedWeChat'
    
    # 集成微信(完整版14.4M)
    pod ‘UMengUShare/Social/WeChat'
    
    # 集成QQ(精简版0.5M)
    pod ‘UMengUShare/Social/ReducedQQ'
    
    # 集成QQ(完整版7.6M)
    pod ‘UMengUShare/Social/QQ'
    
    # 集成新浪微博(精简版1M)
    pod ‘UMengUShare/Social/ReducedSina'

    # 集成新浪微博(完整版25.3M)
    pod ‘UMengUShare/Social/Sina'
    
    # 集成Facebook/Messenger
    pod ‘UMengUShare/Social/Facebook'
    
    # 集成Twitter
    pod ‘UMengUShare/Social/Twitter'
    
    # 集成支付宝
    pod ‘UMengUShare/Social/AlipayShare'
    
    # 集成钉钉
    pod ‘UMengUShare/Social/DingDing'
    
    # 集成豆瓣
    pod ‘UMengUShare/Social/Douban'
    
    # 集成人人
    pod ‘UMengUShare/Social/Renren'
    
    # 集成腾讯微博
    pod ‘UMengUShare/Social/TencentWeibo'
    
    # 集成来往(点点虫)
    pod ‘UMengUShare/Social/LaiWang'
    
    # 集成易信
    pod ‘UMengUShare/Social/YiXin'
    
    # 集成领英
    pod ‘UMengUShare/Social/Linkedin'
    
    # 集成Flickr
    pod ‘UMengUShare/Social/Flickr'
    
    # 集成Kakao
    pod ‘UMengUShare/Social/Kakao'
    
    # 集成Tumblr
    pod ‘UMengUShare/Social/Tumblr'
    
    # 集成Pinterest
    pod ‘UMengUShare/Social/Pinterest'
    
    # 集成Instagram
    pod ‘UMengUShare/Social/Instagram'
    
    # 集成Line
    pod ‘UMengUShare/Social/Line'
    
    # 集成WhatsApp
    pod ‘UMengUShare/Social/WhatsApp'

    # 集成有道云笔记
    pod ‘UMengUShare/Social/YouDao'
    
    # 集成印象笔记
    pod ‘UMengUShare/Social/EverNote'
    
    # 集成Google+
    pod ‘UMengUShare/Social/GooglePlus'
    
    # 集成Pocket
    pod ‘UMengUShare/Social/Pocket'
    
    # 集成DropBox
    pod ‘UMengUShare/Social/DropBox'
    
    # 集成VKontakte
    pod ‘UMengUShare/Social/VKontakte'
    
    # 集成邮件
    pod ‘UMengUShare/Social/Email'
    
    # 集成短信
    pod ‘UMengUShare/Social/SMS'
    
    # 加入IDFA获取
    pod ‘UMengUShare/Plugin/IDFA'
end

```

+ 在终端使用pod update命令，更新U-Share SDK

```
$ cd [存放Podfile的项目路径]
$ pod update
```
<label style="color:#FF0000;">不可加入</label> `--no-repo-update` 参数，若添加后仅从本地Cocoapods库中查找SDK，不再更新线上SDK。如果本地存在SDK会直接使用本地SDK版本(不是线上最新版本)，若本地不存在SDK会产生错误。
也不建议使用 `pod install` 命令，这也是从本地SDK库进行安装的命令。

+ 可选，检查U-Share是否更新到本地

使用pod search命令检查U-Share SDK及其最新版本

```
$ pod search UMengUShare
```

> Cocoapods集成遇到问题请参考[更新Cocoapods常见问题](http://dev.umeng.com/social/ios/u-share%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98#7)。

+ Cocoapods版本说明

Cocoapods已经升级到1.0以上版本，下面的集成说明使用1.0版语法，如需参考0.x版语法，仅删除以下代码即可

```
target '工程target名称' do
end
```


### 初始化第三方平台
应用启动后进行U-Share和第三方平台的初始化工作
以下代码将所有平台初始化示例放出，开发者根据平台需要选取相应代码，并替换为所属注册的appKey和appSecret。   
在AppDelegate.m中设置如下代码

**注意并不是所有分享平台都需要配置对应的Appkey，比如WhatsApp、印象笔记平台会直接通过AirDrop方式分享，而短信和邮件会直接调用系统自带的应用进行分享，这两种分享方式均不需要配置对应的三方Appkey**

```
#import <UMSocialCore/UMSocialCore.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    // Custom code
    
    return YES;
}

- (void)confitUShareSettings
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

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 钉钉的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    
    /* 设置易信的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置点点虫（原来往）的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置领英的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    
    /* 设置Twitter的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    
    /* 设置Facebook的appKey和UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
    
    /* 设置Pinterest的appKey */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    
    /* dropbox的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    
    /* vk的appkey */
    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}

```

### 设置系统回调   

```
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	//6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}
```
注：以上为建议使用的系统```openURL```回调，且 **新浪** 平台仅支持以上回调。还有以下两种回调方式，如果开发者选取以下回调，也请补充相应的函数调用。

1. 仅支持iOS9以上系统，iOS8及以下系统不会回调

```
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
```

2.支持目前所有iOS系统

```
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
```

> 若想了解更多U-Share接口，如判断平台安装等，请参考[U-Share API说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#5)













## 技术支持



- [友盟开发者社区](http://bbs.umeng.com/)
- 联系客服：[**联系客服](https://service.taobao.com/support/minerva/robot.htm?spm=0.0.0.0.Q6TuTf&sourceId=1523174451)
- Email：support@umeng.com

☺为了能够尽快响应您的反馈，请提供您的appkey及console中的详细出错日志，您所提供的内容越详细越有助于我们帮您解决问题。常见问题请阅读友盟论坛中[统计SDK常见问题索引](http://bbs.umeng.com/thread-5421-1-1.html)。


