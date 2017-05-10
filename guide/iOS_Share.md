# 集成SDK
## 导入U-Share

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

## 添加第三方平台库
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



# 第三方平台配置

## 配置SSO白名单   
如果你的应用使用了如SSO授权登录或跳转到第三方分享功能，在iOS9/10下就需要增加一个可跳转的白名单，即```LSApplicationQueriesSchemes```，否则将在SDK判断是否跳转时用到的canOpenURL时返回NO，进而只进行webview授权或授权/分享失败。
在项目中的info.plist中加入应用白名单，右键info.plist选择source code打开(plist具体设置在Build Setting -> Packaging -> Info.plist File可获取plist路径)
请根据选择的平台对以下配置进行裁剪：

```

<key>LSApplicationQueriesSchemes</key>
<array>
    <!-- 微信 URL Scheme 白名单-->
    <string>wechat</string>
    <string>weixin</string>

    <!-- 新浪微博 URL Scheme 白名单-->
    <string>sinaweibohd</string>
    <string>sinaweibo</string>
    <string>sinaweibosso</string>
    <string>weibosdk</string>
    <string>weibosdk2.5</string>

    <!-- QQ、Qzone URL Scheme 白名单-->
    <string>mqqapi</string>
    <string>mqq</string>
    <string>mqqOpensdkSSoLogin</string>
    <string>mqqconnect</string>
    <string>mqqopensdkdataline</string>
    <string>mqqopensdkgrouptribeshare</string>
    <string>mqqopensdkfriend</string>
    <string>mqqopensdkapi</string>
    <string>mqqopensdkapiV2</string>
    <string>mqqopensdkapiV3</string>
    <string>mqqopensdkapiV4</string>
    <string>mqzoneopensdk</string>
    <string>wtloginmqq</string>
    <string>wtloginmqq2</string>
    <string>mqqwpa</string>
    <string>mqzone</string>
    <string>mqzonev2</string>
    <string>mqzoneshare</string>
    <string>wtloginqzone</string>
    <string>mqzonewx</string>
    <string>mqzoneopensdkapiV2</string>
    <string>mqzoneopensdkapi19</string>
    <string>mqzoneopensdkapi</string>
    <string>mqqbrowser</string>
    <string>mttbrowser</string>

    <!-- 支付宝 URL Scheme 白名单-->
    <string>alipay</string>
    <string>alipayshare</string>
    
    <!-- 钉钉 URL Scheme 白名单-->
	  <string>dingtalk</string>
	  <string>dingtalk-open</string>
	  
    <!--Linkedin URL Scheme 白名单-->
	<string>linkedin</string>
	<string>linkedin-sdk2</string>
	<string>linkedin-sdk</string>

    <!-- 点点虫 URL Scheme 白名单-->
    <string>laiwangsso</string>

    <!-- 易信 URL Scheme 白名单-->
    <string>yixin</string>
    <string>yixinopenapi</string>

    <!-- instagram URL Scheme 白名单-->
    <string>instagram</string>

    <!-- whatsapp URL Scheme 白名单-->
    <string>whatsapp</string>

    <!-- line URL Scheme 白名单-->
    <string>line</string>

    <!-- Facebook URL Scheme 白名单-->
    <string>fbapi</string>
    <string>fb-messenger-api</string>
    <string>fbauth2</string>
    <string>fbshareextension</string>
    
    <!-- Kakao URL Scheme 白名单-->  
    <!-- 注：以下第一个参数需替换为自己的kakao appkey--> 
    <!-- 格式为 kakao + "kakao appkey"-->    
	<string>kakaofa63a0b2356e923f3edd6512d531f546</string>
	<string>kakaokompassauth</string>
	<string>storykompassauth</string>
	<string>kakaolink</string>
	<string>kakaotalk-4.5.0</string>
	<string>kakaostory-2.9.0</string>
    
   <!-- pinterest URL Scheme 白名单-->  
	<string>pinterestsdk.v1</string>
	
   <!-- Tumblr URL Scheme 白名单-->  
	<string>tumblr</string>

   <!-- 印象笔记 -->
	<string>evernote</string>
	<string>en</string>
	<string>enx</string>
	<string>evernotecid</string>
	<string>evernotemsg</string>
	
   <!-- 有道云笔记-->
	<string>youdaonote</string>
	<string>ynotedictfav</string>
	<string>com.youdao.note.todayViewNote</string>
	<string>ynotesharesdk</string>
	
   <!-- Google+-->
	<string>gplus</string>
	
   <!-- Pocket-->
	<string>pocket</string>
	<string>readitlater</string>
	<string>pocket-oauth-v1</string>
	<string>fb131450656879143</string>
	<string>en-readitlater-5776</string>
	<string>com.ideashower.ReadItLaterPro3</string>
	<string>com.ideashower.ReadItLaterPro</string>
	<string>com.ideashower.ReadItLaterProAlpha</string>
	<string>com.ideashower.ReadItLaterProEnterprise</string>
	
   <!-- VKontakte-->
	<string>vk</string>
	<string>vk-share</string>
	<string>vkauthorize</string>
</array>

```

## 配置URL Scheme   

+ URL Scheme是通过系统找到并跳转对应app的一类设置，通过向项目中的info.plist文件中加入```URL types```可使用第三方平台所注册的appkey信息向系统注册你的app，当跳转到第三方应用授权或分享后，可直接跳转回你的app。

+ 添加URL Types可工程设置面板设置

<img src="http://dev.umeng.com/system/images/W1siZiIsIjIwMTYvMDkvMjIvMThfMTlfNDJfOTY3XzExNDc0NTMzODUwXy5waWNfaGQuanBnIl1d/11474533850_.pic_hd.jpg" width="580" height="170"> 

+ 配置第三方平台URL Scheme
  未列出则不需设置

<table class="table table-bordered table-striped table-condensed">

<tr>
<td>平台</td>
<td>格式</td>
<td>举例</td>
<td>备注</td>
</tr>
<tr>
<td>微信</td>
<td>微信appKey</td>
<td>wxdc1e388c3822c80b</td>
<td></td>
</tr>
<tr>
<td>QQ/Qzone</td>
<td>需要添加两项URL Scheme：<br>  1、&quot;tencent&quot;+腾讯QQ互联应用appID<br> 2、“QQ”+腾讯QQ互联应用appID转换成十六进制（不足8位前面补0）</td>
<td>如appID：100424468 1、tencent100424468 <br> 2、QQ05fc5b14</td>
<td>QQ05fc5b14为100424468转十六进制而来，因不足8位向前补0，然后加&quot;QQ&quot;前缀</td>
</tr>
<tr>
<td>新浪微博</td>
<td>“wb”+新浪appKey</td>
<td>wb3921700954</td>
<td></td>
</tr>
<tr>
<td>支付宝</td>
<td>“ap”+appID</td>
<td>ap2015111700822536</td>
<td>URL Type中的identifier填&quot;alipayShare&quot;</td>
</tr>
<tr>
<td>钉钉</td>
<td>钉钉appkey</td>
<td>dingoalmlnohc0wggfedpk</td>
<td>identifier的参数都使用dingtalk</td>
</tr>
<tr>
<td>易信</td>
<td>易信appkey</td>
<td>yx35664bdff4db42c2b7be1e29390c1a06</td>
<td></td>
</tr>
<tr>
<td>点点虫</td>
<td>点点虫appID</td>
<td>8112117817424282305</td>
<td>URL Type中的identifier填&quot;Laiwang&quot;</td>
</tr>
<tr>
<td>领英</td>
<td>“li”+appID</td>
<td>li4768945</td>
<td></td>
</tr>
<tr>
<td>Facebook</td>
<td>“fb”+FacebookID</td>
<td>fb506027402887373</td>
<td></td>
</tr>
<tr>
<td>VKontakte</td>
<td>“vk”+ VKontakteID</td>
<td>vk5786123</td>
<td></td>
</tr>
</table>


> 部分平台需要再参考进阶文档   
> [微信平台从U-Share 4/5升级说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1)   
> [新浪微博集成说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2)   
> [QQ/QZone平台集成说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3)   
> [人人平台集成说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_4)   
> [Facebook/Messenger集成说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_5)   
> [Twitter集成说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_6)   
> [Kakao集成说明](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_7)   

# 初始化设置
## 初始化U-Share及第三方平台
应用启动后进行U-Share和第三方平台的初始化工作
以下代码将所有平台初始化示例放出，开发者根据平台需要选取相应代码，并替换为所属注册的appKey和appSecret。   
在AppDelegate.m中设置如下代码




```
#import <UMSocialCore/UMSocialCore.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    // 参考SDK集成文档下的SDK初始化部分进行友盟统一appkey初始化工作
    // [UMConfigure initWithAppkey:@"Your appkey" channel:@"App Store"]; 
    
    // 初始化第三方平台及相关配置
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

> 注意并不是所有分享平台都需要配置对应的Appkey，比如WhatsApp、印象笔记平台会直接通过AirDrop方式分享，而短信和邮件会直接调用系统自带的应用进行分享，这两种分享方式均不需要配置对应的三方Appkey

## 设置系统回调   

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

# 分享到第三方平台

分享目前支持的类型有：

* 网页类型（网页链接）

* 图片

* 文本

* 表情（GIF图片，即Emotion类型，只有微信支持）

* 图文（包含一张图片和一段文本）

* 视频（只支持视频URL、缩略图及描述）

* 音乐（只支持音乐URL、缩略图及描述）

## 分享LinkCard(网页链接)

```
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}
```
> 更多分享类型详见进阶文档-[分享到第三方平台](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#2)。

## 调用分享面板
在分享按钮绑定如下触发代码

```
#import <UShareUI/UShareUI.h>
//显示分享面板
[UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    // 根据获取的platformType确定所选平台进行下一步操作
}];
```
> 更多分享面板说明请参考进阶文档-[分享面板UI](http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#3)。

## 定制自己的分享面板预定义平台
以下方法可设置平台顺序

```
#import <UShareUI/UShareUI.h>
 [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
 [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    // 根据获取的platformType确定所选平台进行下一步操作
}];
```
> 为避免应用审核被拒，仅会对有效的平台进行显示，如平台应用未安装，或平台应用不支持等会进行隐藏。
> 由于以上原因，在模拟器上部分平台会隐藏。

如果遇到分享面板未显示，请参考[分享面板无法弹出](http://dev.umeng.com/social/ios/u-share%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98#5_1)

# Swift接入U-Share SDK
Swift调用Objective-C需要建立一个桥接头文件进行交互
## 新建桥接头文件
<img src="http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDEvMTYvMTBfMzNfMTNfNjcyX3VzaGFyZV9zd2lmdDIucG5nIl1d/ushare_swift2.png" > 



## 设置Objective-C桥接文件

<img src="http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDEvMTYvMTBfMzNfMDRfMjQ1X3VzaGFyZV9zd2lmdDEucG5nIl1d/ushare_swift1.png" > 



## 导入SDK头文件

在新建的桥接文件header.h中加入U-Share SDK头文件：

```
//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// U-Share核心SDK
#import <UMSocialCore/UMSocialCore.h>

// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#import <UShareUI/UShareUI.h>
```



## UMSocialDemo的OC和Swift的切换

UMSocialDemo是用OC的代码编写的，同时也兼容了swift3.0的调用示例（UMSocialDemo不再对swift2.0做示例兼容).

### swift文件夹的结构

![swift3.0源文件结构](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDIvMDYvMTZfNTZfMTZfNDMwX3N3aWZ0M18wX2ZvbGRlci5wbmciXV0/swift3_0_folder.png)

UMSocialSDK-Bridging-Header.h 为swift3.0的桥接文件，主要是在swift3.0中，调用oc的代码。

UMSocialSwiftInterface.swift 为Swift3.0的接口文件，主要是为了展示用户让oc调用swift3.0的代码的示例（用户可以在swift3.0的工程中直接调用对应的swift接口）。


### 设置切换swift的宏

![swift3.0宏设置](http://dev.umeng.com/system/images/W1siZiIsIjIwMTcvMDIvMDYvMTZfNTZfMzFfNTI5X3N3aWZ0M18wX3NldHRpbmcucG5nIl1d/swift3_0_setting.png)

### 引入对应的swift的头文件，并在OC中调用swift3.0的代码如下

```

#ifdef UM_Swift
#import "UMSocialDemo-Swift.h"
#endif

//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = UMS_Text;
    
#ifdef UM_Swift
    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
#endif
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [self alertWithError:error];
        }];
}

```


**注意事项如下：**

1. **UMSocialDemo-Swift.h** 是工程自动为OC调用swift生成的，如果在新建的工程中应该是 **$(TARGET_NAME)-Swift.h** ，$(TARGET_NAME)为你的工程默认配置的名字


2. UMSocialDemo需要xcode8下打开，因为里面引入了swift3.0的文件，不然会编译出错（如果不需要swift3.0，直接运行OC的代码，可以去掉对应宏 **UM_Swift** 和工程里面对应的 **文件夹Swift** 即可编译通过）。

   ​


# 问题反馈

> 为了能够尽快响应您的反馈，请提供您的U-Share SDK版本、平台相关Appkey、log中的详细出错日志以及复现步骤，您所提供的内容越详细越有助于我们帮您解决问题。

开启友盟分享调试log方法：

```
#import <UMSocialCore/UMSocialCore.h>
[[UMSocialManager defaultManager] openLog:YES];
```
在console中查看日志，更新日志查看方式请参考进阶文档-UShare调试日志。

