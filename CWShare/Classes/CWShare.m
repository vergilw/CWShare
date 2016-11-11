//
//  CWShare.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShare.h"
#import "CWShareStorage.h"
#import <QuartzCore/QuartzCore.h>

static CWShare *shareInstance = nil;

@interface CWShare ()

@property (nonatomic, strong, readwrite) CWShareSina *sinaShare;
@property (nonatomic, strong, readwrite) CWShareQQ *tencentShare;
@property (nonatomic, strong, readwrite) CWShareWeChat *wechatShare;

//新浪微博配置
@property (nonatomic, strong) NSString *sinaAppKey;
@property (nonatomic, strong) NSString *sinaRedirectURL;

//腾讯QQ配置
@property (nonatomic, strong) NSString *tencentAppKey;

//微信配置
@property (nonatomic, strong) NSString *wechatAppID;
@property (nonatomic, strong) NSString *wechatAppSecret;

@end

@implementation CWShare

@synthesize sinaShare,tencentShare,delegate,parentViewController,wechatShare;

+ (CWShare *)shareObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CWShare alloc] init];
        shareInstance.sinaShare = [[CWShareSina alloc] init];
        [shareInstance.sinaShare setDelegate:shareInstance];
        
        shareInstance.tencentShare = [[CWShareQQ alloc] init];
        [shareInstance.tencentShare setDelegate:shareInstance];
        
        shareInstance.wechatShare = [[CWShareWeChat alloc] init];
        [shareInstance.wechatShare setDelegate:shareInstance];
    });

    return shareInstance;
}

/*!
 * @method
 * @brief 注册新浪微博配置信息
 * @discussion
 * @param appKey 新浪微博AppKey
 * @param URLString 回调地址
 */
- (void)registerSinaAppKey:(NSString *)appKey redirectURL:(NSString *)URLString {
    NSAssert([URLString hasPrefix:@"http://"], @"请输入完整包含http开头的回调URL路径");
    self.sinaAppKey = appKey;
    self.sinaRedirectURL = URLString;
    
    [WeiboSDK registerApp:self.sinaAppKey];
}

/*!
 * @method
 * @brief 注册腾讯QQ配置信息
 * @discussion
 * @param appKey 腾讯QQ AppKey
 */
- (void)registerTencentAppKey:(NSString *)appKey {
    self.tencentAppKey = appKey;
}

/*!
 * @method
 * @brief 注册微信配置信息
 * @discussion
 * @param appKey 微信AppID
 * @param appSecret 微信AppSecret
 */
- (void)registerWechatAppID:(NSString *)appID appSecret:(NSString *)appSecret {
    self.wechatAppID = appID;
    self.wechatAppSecret = appSecret;
    
    [WXApi registerApp:self.wechatAppID];
}

- (void)showShareMenuOnView:(UIView *)theView
{
    CWShareView *shareView = [[CWShareView alloc] init];
    [shareView showWithType:nil onView:theView actionBlock:^(CWShareType shareType) {
        [delegate shareMenuDidSelect:shareType];
    }];
}

- (void)showHorizontalMenuOnView:(UIView *)theView withActionOptions:(CWActionItemOptions)actionOptions selectBlock:(void (^)(CWMenuItem))menuItemBlock {
    
    CWShareView *shareView = [[CWShareView alloc] init];
    [shareView showHorizontalShareMenu:CWShareItemSina|CWShareItemQQZone|CWShareItemQQ|CWShareItemWechatSession|CWShareItemWechatTimeline andActionMenu:actionOptions onView:theView menuBlock:menuItemBlock];
}

+ (void)handleOpenUrl:(NSURL *)url
{
    [WeiboSDK handleOpenURL:url delegate:[[CWShare shareObject] sinaShare]];
    [QQApiInterface handleOpenURL:url delegate:[[CWShare shareObject] tencentShare]];
    [TencentOAuth HandleOpenURL:url];
    [WXApi handleOpenURL:url delegate:[[CWShare shareObject] wechatShare]];
    
//    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
//
//    } else if ([sourceApplication isEqualToString:@"com.tencent.mqq"] || [sourceApplication isEqualToString:@"com.apple.mobilesafari"]) {
//        
//    } else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
//        
//    }
}

#pragma mark - Sina Operate Method

- (void)startSinaAuthorizeLogin
{
    [sinaShare startAuthorize];
}

- (void)sinaShareWithContent:(NSString *)theContent
{
    if ([theContent length] != 0) {
        [sinaShare shareWithContent:theContent];
    } else {
        NSLog(@"sina shareContent 分享文字不可为空");
    }
}

- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    if ([theContent length] != 0 && theImage != nil) {
        [sinaShare shareWithContent:theContent withImage:theImage];
    } else if (theImage != nil) {
        NSLog(@"sina shareContentAndImage 分享文字不可为空");
    } else {
        NSLog(@"sina shareContentAndImage 分享图片不可为空");
    }
}

#pragma mark - Override Copy

- (void)copyUrlToPasteboard:(NSString *)urlString {
    [self copy:urlString];
}

- (void)copy:(id)sender {
    NSString *urlString = (NSString *)sender;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:urlString];
}

#pragma mark - Tencent Operate Method

- (void)startTencentAuthorizeLogin
{
    [tencentShare startAuthorize];
}

- (void)tencentShareToWeiBoWithContent:(NSString *)theContent
{
    if ([theContent length] != 0) {
        [tencentShare shareToWeiBoWithContent:theContent];
    } else {
        NSLog(@"tencentWeibo shareContent 分享文字不可为空");
    }
}

- (void)tencentShareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    if ([theContent length] != 0 && theImage != nil) {
        [tencentShare shareToWeiBoWithContent:theContent withImage:theImage];
    } else if (theImage != nil) {
        NSLog(@"tencentWeibo shareContentAndImage 分享文字不可为空");
    } else {
        NSLog(@"tencentWeibo shareContentAndImage 分享图片不可为空");
    }
}

- (void)tencentShareToQQZoneWithTitle:(NSString *)theTitle withDescription:(NSString *)theDesc withImage:(UIImage *)theImage targetUrl:(NSString *)theUrl
{
    if ([theUrl length] != 0) {
        [tencentShare shareToQQZoneWithTitle:theTitle withDescription:theDesc withImage:theImage targetUrl:theUrl];
    } else {
        NSLog(@"tencentQQZone shareNews 分享URL不可为空");
    }
}

- (void)tencentShareToQQWithContent:(NSString *)theContent
{
    if ([theContent length] != 0) {
        [tencentShare shareToQQWithContent:theContent];
    } else {
        NSLog(@"tencentQQ shareContent 分享文字不可为空");
    }
}

- (void)tencentShareToQQWithImage:(UIImage *)theImage
{
    if (theImage != nil) {
        [tencentShare shareToQQWithImage:theImage];
    } else {
        NSLog(@"tencentQQ shareImage 分享图片不可为空");
    }
}

- (void)tencentShareToQQWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withTargetUrl:(NSString *)theUrl
{
    if ([theUrl length] != 0) {
        [tencentShare shareToQQWithTitle:theTitle withContent:theContent withImage:theImage withTargetUrl:theUrl];
    } else {
        NSLog(@"tencentQQ shareNews 分享URL不可为空");
    }
}

#pragma mark - Management Authorize Info

- (void)clearSinaAuthorizeInfo
{
    [sinaShare clearAuthorizeInfo];
}

- (void)clearTencentAuthorizeInfo
{
    [tencentShare clearAuthorizeInfo];
}

- (void)clearWechatAuthorizeInfo
{
    [wechatShare clearAuthorizeInfo];
}

#pragma mark - Sina Authorize Delegate Method

- (void)sinaShareAuthorizeFail
{
    if ([delegate respondsToSelector:@selector(loginFailForShareType:)]) {
        [delegate loginFailForShareType:CWShareLoginTypeSina];
    }
}

- (void)sinaShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareLoginTypeSina withData:userInfo];
}

#pragma mark - Tencent Authorize Delegate Method

- (void)tencentShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareLoginTypeQQ];
}

- (void)tencentShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareLoginTypeQQ withData:userInfo];
}

#pragma mark - Sina Share Delegate Method

- (void)sinaShareContentFail
{
    [delegate shareFailForShareType:CWShareTypeSina];
}

- (void)sinaShareContentFinish
{
    [delegate shareFinishForShareType:CWShareTypeSina];
}

- (void)sinaShareContentAndImageFail
{
    [delegate shareFailForShareType:CWShareTypeSina];
}

- (void)sinaShareContentAndImageFinish
{
    [delegate shareFinishForShareType:CWShareTypeSina];
}

#pragma mark - Tencent Share Delegate Method

- (void)tencentShareContentFail
{
    [delegate shareFailForShareType:tencentShare.shareTencentType];
}

- (void)tencentShareContentFinish
{
    [delegate shareFinishForShareType:tencentShare.shareTencentType];
}

- (void)tencentShareContentAndImageFail
{
    [delegate shareFailForShareType:tencentShare.shareTencentType];
}

- (void)tencentShareContentAndImageFinish
{
    [delegate shareFinishForShareType:tencentShare.shareTencentType];
}

#pragma mark - Wechat Share Method

- (void)startWechatAuthorizeLogin
{
    [shareInstance.wechatShare startAuthorize];
}

- (void)wechatSessionShareWithTitle:(NSString *)theTitle
{
    [shareInstance.wechatShare sessionShareWithTitle:theTitle];
}

- (void)wechatSessionShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage  withWebUrl:(NSString *)theUrl
{
    [shareInstance.wechatShare sessionShareWithTitle:theTitle withContent:theContent withImage:theImage withWebUrl:theUrl];
}

- (void)wechatTimelineShareWithTitle:(NSString *)theTitle
{
    [shareInstance.wechatShare timelineShareWithTitle:theTitle];
}

- (void)wechatTimelineShareWithTitle:(NSString *)theTitle withImage:(UIImage *)theImage  withWebUrl:(NSString *)theUrl
{
    [shareInstance.wechatShare timelineShareWithTitle:theTitle withImage:theImage withWebUrl:theUrl];
}

#pragma mark - Wechat Delegate

- (void)wechatShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareLoginTypeWechat withData:userInfo];
}

- (void)wechatShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareLoginTypeWechat];
}

- (void)wechatShareFinish
{
    [delegate shareFinishForShareType:wechatShare.shareWechatType];
}

- (void)wechatShareFail
{
    [delegate shareFailForShareType:wechatShare.shareWechatType];
}

#pragma mark - parentViewController Setter And Getter Method

- (void)setParentViewController:(UIViewController *)_parentViewController
{
    sinaShare.parentViewController = _parentViewController;
    tencentShare.parentViewController = _parentViewController;
}

- (UIViewController *)parentViewController
{
    return parentViewController;
}

@end
