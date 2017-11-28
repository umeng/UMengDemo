



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


#	游戏统计集成详解
## 充值

玩家支付货币兑换虚拟币,用于统计游戏的收入情况

```
// 充值.
+[MobClickGameAnalytics pay:(double)cash source:(int)source coin:(double)coin];
// 充值并购买道具.
+[MobClickGameAnalytics pay:(double)cash source:(int)source item:(NSString *)item amount:(int)amount price:(double)price];
```
字段 	含义 	取值

cash 	真实币数量 	>=0的数,最多只保存小数点后2位

source 	支付渠道 	1 ~ 99的整数, 其中1..20 是预定义含义,其余21-99需要在网站设置。

coin 	虚拟币数量 	大于等于0的整数, 最多只保存小数点后2位

item 	道具ID 	非空字符串

amount 	道具数量 	大于0的整数


source对应的数字、含义如下表：

数值 	含义

1 	App Store

2 	支付宝

3 	网银

4 	财付通

5 	移动通信

6 	联通通信

7 	电信通信

8 	paypal


 Demo 在游戏中充值或者购买虚拟币的时候调用此方法，比如通过支付宝用 10元钱 购买了 1000 个金币，可以这样调用：
 
```
[MobClickGameAnalytics pay:10 source:2 coin:1000];
```

有些时候在游戏中会直接购买某个道具，比如10元购买 2个魔法药水,每个药水50个金币，可以调用下面的方法在付费的同时购买道具。

```
[MobClickGameAnalytics 10 source:2 item:@"magic_bottle" amount:2 price:50];
```
测试方法及报表对应关系请见产品使用文档。
## 购买

玩家用虚拟币兑换一定数量、价值的道具

```
// 购买道具.
+[MobClickGameAnalytics buy:(NSString *)item amount:(int)amount price:(double)price];
```

字段 	含义 	取值

item 	道具ID 	非空字符串

amount 	道具数量 	大于0的整数

price 	道具单价 	>=0


购买道具需要传递道具ID、数量(amount)、道具单价(price)。

在游戏中使用金币购买了1个头盔，一个头盔价值 1000 金币，可以这样统计：

```
[MobClickGameAnalytics buy:@"helmet" amount:1 price:1000];
```
测试方法及报表对应关系请见产品使用文档。

## 消耗

玩家使用道具的情况

```
// 使用道具.
+[MobClickGameAnalytics use:(NSString *)item amount:(int)amount price:(double)price];
```

字段 	含义 	取值

item 	道具ID 	非空字符串

amount 	道具数量 	大于0的整数

price 	道具单价 	>=0


消耗道具需要传递道具ID、数量(amount)、道具单价(price)。

游戏中的物品损耗，比如使用了2瓶魔法药水,每个需要50个虚拟币，可以这样统计：

```
+[MobClickGameAnalytics use:@"magic_bottle" amount:2 price:50];
```

测试方法及报表对应关系请见产品使用文档。

 注意

 目前每个游戏最多支持1000个道具的统计。

## 关卡

记录玩家在游戏中的进度

```
// 进入关卡.
+[MobClickGameAnalytics startLevel:(NSString *)level];
// 通过关卡.
+[MobClickGameAnalytics finishLevel:(NSString *)level];
// 未通过关卡.
+[MobClickGameAnalytics failLevel:(NSString *)level];
```
字段 	含义 	取值

level 	关卡id 	非空字符串(eg：level-01)

开发者需要在关卡状态变动时调用startLevel方法重新设置当前关卡。 多次调用startLevel，以最后设置的为准

在游戏开启新的关卡的时候调用 startLevel: 方法，在关卡失败的时候调用 failLevel: 方法，在成功过关的时候调用 finishLevel: 方法。

调用 failLevel: 或 finishLevel: 的时候会计算从 startLevel 开始的时长，作为这一关卡的耗时。level 字段最好为非空可排序的字符串。

SDK 默认减去程序切入后台的时间。

调用 failLevel: 或 finishLevel: 传入nil，则为当前关卡。

测试方法及报表对应关系请见产品使用文档。

注意

目前每个游戏最多支持500个关卡。

## 额外奖励

针对游戏中额外获得的虚拟币进行统计，比如系统赠送，节日奖励，打怪掉落。

```
// 赠送金币.
+[MobClickGameAnalytics bonus:(double)coin source:(int)source];
// 赠送道具.
+[MobClickGameAnalytics bonus:(NSString *)item amount:(int)amount price:(double)price source:(int)source];
```
字段 	含义 	取值

coin 	虚拟币数量 	大于0的整数, 最多只保存小数点后2位

source 	奖励渠道 	取值在 1~10 之间。“1”已经被预先定义为“系统奖励”，2~10 需要在网站设置含义

item 	道具ID 	非空字符串

amount 	道具数量 	大于0的整数

price 	道具单价 	>=0


消耗道具需要传递道具ID、数量(amount)、道具单价(price)。

连续5天登陆游戏奖励1000金币，可以这样统计：

```
+[MobClickGameAnalytics bonus:1000 source:1];
```

如果在五一假期中举行登陆有奖活动，开发者想统计活动期间所赠送的金币数量，可以这样统计：

```
+[MobClickGameAnalytics bonus:10000 source:2];
```
然后在后台“设置”——“虚拟币来源管理”中将“2”这个事件设为节日奖励。即可看到相应的数据了。

注意：所有的浮点类型，只精确到百分位；所有的数值类型不能为负数，否则不予处理。tigger的取值在1~10之间，“1”已经被预先定义为“系统奖励”，超过这个范围将不予处理。
## 玩家信息统计

增加玩家账号统计维度，同时可以追踪玩家的等级情况。以便结合关卡和付费数据整理出更有价值的用户。开发者应该在程序开始的地方尽早调用。
### 账号统计

注意：使用老版SDK中账号统计的开发者，请尽早跟新SDK并使用新接口

```
+ (void)profileSignInWithPUID:(NSString *)puid;
+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider;
```
PUID：玩家账号ID.长度小于64字节

Provider：账号来源。如果玩家通过第三方账号登陆，可以调用此接口进行统计。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32字节 ; 如果是上市公司，建议使用股票代码。

```
+ (void)profileSignOff;
```

账号登出时需调用此接口，调用之后不再发送账号相关内容。

当玩家使用游戏自有账号登录时，可以这样统计：

```
[MobClickGameAnalytics profileSignInWithPUID:@"playerID"];
```

当玩家使用第三方账号（如新浪微博）登录时，可以这样统计：

```
[MobClickGameAnalytics profileSignInWithPUID:@"playerID" provider:@"WB"];
```
### 等级统计接口
当玩家建立角色或者升级时，需调用此接口

```
+ (void)setUserLevelId:(int)level;
```
level：大于1的整数，最多统计1000个等级

当玩家从1级升至2级时，可以这样统计：

```
[MobClickGameAnalytics setUserLevelId:2];

```
# 集成测试

集成测试是通过收集和展示已注册测试设备发送的日志，来检验SDK集成有效性和完整性的一个服务。 所有由注册设备发送的应用日志将实时地进行展示，您可以方便地查看包括应用版本、渠道名称、自定义事件、页面访问情况等数据，提升集成与调试的工作效率。

> **注**: 使用集成测试的设备，其测试数据不会进入应用正式的统计后台，只在“管理--集成测试--实时日志”里查看

测试过程中在Xcode的console窗口查看日志信息，可以打开日志模式：

```objective-c
[MobClick setLogEnabled:YES]; 
```

使用集成测试服务请点击[集成测试](http://mobile.umeng.com/test_devices?ticket=ST-1450072700rPWK4t4q46xw-qpBXzk)。

集成中可能出现的问题，点击[这里](http://bbs.umeng.com/thread-6383-1-1.html) 。
