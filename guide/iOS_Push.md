# Push配置

## 导入系统库

增加UserNotifications.framework到项目中。
具体操作如下：点击项目----&gt;TARGET----&gt;Build Phases----&gt;Link Binary with Libraries ----&gt;左侧+号----&gt;搜索UserNotifications----&gt;选中UserNotifications.framework----&gt;点击Add

## 打开推送开关

点击项目----&gt;TARGET----&gt;Capabilities，将这里的Push Notification的开关打开，效果如图所示：
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMTAvMTIvMTZfMDBfMjJfNzg4XzQucG5nIl1d/4.png)

> **注意：一定要打开Push Notification,且两个steps都是正确的，否则会报如下错误:Code=3000 "未找到应用程序的“aps-environment”的授权字符串"**

# 消息统计

## 接收通知与统计

### 关闭友盟的弹出框

<pre lang="objective-c">`//关闭友盟自带的弹出框
[UMessage setAutoAlert:NO];
`
</pre>

### 统计点击数

<pre lang="objective-c">`[UMessage didReceiveRemoteNotification:userInfo];
`
</pre>

### 添加并运行接收通知与计数代码

<pre lang="objective-c">`//iOS10以下使用这个方法接收通知
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
`
</pre>

> 说明
> 如需关闭推送，请使用unregisterForRemoteNotifications，(iOS10此功能存在系统bug,建议不要在iOS10使用。iOS10出现的bug会导致关闭推送后无法打开推送。)
> 至此，消息推送基本功能的集成已经完成。
>
> 关于iOS如何在接收到推送后打开指定页面，可以看论坛帖子：[iOS如何调转跳转到指定页面](http://bbs.umeng.com/thread-7702-1-1.html)
>
> 需要 Tag、Alias及自定义事件等请参照 **高级功能**。

# 高级功能

## 通知的快捷功能

### 自定义推送显示

> 推送消息被下拉、左划以及3D Touch设备的点击，可以执行预先设定好的操作，如确认、取消、快捷回复等。

如iOS10以下的系统效果下图所示：

![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMDcvMTkvMTFfMzVfMjhfMTMxX2RlbW9fLnBuZyJdXQ/demo%E4%BF%AE%E6%94%B9%E5%A2%9E%E5%8A%A0.png)
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMDcvMTkvMTFfMzdfMzRfMjQ0X18ucG5nIl1d/%E4%BF%AE%E6%94%B9%E5%A2%9E%E5%8A%A0%E9%80%9A%E7%9F%A5%E6%A0%8F.png)

如iOS10以上的系统3D Touch设备和非3D Touch设备，具体的效果如下所示。

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMTMvMTVfMjRfNTBfNDg4XzQuUE5HIl0sWyJwIiwidGh1bWIiLCI0NTB4NDUwPiJdXQ/4.PNG)
![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMTMvMTVfMjRfNTBfNDEwXzMuUE5HIl0sWyJwIiwidGh1bWIiLCI0NTB4NDUwPiJdXQ/3.PNG)

> **注意：使用此功能，设备的系统版本需在iOS8及以上**

### 快捷功能注册

<pre lang="objective-c">`UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
//如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
if (([[[UIDevice currentDevice] systemVersion]intValue]&gt;=8)&amp;&amp;([[[UIDevice currentDevice] systemVersion]intValue]&lt;10)) {
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
if ([[[UIDevice currentDevice] systemVersion]intValue]&gt;=10) {
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

`
</pre>

### 快捷功能数据接收

<pre lang="objective-c">`//iOS10以前接收的方法
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

`
</pre>

### Push推送策略设置

用登录账号进入U-Push后台，可以设置提醒方式下方的Category ID为需要推送的策略id，如下图所示：
![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTYvMDcvMTkvMTNfMjRfMjlfNzQ0X18ucG5nIl1d/%E8%AE%BE%E7%BD%AE%E6%8F%90%E9%86%92%E6%96%B9%E5%BC%8F.png)

## 使用标签

### 添加tag

> 示例：将标签“男”绑定至该设备:

<pre lang="objective-c">`[UMessage addTag:@"男"
response:^(id responseObject, NSInteger remain, NSError *error) {
//add your codes
}];

`
</pre>

> 小提示：tag参数既可以是NSString的单个tag，也可以是NSArray,NSSet的tag集合哦！

### 删除tag

> 示例：将标签"男"从设备绑定中删除:

<pre lang="objective-c">`[UMessage removeTag:@"男"
response:^(id responseObject, NSInteger remain, NSError *error) {
//add your codes
}];

`
</pre>

> 小提示：tag参数既可以是NSString的单个tag，也可以是NSArray,NSSet的tag集合哦！

### 获取tag列表

> 示例： 获取tag列表

<pre lang="objective-c">`[UMessage getTags:^(NSSet *responseTags, NSInteger remain, NSError *error) {
//add your codes
}];

`
</pre>

### 重置tag列表

> 示例： 重置tag列表

<pre lang="objective-c">`[UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {

}];

`
</pre>

> 注意
>
> 1.  可以为单个tag（NSString）也可以为tag集合（NSArray、NSSet）
> 2.  每台设备最多绑定1024个tag，超过1024个，绑定tag不再成功
> 3.  单个tag最大允许长度50字节，编码UTF-8，超过长度自动截取

## 使用别名

当需要将设备标记为别名时，可用。例如：账户绑定设备。

### 添加别名(addAlias)

> 示例： 将新浪微博的某用户绑定至设备，老的绑定的设备还在

<pre lang="objective-c">`[UMessage addAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
}];

`
</pre>

> 注意：
>
> 1.  type的类型已经默认枚举好平台类型，在UMessage.h最上侧，形如:kUMessageAliasTypeSina
> 2.  type的类型如果默认的满足不了需求，可以自定义这个字段

### 设置别名(setAlias)

> 示例： 将新浪微博的某用户绑定至设备,覆盖老的，一一对应

<pre lang="objective-c">`[UMessage setAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
}];

`
</pre>

### 删除别名(removeAlias)

> 示例： 将新浪微博的别名绑定删除

<pre lang="objective-c">`[[UMessage removeAlias:@"test@test.com" type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
}];

`
</pre>

## 静默推送

> 当app没有启动的时候或者被杀掉的时候将无法收到静默推送。
>
> 静默推送必须实现  application:didReceiveRemoteNotification:fetchCompletionHandler:

![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTcvMDIvMjgvMTRfMjFfNTJfNDg2X18ucG5nIl1d/%E9%85%8D%E5%9B%BE.png)

静默推送除badge及自定义字段外，不应该包含其他字段（如果要badge，建议通过本地通知实现）。

如果只实现了application:didReceiveRemoteNotification:方法，没有实现application:didReceiveRemoteNotification:fetchCompletionHandler:将无法在后台是收到静默推送。

<pre lang="objective-c">`{
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

`
</pre>

## 应用内消息

### 开屏消息

**开屏消息就是当APP启动，或者从其他页面跳转到APP时，调用的一个启动页面，即Launchimage。**

![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTcvMDMvMTQvMTRfMTRfMjRfOTI5X2xhdW5jaF8xLnBuZyJdXQ/launch-1.png)

**默认图设置**

为了保证项目开屏的美观，请务必添加完整的`LaunchImage`

启动图，或者一个添加一张`750*1336`
的名为`Launchplaceholder`的图片（否则会显示一个黑屏状态）。

如果要适配`iOS7`，请务必添加完整的`LaunchImage`启动图，或者在`LaunchImage`添加一张`640*1136`的图片。

> 注意：不支持横屏。
**Status Bar设置**

如果需要屏蔽`Status Bar`，在`Info.plist`中增加一个`View controller-based status bar appearance`参数，并且设置为`NO`。

**打开开发模式**

在`addLaunchMessage `之前调用`openDebugMode:YES`，不写默认为生产模式。

<pre lang="objective-c">`[UMessage openDebugMode:YES];`
</pre>

> 注意：必须在添加开屏通知前增加开发模式的代码。
**增加开屏**
<pre lang="objective-c">`[UMessage addLaunchMessage];`
</pre>

### 默认插屏消息

插屏消息就是APP在打开以后弹出的一个插屏页面，或者用户去点击某些活动页面弹出的插屏消息。如下图所示

![](http://dev.umeng.com/system/resources/W1siZiIsIjIwMTcvMDMvMTQvMTRfMTZfMzhfODhfY2FyZF8xLnBuZyJdXQ/card-1.png)

**增加插屏消息**
<pre lang="objective-c">`[UMessage addCardMessageWithLabel:@"这里写标识"];`
</pre>

`addCardMessageWithLabel`后写插屏通知位置的标识字符串，比如说可以写：`home`，`setting`等等

> 注意：建议不要同时多点触发。

### 自定义插屏消息

插屏消息就是APP在打开以后弹出的一个插屏页面，或者用户去点击某些活动页面弹出的插屏消息。可以实现用户自定义大小，以及按钮的自定义等。

效果如下：

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMzBfMjBfMjA1XzJfMC5wbmciXV0/2-0.png)

可以自定义竖屏，横屏是Card的尺寸何有下方按钮的显示，以及按钮的自定义。

<pre lang="objective-c">`
/*
@param portraitsize portrait时显示的size
@param landscapesize landscape时显示的大小
@param button button 可以自定义的button
@param label 标识
*/
+(void)addCustomCardMessageWithPortraitSize:(CGSize )portraitsize LandscapeSize:(CGSize )landscapesize CloseBtn:(UIButton *_Nullable)button  Label:(NSString *_Nonnull)label umCustomCloseButtonDisplayMode:(BOOL )displaymode;`
</pre>

### 文字插屏消息

文本插屏通知可以给用户提示一些文本信息等。可以自定义文字大小。

效果如下：

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMzBfMjBfMjk2XzExLnBuZyJdXQ/11.png)

<pre lang="objective-c">`
/**
添加一个文本插屏
@param titlefont titlefont
@param contentfont contentfont
@param buttonfont buttonfont
@param label 标识
*/
+(void)addPlainTextCardMessageWithTitleFont:(UIFont *_Nullable)titlefont ContentFont:(UIFont *_Nullable)contentfont buttonFont:(UIFont *_Nullable)buttonfont Label:(NSString*_Nonnull)label;
`
</pre>

### 自定义webview

**SDK默认后续动作为url的时候，会在系统浏览器中去打开这个url。iOS增加了在APP中打开URL的功能，首先用户去实现一个webview的Controller类，在.h文件中声明一个名为url的string，然后在.m文件中打开这个url就可以了。
然后在初始化之后调用。**
<pre lang="objective-c">`
webviewcontroller.h
@interface UMWebViewController : UIViewController
@property (nonatomic, copy) NSString  *url;
@end
`
</pre>
<pre lang="objective-c">`
调用
/**
设置webViewController在.h文件中声明一个叫url的参数，SDK内部会去调用
@param webViewController webViewController
*/
+(void)setWebViewController:(UIViewController *_Nonnull)webViewController;
`
</pre>

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMzBfMjBfMzk2XzIyMi5wbmciXV0/222.png)

### 后台创建消息

【设置消息的描述】【设置消息的样式】【设置消息图片】【设置消息的按钮详情】

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMTVfNTlfMzcwXzBfMS5wbmciXV0/0-1.png)

【设置消息的目标人群】【设置消息的展示策略】【设置消息的有效期】

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMTVfNTlfNDgyXzBfMi5wbmciXV0/0-2.png)

【设置消息点击的后续动作】

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMTVfNTlfNTc3XzBfMy5wbmciXV0/0-3.png)

【消息预览】

![](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDkvMjkvMTBfMTVfNTlfNjcxXzBfNC5wbmciXV0/0-4.png)

> 注意：默认是创建生产环境的消息。

# 扩展功能

设置地理位置信息

<pre lang="objective-c">`[UMessage setLocation:location];

`
</pre>

设置是否允许SDK自动清空角标（默认开启）

<pre lang="objective-c">`[UMessage setBadgeClear:NO];

`
</pre>

设置是否允许SDK当应用在前台运行收到Push时弹出Alert框（默认开启）

<pre lang="objective-c">`[UMessage setAutoAlert:NO];

`
</pre>

自定义弹出框后，想补发前台的消息的点击统计

<pre lang="objective-c">`[UMessage sendClickReportForRemoteNotification:userInfo]

`
</pre>

设置自己的唯一识别标志

<pre lang="objective-c">`[UMessage setUniqueID]

`
</pre>

# 测试与调试

## 调试步骤

1、确认证书设置正确。参见 iOS 证书设置指南。
2、确认Provisioning Profile配置正确，并已更新
3、在友盟消息推送后台上传正确的 Push 证书
4、启动应用程序，并在选择接受推送通知
5、确认 App 是开启 Push 权限的
6、在网站后台选择对应的Device Token进行推送测试

## 获取设备的 DeviceToken

开发环境下：

方法1：在 didRegisterForRemoteNotificationsWithDeviceToken 中添加如下语句

<pre lang="objective-c">`NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"&lt;" withString: @""]
stringByReplacingOccurrencesOfString: @"&gt;" withString: @""]
stringByReplacingOccurrencesOfString: @" " withString: @""]);

`
</pre>

以上方式都可在控制台获取一个长度为64的测试设备的DeviceToken串

生产环境下，用户需要用抓包工具、代理工具等自行获取device_token或者可以查看NSUserDefaults中的kUMessageUserDefaultKeyForParams的值。

# 集成帮助

一、IOS为什么获取不到设备的DeviceToken[查看帮助](http://bbs.umeng.com/thread-6028-1-1.html)

二、IOS可以自定义App在前台接受到消息的弹出框么[查看帮助](http://bbs.umeng.com/forum.php?mod=viewthread&amp;tid=6026&amp;page=1&amp;extra=#pid7923)

三、为什么集成完SDK后，App运行没有弹出打开通知的对话框[查看帮助](http://bbs.umeng.com/thread-6025-1-1.html)

四、为什么集成成功后iOS收不到推送通知[查看帮助](http://bbs.umeng.com/forum.php?mod=viewthread&amp;tid=5428&amp;extra=page%3D1%26filter%3Dtypeid%26typeid%3D25)

更多常见问题请点击访问：[友盟消息推送常见问题索引](http://bbs.umeng.com/thread-5911-1-1.html)

如果还有问题，请把您的问题发邮件至[msg-support@umeng.com](mailto:msg-support@umeng.com)或者联系官网底部云客服系统（在线时间：工作日10：00~18:00）。如需要了解更多信息，请申请加入消息推送官方QQ群：196756762，（需提供友盟appkey），我们会尽快回复您。
