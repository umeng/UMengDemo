



# 功能启用

使用Dplus功能需要在初始化代码中添加如下：

```objective-c
#import <UMAnalytics/DplusMobClick.h>		// 引入Dplus header file

[MobClick setScenarioType:E_UM_DPLUS];  	// 启用DPlus功能
```



# track事件

> - eventName – 事件名称。 
> - property – 事件的自定义属性（可以包含多对“属性名-属性值”），字典类型。

自定义track事件

```objective-c
// 记录一个dplus事件
[DplusMobClick track:@"pruchase"];

// 记录一个带有属性特征的Dplus事件， 例如以下代码发送了一个名为login的事件，它包含name和age两个自定义属性，其值分别为Tom和23。
[DplusMobClick track:@"login" property:@{@"Tom": @(23)}];
```





# 超级属性

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

