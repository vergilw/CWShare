CWShare 1.8
=======

![](https://github.com/ChrisWang115/CWShare/blob/master/CWShareDemo/CWShareDemo/screenshot1.jepg)![](https://github.com/ChrisWang115/CWShare/blob/master/CWShareDemo/CWShareDemo/screenshot2.jepg)

### 更新说明
1.8版本更新（2015-09-18）
- 因为新浪微博SDK的问题，临时发了一个版本，修复iOS9下的错误
- iOS9由于判断是否安装第三方方法被禁用，需要在plist里加入如下代码，将各平台App加入白名单
```objective-c
<key>LSApplicationQueriesSchemes</key>
<array>
<string>mqq</string>
<string>weixin</string>
<string>sinaweibo</string>
<string>sinaweibohd</string>
</array>
```

1.7版本更新（2015-08-31）
- 替换所有SDK为最新版本
- 修复了一些错误。

1.6版本更新（2015-01-14）
- 替换微博为官方SDK。
- 替换所有库以支持64位。
- 修改了使用CWShare的步骤。

1.5版本更新（2014-08-13）
- 更新QQ到官方2.3版本。
- 由于QQ官方关闭了接口，去掉了QQ的Oauth授权方式。
- 增加了分享到手机QQ方式。
- 修复了一些错误。

1.4版本更新（2014-07-29）
- 增加了微信分享。
- 增加了一键分享菜单。
- 更新所有支持库到最新版本。
- 去掉了Json解析库，将ASIHttpRequest更换为AFNetworking。

1.3版本更新（2013-11-07）
- 增加了腾讯微博SSO授权方式。
- 更新所有支持库到最新版本，支持IOS7。

1.2版本更新（2013-04-26）
- 增加新浪微博SSO授权方式。
- 修改CWShare为单例模式。
- 完善了部分细节。

1.1版本更新（2013-04-10）
- 将腾讯微博更换为腾讯QQ互联，能同时分享到QQ空间，腾讯微博。
- 授权后自动获取用户第三方个人资料，方便填充账号信息。
- 优化授权回调函数，使用Block交互方式。

### 关于CWShare
CWShare是一个集成的国内分享平台的Object-C版本的SDK。

目前CWShare支持以下平台:
- 新浪微博
- 腾讯QQ
- 微信

### 谁适合使用它
仅使用第三方登录和简单分享，降低用户注册账号的门槛。
使用第三方登录授权后自动获取用户个人信息，用来填充用户个人资料。

### 使用注意:
由于Demo里的分享AppKey都是刚申请的测试应用，不支持测试账号以外的其他账号授权，所以在测试Demo的时候，请将CWShareConfig文件里的配置信息更换为自己的AppKey（同理URL Schemes也要相应修改），否则测试流程会出错。测试需要在真机上测试，因为需要跳转到第三方平台App授权，所以需要修改项目的证书配置。

### 如何使用:
CWShare里使用了第三方库AFNetworking。
在Demo里大家可以将这个第三方库一起拷贝到自己的项目里，当然引用这个第三方库需要在项目里添加相应的Frameworks。
你需要添加如下framwork:
- SystemConfiguration.framework
- MobileCoreServices.framework
- QuartzCore.framework
- libz.dylib
 
由于腾讯SSO授权不公开API接口，所以项目中为了引用QQ的私有库文件，还需要添加如下framework:
- CoreTelephony.framework
- Security.framework
- libstdc++.dylib
- libsqlite3.dylib
- libiconv.dylib

引用新浪微博的SDK需要添加如下framework:
- CoreText.framework
- ImageIO.framework

另外CWShare文件里含有如下文件，别漏掉。
- TencentOpenAPI.framework（QQ自己的私有库）
- libWeChatSDK.a (微信自己的私有库)

由于增加了SSO授权方式，所以需要相应的修改项目配置文件。选中项目的TARGETS，选择Info选项，找到最下面的URL Types，添加新的URL Types：
新浪的URL Schemes填写wb”your app key"。
QQ的URL Schemes填写tencent"your app key"。
微信的URL Schemes填写weixin”your app key”
其他信息可以任意填写。可以参考Demo里的配置设置。

配置SSO授权最后一步，在项目的AppDelegate.h文件里按如下方式填充方法，以便保证回调正确：
```objective-c

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    …

    [WeiboSDK registerApp:SINA_APP_KEY];
    [WXApi registerApp:WeChatAppID];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [CWShare handleOpenUrl:url sourceApp:sourceApplication];

    return YES;
}

```

下面是使用CWShare的方法，非常简单。

使用的时候先在你要调用CWShare的.h头文件里申明要实现CWShareDelegate代理。
```objective-c
#import <UIKit/UIKit.h>
#import "CWShare.h"

@interface ViewController : UIViewController <CWShareDelegate>

@end
```
在分享的时候你需要设置它的代理和父视图控制器，调用如下代码。
```objective-c
#import "ViewController.h"

...

- (IBAction)sinaShareContent:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] sinaShareWithContent:@"test cwshare"];
}

...
```

在你的类里实现如下代理，可以处理分享之后的操作。
```objective-c
#import "ViewController.h"

...

- (void)shareFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪微博分享失败");
    }
}

- (void)shareFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪微博分享成功");
    }
}

...
```
更多使用方式可以参考Demo。

### 联系作者
QQ 1749520
如果你有任何问题可以联系作者，欢迎提出意见。
