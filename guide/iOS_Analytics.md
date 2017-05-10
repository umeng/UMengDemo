



# 页面统计

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



# 错误收集

统计SDK默认是开启Crash收集机制的，如果开发者需要关闭Crash收集机制则设置如下：

```objective-c
[MobClick setCrashReportEnabled:NO];   // 关闭Crash收集
```

[如何定位错误？](http://dev.umeng.com/analytics/reports/errors#2)

**错误统计的常见问题参见友盟开发者社区：** [友盟错误分析常见问题汇总](http://bbs.umeng.com/thread-6310-1-1.html)



# 账号统计

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



# 自定义事件

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



# 集成测试

集成测试是通过收集和展示已注册测试设备发送的日志，来检验SDK集成有效性和完整性的一个服务。 所有由注册设备发送的应用日志将实时地进行展示，您可以方便地查看包括应用版本、渠道名称、自定义事件、页面访问情况等数据，提升集成与调试的工作效率。

> **注**: 使用集成测试的设备，其测试数据不会进入应用正式的统计后台，只在“管理--集成测试--实时日志”里查看

测试过程中在Xcode的console窗口查看日志信息，可以打开日志模式：

```objective-c
[MobClick setLogEnabled:YES]; 
```

使用集成测试服务请点击[集成测试](http://mobile.umeng.com/test_devices?ticket=ST-1450072700rPWK4t4q46xw-qpBXzk)。

集成中可能出现的问题，点击[这里](http://bbs.umeng.com/thread-6383-1-1.html) 。
