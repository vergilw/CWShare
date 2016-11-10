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

static CWShare *cwShare = nil;

@interface CWShare ()

@property (strong, nonatomic) UIAlertController *alertViewCtrl;

@end

@implementation CWShare

@synthesize sinaShare,tencentShare,delegate,parentViewController,wechatShare;

+ (CWShare *)shareObject
{
    if (!cwShare) {
        cwShare = [[CWShare alloc] init];
        cwShare.sinaShare = [[CWShareSina alloc] init];
        [cwShare.sinaShare setDelegate:cwShare];
        
        cwShare.tencentShare = [[CWShareQQ alloc] init];
        [cwShare.tencentShare setDelegate:cwShare];
        
        cwShare.wechatShare = [[CWShareWeChat alloc] init];
        [cwShare.wechatShare setDelegate:cwShare];
        
    }
    return cwShare;
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
    [cwShare.wechatShare startAuthorize];
}

- (void)wechatSessionShareWithTitle:(NSString *)theTitle
{
    [cwShare.wechatShare sessionShareWithTitle:theTitle];
}

- (void)wechatSessionShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage  withWebUrl:(NSString *)theUrl
{
    [cwShare.wechatShare sessionShareWithTitle:theTitle withContent:theContent withImage:theImage withWebUrl:theUrl];
}

- (void)wechatTimelineShareWithTitle:(NSString *)theTitle
{
    [cwShare.wechatShare timelineShareWithTitle:theTitle];
}

- (void)wechatTimelineShareWithTitle:(NSString *)theTitle withImage:(UIImage *)theImage  withWebUrl:(NSString *)theUrl
{
    [cwShare.wechatShare timelineShareWithTitle:theTitle withImage:theImage withWebUrl:theUrl];
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
