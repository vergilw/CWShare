CWShare 1.0
=======

### 关于CWShare:
CWShare是一个集成的国内分享平台的Object-C版本的SDK。
使用非常简单，适用于那些简单的利用分享平台发送微博来推广自己应用的App。

目前CWShare支持以下平台:
- 新浪微博
- 腾讯微博

### 使用注意:
由于Demo里的分享AppKey都是刚申请的测试应用，不支持测试账号以外的其他账号授权，所以在测试Demo的时候，请将CWShareConfig文件里的配置信息更换为自己的AppKey，否则授权不通过。

### 如何使用:
CWShare里使用了两个很常用的第三方库，ASIHttpRequest和JsonFramework。
在Demo里大家可以将这两个第三方库一起拷贝到自己的项目里，当然引用这两个第三方库需要在项目里添加相应的Frameworks。
你需要添加如下framwork:
- CFNetwork.framework
- SystemConfiguration.framework
- MobileCoreServices.framework
- QuartzCore.framework
- libz.dylib

使用的时候先在你要调用CWShare的.h头文件里申明它。
```objective-c
#import <UIKit/UIKit.h>
#import "CWShare.h"

@interface ViewController : UIViewController <CWShareDelegate>

@property (nonatomic, strong) CWShare *cwShare;

@end
```

然后在你要调用CWShare的.m源文件里初始化它。
```objective-c
#import "ViewController.h"

...

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.cwShare = [[[CWShare alloc] init] autorelease];
    [cwShare setDelegate:self];
    [cwShare setParentViewController:self];
}
```

在分享的时候你只需要调用如下的一句代码。
```objective-c
#import "ViewController.h"

...

- (IBAction)sinaShareContent:(id)sender
{
    [cwShare sinaShareWithContent:@"test cwshare"];
}
```

在你的类里实现如下代理，可以处理分享之后的操作。
```objective-c
#import "ViewController.h"

...

- (void)shareContentFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享内容失败");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享内容失败");
    }
}

- (void)shareContentFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享内容成功");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享内容成功");
    }
}
```

