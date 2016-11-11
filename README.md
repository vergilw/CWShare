CWShare 1.9.0
=======
```ruby
pod 'CWShare'
```
![](http://admin.imdota.com/screenshot2.jpeg) ![](http://admin.imdota.com/screenshot1.jpeg)

## 关于CWShare
CWShare是一个集成的国内分享平台的Objective-C版本的SDK。**代码开源，可以自定义修改弹框视图**。
CWShare封装了以下平台，支持版本`iOS7.0+`:
- 新浪微博
- 腾讯QQ
- 微信

## 谁适合使用它
仅使用第三方登录和简单分享，降低用户注册账号的门槛。
使用第三方登录授权后自动获取用户个人信息，用来填充用户个人资料。

## 使用注意:
由于Demo里的分享AppKey都是刚申请的测试应用，**不支持测试账号以外的其他账号授权**，所以在测试Demo的时候，**请使用自己的AppKey**（同理URL Schemes也要相应修改），否则测试流程会出错。测试需要在真机上测试，因为需要跳转到第三方平台App授权，所以需要修改项目的证书配置。

## 如何使用:
CWShare已经发布到Cocoapods，直接编辑你项目的`Podfile`文件，加入如下pod。
```ruby
platform :ios, 'x.0'
target 'project' do
...
pod 'CWShare'
...
end
```

由于使用SSO授权，使用URLScheme技术，所以项目配置文件需做如下配置。选中项目的`TARGETS`，选择`Info`选项，找到最下面的`URL Types`，分别添加：新浪微博、腾讯QQ、微信。具体可以参考Demo里的配置。

iOS9+判断是否安装第三方权限，需要在plist里加入如下代码，将各平台App加入白名单，具体参考Demo配置。
```objective-c
<key>LSApplicationQueriesSchemes</key>
<array>
<string>mqq</string>
<string>weixin</string>
<string>sinaweibo</string>
<string>sinaweibohd</string>
<string>weibosdk</string>
<string>weibosdk2.5</string>
</array>
```

配置SSO授权最后一步，在项目的AppDelegate.h文件里按如下方式填充方法，以便保证回调正确：
```objective-c

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
    ...
    //微信注册
    [[CWShare shareObject] registerWechatAppID:WeChatAppID appSecret:WeChatAppSecret];
    //微博注册
    [[CWShare shareObject] registerSinaAppKey:SinaAppKey redirectURL:SinaRedirectURL];
    //腾讯QQ注册
    [[CWShare shareObject] registerTencentAppKey:TencentAppKey];
    
    return YES;
}
//NS_DEPRECATED_IOS(4_2, 9_0)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    ...
    [CWShare handleOpenUrl:url];

    return YES;
}
//NS_AVAILABLE_IOS(9_0)
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    ...
    [CWShare handleOpenUrl:url];

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
在分享的时候你需要设置它的回调代理，调用如下代码。
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

## To Do
增加Swift版本

## 更新说明
####1.9版本更新（2016-11-10）
- 项目添加到Cocoapods里，自动获取其他平台库最新版本

####1.8版本更新（2015-09-18）
- 因为新浪微博SDK的问题，临时发了一个版本，修复iOS9下的错误
- iOS9由于判断是否安装第三方方法被禁用，需要在plist里加入如下代码，将各平台App加入白名单

####1.7版本更新（2015-08-31）
- 替换所有SDK为最新版本
- 修复了一些错误。

####1.6版本更新（2015-01-14）
- 替换微博为官方SDK。
- 替换所有库以支持64位。
- 修改了使用CWShare的步骤。

####1.5版本更新（2014-08-13）
- 更新QQ到官方2.3版本。
- 由于QQ官方关闭了接口，去掉了QQ的Oauth授权方式。
- 增加了分享到手机QQ方式。
- 修复了一些错误。

####1.4版本更新（2014-07-29）
- 增加了微信分享。
- 增加了一键分享菜单。
- 更新所有支持库到最新版本。
- 去掉了Json解析库，将ASIHttpRequest更换为AFNetworking。

####1.3版本更新（2013-11-07）
- 增加了腾讯微博SSO授权方式。
- 更新所有支持库到最新版本，支持IOS7。

####1.2版本更新（2013-04-26）
- 增加新浪微博SSO授权方式。
- 修改CWShare为单例模式。
- 完善了部分细节。

####1.1版本更新（2013-04-10）
- 将腾讯微博更换为腾讯QQ互联，能同时分享到QQ空间，腾讯微博。
- 授权后自动获取用户第三方个人资料，方便填充账号信息。
- 优化授权回调函数，使用Block交互方式。

## 联系作者
`QQ 1749520`
如果你有任何问题可以联系作者，欢迎提出意见。
