# 错误分析集成文档

## 依赖库

1. UMCommon.framework
2. SystemConfiguration.framework
3. libz.tbd
4. libc++.tbd
5. Foundation.framework
6. UIKit.framework

## 接口函数

### UMErrorCatch

```
//初始化native层的崩溃监控
//@note 在调试模式下，initErrorCatch函数不起作用
+(void) initErrorCatch;

```

```
//停止native层监控
+(void)stopErrorCatch;

```


>**特别注意1:**
***initErrorCatch函数在[UMConfigure initWithAppkey:@"xxx" channel:@"App Store"];后面调用，保证兼容老版uapp的错误分析的流程，切记切记。***

例子如下：

```

    [UMConfigure initWithAppkey:@"595ce97f310c9360ab0001c0" channel:@"App Store"];
    [UMErrorCatch initErrorCatch];//错误分析的库必须加在UMConfigure initWithAppkey，否则没法兼容UApp的excetion和singal的兼容
    
```

>**特别注意2:**
***调试模式下，不能通过initErrorCatch函数来捕获崩溃***


