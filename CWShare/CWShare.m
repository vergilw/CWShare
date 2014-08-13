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
#import <TencentOpenAPI/TencentOpenSDK.h>

#define kButtonTag_Sina 3
#define kButtonTag_WechatSession 4
#define kButtonTag_WechatTimeline 5
#define kButtonTag_Tencent 6
#define kButtonTag_Message 7
#define kButtonTag_Mail 8

static CWShare *cwShare = nil;

@implementation CWShare

@synthesize sinaShare,tencentShare,delegate,parentViewController,wechatShare;

+ (id)shareObject
{
    if (!cwShare) {
        cwShare = [[CWShare alloc] init];
        cwShare.sinaShare = [[CWShareSina alloc] init];
        [cwShare.sinaShare setDelegate:cwShare];
        
        cwShare.tencentShare = [[CWShareTencent alloc] init];
        [cwShare.tencentShare setDelegate:cwShare];
        
        cwShare.wechatShare = [[CWShareWeChat alloc] init];
        
    }
    return cwShare;
}

- (void)showShareMenu
{
    UIActionSheet *actionSheet = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 21)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setText:@"分享到"];
        [actionSheet addSubview:titleLabel];
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton setFrame:CGRectMake(30, 40, 60, 60)];
        [sinaButton setImage:[UIImage imageNamed:@"sina-ios7"] forState:UIControlStateNormal];
        [sinaButton setTag:kButtonTag_Sina];
//        [sinaButton.layer setShadowOpacity:0.3];
//        [sinaButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [sinaButton.layer setShadowOffset:CGSizeMake(0, 1)];
        [sinaButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:sinaButton];
        
        UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 60, 21)];
        [sinaLabel setBackgroundColor:[UIColor clearColor]];
        [sinaLabel setTextColor:[UIColor darkGrayColor]];
        [sinaLabel setTextAlignment:NSTextAlignmentCenter];
        [sinaLabel setFont:[UIFont systemFontOfSize:14]];
        [sinaLabel setText:@"新浪微博"];
        [actionSheet addSubview:sinaLabel];
        
        UIButton *wechatSessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatSessionButton setFrame:CGRectMake(130, 40, 60, 60)];
        [wechatSessionButton setImage:[UIImage imageNamed:@"session-ios7"] forState:UIControlStateNormal];
        [wechatSessionButton setTag:kButtonTag_WechatSession];
//        [wechatSessionButton.layer setShadowOpacity:0.3];
//        [wechatSessionButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [wechatSessionButton.layer setShadowOffset:CGSizeMake(0, 1)];
        [wechatSessionButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatSessionButton];
        
        UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 100, 60, 21)];
        [wechatSessionLabel setBackgroundColor:[UIColor clearColor]];
        [wechatSessionLabel setTextColor:[UIColor darkGrayColor]];
        [wechatSessionLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatSessionLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatSessionLabel setText:@"微信好友"];
        [actionSheet addSubview:wechatSessionLabel];
        
        UIButton *wechatTimelineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatTimelineButton setFrame:CGRectMake(230, 40, 60, 60)];
        [wechatTimelineButton setImage:[UIImage imageNamed:@"timeline-ios7"] forState:UIControlStateNormal];
        [wechatTimelineButton setTag:kButtonTag_WechatTimeline];
//        [wechatTimelineButton.layer setShadowOpacity:0.3];
//        [wechatTimelineButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [wechatTimelineButton.layer setShadowOffset:CGSizeMake(0, 1)];
        [wechatTimelineButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatTimelineButton];
        
        UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 100, 60, 21)];
        [wechatTimelineLabel setBackgroundColor:[UIColor clearColor]];
        [wechatTimelineLabel setTextColor:[UIColor darkGrayColor]];
        [wechatTimelineLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatTimelineLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatTimelineLabel setText:@"朋友圈"];
        [actionSheet addSubview:wechatTimelineLabel];
        
        UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tencentButton setFrame:CGRectMake(30, 130, 60, 60)];
        [tencentButton setImage:[UIImage imageNamed:@"tencent-ios7"] forState:UIControlStateNormal];
        [tencentButton setTag:kButtonTag_Tencent];
//        [tencentButton.layer setShadowOpacity:0.3];
//        [tencentButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [tencentButton.layer setShadowOffset:CGSizeMake(0, 1)];
        [tencentButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:tencentButton];
        
        UILabel *tencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 190, 60, 21)];
        [tencentLabel setBackgroundColor:[UIColor clearColor]];
        [tencentLabel setTextColor:[UIColor darkGrayColor]];
        [tencentLabel setTextAlignment:NSTextAlignmentCenter];
        [tencentLabel setFont:[UIFont systemFontOfSize:14]];
        [tencentLabel setText:@"腾讯微博"];
        [actionSheet addSubview:tencentLabel];
        
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setFrame:CGRectMake(130, 130, 60, 60)];
        [messageButton setImage:[UIImage imageNamed:@"message-ios7"] forState:UIControlStateNormal];
        [messageButton setTag:kButtonTag_Message];
//        [messageButton.layer setShadowOpacity:0.3];
//        [messageButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [messageButton.layer setShadowOffset:CGSizeMake(0, 1)];
        [messageButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:messageButton];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 190, 60, 21)];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextColor:[UIColor darkGrayColor]];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setFont:[UIFont systemFontOfSize:14]];
        [messageLabel setText:@"短信"];
        [actionSheet addSubview:messageLabel];
        
        UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mailButton setFrame:CGRectMake(230, 130, 60, 60)];
        [mailButton setImage:[UIImage imageNamed:@"mail-ios7"] forState:UIControlStateNormal];
        [mailButton setTag:kButtonTag_Mail];
//        [mailButton.layer setShadowOpacity:0.3];
//        [mailButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
//        [mailButton.layer setShadowOffset:CGSizeMake(0, 1)];
        [mailButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:mailButton];
        
        UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 190, 60, 21)];
        [mailLabel setBackgroundColor:[UIColor clearColor]];
        [mailLabel setTextColor:[UIColor darkGrayColor]];
        [mailLabel setTextAlignment:NSTextAlignmentCenter];
        [mailLabel setFont:[UIFont systemFontOfSize:14]];
        [mailLabel setText:@"邮件"];
        [actionSheet addSubview:mailLabel];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 21)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setText:@"分享到"];
        [actionSheet addSubview:titleLabel];
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton setFrame:CGRectMake(30, 40, 57, 57)];
        [sinaButton setImage:[UIImage imageNamed:@"sina-ios6"] forState:UIControlStateNormal];
        [sinaButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [sinaButton.layer setShadowOffset:CGSizeMake(0, 6)];
        [sinaButton setTag:kButtonTag_Sina];
        [sinaButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:sinaButton];
        
        UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 97, 57, 21)];
        [sinaLabel setBackgroundColor:[UIColor clearColor]];
        [sinaLabel setTextColor:[UIColor whiteColor]];
        [sinaLabel setTextAlignment:NSTextAlignmentCenter];
        [sinaLabel setFont:[UIFont systemFontOfSize:14]];
        [sinaLabel setText:@"新浪微博"];
        [actionSheet addSubview:sinaLabel];
        
        UIButton *wechatSessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatSessionButton setFrame:CGRectMake(130, 40, 57, 57)];
        [wechatSessionButton setImage:[UIImage imageNamed:@"session-ios6"] forState:UIControlStateNormal];
        [wechatSessionButton.layer setShadowOffset:CGSizeMake(0, 2)];
        [wechatSessionButton setTag:kButtonTag_WechatSession];
        [wechatSessionButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatSessionButton];
        
        UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 97, 57, 21)];
        [wechatSessionLabel setBackgroundColor:[UIColor clearColor]];
        [wechatSessionLabel setTextColor:[UIColor whiteColor]];
        [wechatSessionLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatSessionLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatSessionLabel setText:@"微信好友"];
        [actionSheet addSubview:wechatSessionLabel];
        
        UIButton *wechatTimelineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatTimelineButton setFrame:CGRectMake(230, 40, 57, 57)];
        [wechatTimelineButton setImage:[UIImage imageNamed:@"timeline-ios6"] forState:UIControlStateNormal];
        [wechatTimelineButton.layer setShadowOffset:CGSizeMake(0, 2)];
        [wechatTimelineButton setTag:kButtonTag_WechatTimeline];
        [wechatTimelineButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatTimelineButton];
        
        UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 97, 57, 21)];
        [wechatTimelineLabel setBackgroundColor:[UIColor clearColor]];
        [wechatTimelineLabel setTextColor:[UIColor whiteColor]];
        [wechatTimelineLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatTimelineLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatTimelineLabel setText:@"朋友圈"];
        [actionSheet addSubview:wechatTimelineLabel];
        
        UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tencentButton setFrame:CGRectMake(30, 138, 57, 57)];
        [tencentButton setImage:[UIImage imageNamed:@"tencent-ios6"] forState:UIControlStateNormal];
        [tencentButton.layer setShadowOffset:CGSizeMake(0, 2)];
        [tencentButton setTag:kButtonTag_Tencent];
        [tencentButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:tencentButton];
        
        UILabel *tencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 195, 57, 21)];
        [tencentLabel setBackgroundColor:[UIColor clearColor]];
        [tencentLabel setTextColor:[UIColor whiteColor]];
        [tencentLabel setTextAlignment:NSTextAlignmentCenter];
        [tencentLabel setFont:[UIFont systemFontOfSize:14]];
        [tencentLabel setText:@"腾讯微博"];
        [actionSheet addSubview:tencentLabel];
        
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setFrame:CGRectMake(130, 138, 57, 57)];
        [messageButton setImage:[UIImage imageNamed:@"message-ios6"] forState:UIControlStateNormal];
        [messageButton.layer setShadowOffset:CGSizeMake(0, 2)];
        [messageButton setTag:kButtonTag_Message];
        [messageButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:messageButton];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 195, 57, 21)];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setFont:[UIFont systemFontOfSize:14]];
        [messageLabel setText:@"短信"];
        [actionSheet addSubview:messageLabel];
        
        UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mailButton setFrame:CGRectMake(230, 138, 57, 57)];
        [mailButton setImage:[UIImage imageNamed:@"mail-ios6"] forState:UIControlStateNormal];
        [mailButton.layer setShadowOffset:CGSizeMake(0, 2)];
        [mailButton setTag:kButtonTag_Mail];
        [mailButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:mailButton];
        
        UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 195, 57, 21)];
        [mailLabel setBackgroundColor:[UIColor clearColor]];
        [mailLabel setTextColor:[UIColor whiteColor]];
        [mailLabel setTextAlignment:NSTextAlignmentCenter];
        [mailLabel setFont:[UIFont systemFontOfSize:14]];
        [mailLabel setText:@"邮件"];
        [actionSheet addSubview:mailLabel];
    }
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIControl Event Method

- (IBAction)shareButtonAction:(UIButton *)sender
{
    UIActionSheet *actionSheet = (UIActionSheet *)sender.superview;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (sender.tag == kButtonTag_Sina) {
        [delegate shareMenuDidSelect:CWShareTypeSina];
    } else if (sender.tag == kButtonTag_WechatSession) {
        [delegate shareMenuDidSelect:CWShareTypeWechatSession];
    } else if (sender.tag == kButtonTag_WechatTimeline) {
        [delegate shareMenuDidSelect:CWShareTypeWechatTimeline];
    } else if (sender.tag == kButtonTag_Tencent) {
        [delegate shareMenuDidSelect:CWShareTypeTencent];
    } else if (sender.tag == kButtonTag_Message) {
        [delegate shareMenuDidSelect:CWShareTypeMessage];
    } else if (sender.tag == kButtonTag_Mail) {
        [delegate shareMenuDidSelect:CWShareTypeMail];
    }
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
    [CWShareStorage clearSinaStoreInfo];
    [sinaShare setSinaAccessToken:nil];
    [sinaShare setSinaTokenExpireDate:nil];
    [sinaShare setSinaUID:nil];
}

- (void)clearTencentAuthorizeInfo
{
    [CWShareStorage clearTencentStoreInfo];
    [tencentShare setTencentAccessToken:nil];
    [tencentShare setTencentTokenExpireDate:nil];
    [tencentShare setTencentOpenID:nil];
}

#pragma mark - Sina Authorize Delegate Method

- (void)sinaShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareTypeSina];
}

- (void)sinaShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareTypeSina withData:userInfo];
}

#pragma mark - Tencent Authorize Delegate Method

- (void)tencentShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareTypeTencent withData:userInfo];
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
    [delegate shareFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareContentFinish
{
    [delegate shareFinishForShareType:CWShareTypeTencent];
}

- (void)tencentShareContentAndImageFail
{
    [delegate shareFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareContentAndImageFinish
{
    [delegate shareFinishForShareType:CWShareTypeTencent];
}

#pragma mark - Wechat Share Method

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

- (void)wechatTimelineShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage  withWebUrl:(NSString *)theUrl
{
    [cwShare.wechatShare timelineShareWithTitle:theTitle withContent:theContent withImage:theImage withWebUrl:theUrl];
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

#pragma mark - Sina App Delegate

- (BOOL)shareHandleOpenURL:(NSURL *)url
{
    return [sinaShare handleOpenURL:url];
}

#pragma mark - QQ App Delegate

- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            if ([sendResp.result isEqualToString:@"0"]) {
                [delegate shareFinishForShareType:CWShareTypeQQ];
            } else {
                [delegate shareFailForShareType:CWShareTypeQQ];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
