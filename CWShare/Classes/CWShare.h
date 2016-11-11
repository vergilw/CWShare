//
//  CWShare.h
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "CWShareSina.h"
#import "CWShareQQ.h"
#import "CWShareWeChat.h"
#import "CWShareDelegate.h"
#import "CWShareView.h"

/*
 新浪微博依赖Pod WeiboSDK
 腾讯QQ依赖Pod Tencent_SDK
 微信依赖Pod WeChat_SDK
 */

NS_ASSUME_NONNULL_BEGIN

@interface CWShare : NSObject <CWShareSinaDelegate,CWShareQQDelegate,CWShareWeChatDelegate>

@property (nonatomic, strong, readonly) CWShareSina *sinaShare;
@property (nonatomic, strong, readonly) CWShareQQ *tencentShare;
@property (nonatomic, strong, readonly) CWShareWeChat *wechatShare;
@property (weak, nonatomic) id<CWShareDelegate> delegate;
@property (weak, nonatomic) UIViewController *parentViewController;

//获取共享对象
+ (CWShare *)shareObject;

/*!
 * @method
 * @brief 注册新浪微博配置信息
 * @discussion
 * @param appKey 新浪微博AppKey
 * @param URLString 回调地址
 */
- (void)registerSinaAppKey:(NSString *)appKey redirectURL:(NSString *)URLString;

/*!
 * @method
 * @brief 注册腾讯QQ配置信息
 * @discussion
 * @param appKey 腾讯QQ AppKey
 */
- (void)registerTencentAppKey:(NSString *)appKey;

/*!
 * @method
 * @brief 注册微信配置信息
 * @discussion
 * @param appKey 微信AppID
 * @param appSecret 微信AppSecret
 */
- (void)registerWechatAppID:(NSString *)appID appSecret:(NSString *)appSecret;

//获取一键分享菜单
- (void)showShareMenuOnView:(UIView *)theView;

/*!
 * @method
 * @brief 显示水平的菜单视图
 * @discussion
 * @param theView 需要显示在哪个视图上
 * @param actionOptions 需要显示的功能Item,枚举类型
 * @param menuItemBlock 根据不同的枚举类型，处理事件
 */
- (void)showHorizontalMenuOnView:(UIView *)theView withActionOptions:(CWActionItemOptions)actionOptions selectBlock:(void(^)(CWMenuItem menuItem))menuItemBlock;

/**
 * @method
 * @brief 通过第三方App启动本App回调方法，请在AppDelegate系统方法里调用此方法
 * @discussion
 * @param url 第三方App URLScheme 参数
 * @warning 注意iOS9的新方法
 * @see -application:openURL:options:
 * @see -application:openURL:sourceApplication:annotation:
 */
+ (void)handleOpenUrl:(NSURL *)url;

//开始新浪微博授权登录
- (void)startSinaAuthorizeLogin;
//分享内容到新浪微博
- (void)sinaShareWithContent:(NSString *)theContent;
//分享内容和图片到新浪微博
- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

//开始腾讯QQ授权登录
- (void)startTencentAuthorizeLogin;
//分享内容到腾讯微博
- (void)tencentShareToWeiBoWithContent:(NSString *)theContent;
//分享内容和图片到腾讯微博
- (void)tencentShareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

//分享文字到QQ
- (void)tencentShareToQQWithContent:(NSString *)theContent;
//分享纯图片到QQ
- (void)tencentShareToQQWithImage:(UIImage *)theImage;
//分享新闻到QQ
- (void)tencentShareToQQWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withTargetUrl:(NSString *)theUrl;
//分享内容到QQ空间
- (void)tencentShareToQQZoneWithTitle:(NSString *)theTitle withDescription:(NSString *)theDesc withImage:(UIImage *)theImage targetUrl:(NSString *)theUrl;

- (void)copyUrlToPasteboard:(NSString *)urlString;

//开始微信授权登录
- (void)startWechatAuthorizeLogin;
//分享文字到微信好友
- (void)wechatSessionShareWithTitle:(NSString *)theTitle;
//分享新闻到微信好友
- (void)wechatSessionShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl;
//分享文字到微信朋友圈
- (void)wechatTimelineShareWithTitle:(NSString *)theTitle;
//分享新闻到微信朋友圈
- (void)wechatTimelineShareWithTitle:(NSString *)theTitle withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl;


//清空新浪微博授权登录信息
- (void)clearSinaAuthorizeInfo;

//清空腾讯QQ授权登录信息
- (void)clearTencentAuthorizeInfo;

//清空微信授权登录信息
- (void)clearWechatAuthorizeInfo;

NS_ASSUME_NONNULL_END

@end
