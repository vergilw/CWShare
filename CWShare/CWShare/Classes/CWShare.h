//
//  CWShare.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "CWShareSina.h"
#import "CWShareQQ.h"
#import "CWShareDelegate.h"
#import "CWShareWeChat.h"
#import "CWShareConfig.h"
#import "CWShareView.h"

@interface CWShare : NSObject <CWShareSinaDelegate,CWShareQQDelegate,CWShareWeChatDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) CWShareSina *sinaShare;
@property (nonatomic, strong) CWShareQQ *tencentShare;
@property (weak) id<CWShareDelegate> delegate;
@property (weak) UIViewController *parentViewController;
@property (nonatomic, strong) CWShareWeChat *wechatShare;

//获取共享对象
+ (CWShare *)shareObject;

//获取一键分享菜单
- (void)showShareMenuOnView:(UIView *)theView;

/*!
 * @method
 * @brief 显示水平的菜单视图
 * @discussion
 * @param theView 需要显示在哪个视图上
 * @param actionOptions 需要显示的功能Item
 * @param menuItemBlock 处理点击事件
 */
- (void)showHorizontalMenuOnView:(UIView *)theView withActionOptions:(CWActionItemOptions)actionOptions selectBlock:(void(^)(CWMenuItem menuItem))menuItemBlock;

//处理第三方回调
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

@end
