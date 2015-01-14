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

#define kButtonTag_Sina 3
#define kButtonTag_WechatSession 4
#define kButtonTag_WechatTimeline 5
#define kButtonTag_Tencent 6
#define kButtonTag_Message 7
#define kButtonTag_Mail 8
#define kButtonTag_tdCode 9

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

- (id)shareMenuView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIActionSheet *actionSheet = nil;
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [actionSheet setTintColor:[UIColor colorWithRed:204/255.0 green:31/255.0 blue:36/255.0 alpha:1.0]];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenWidth, 21)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [titleLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [titleLabel setTextColor:[UIColor whiteColor]];
        }
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setText:@"邀请方式"];
        [actionSheet addSubview:titleLabel];
        
        UIButton *wechatSessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatSessionButton setFrame:CGRectMake(22, 60, 60, 60)];
        [wechatSessionButton setImage:[UIImage imageNamed:@"ic_share_weix"] forState:UIControlStateNormal];
        [wechatSessionButton setTag:kButtonTag_WechatSession];
        [wechatSessionButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatSessionButton];
        
        UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 123, 60, 16)];
        [wechatSessionLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [wechatSessionLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [wechatSessionLabel setTextColor:[UIColor whiteColor]];
        }
        [wechatSessionLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatSessionLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatSessionLabel setText:@"微信好友"];
        [actionSheet addSubview:wechatSessionLabel];
        
        UIButton *wechatTimelineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatTimelineButton setFrame:CGRectMake(94, 60, 60, 60)];
        [wechatTimelineButton setImage:[UIImage imageNamed:@"ic_share_pyq"] forState:UIControlStateNormal];
        [wechatTimelineButton setTag:kButtonTag_WechatTimeline];
        [wechatTimelineButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatTimelineButton];
        
        UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 123, 60, 16)];
        [wechatTimelineLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [wechatTimelineLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [wechatTimelineLabel setTextColor:[UIColor whiteColor]];
        }
        [wechatTimelineLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatTimelineLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatTimelineLabel setText:@"朋友圈"];
        [actionSheet addSubview:wechatTimelineLabel];
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton setFrame:CGRectMake(166, 60, 60, 60)];
        [sinaButton setImage:[UIImage imageNamed:@"ic_share_weibo"] forState:UIControlStateNormal];
        [sinaButton setTag:kButtonTag_Sina];
        [sinaButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:sinaButton];
        
        UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(166, 123, 60, 16)];
        [sinaLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [sinaLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [sinaLabel setTextColor:[UIColor whiteColor]];
        }
        [sinaLabel setTextAlignment:NSTextAlignmentCenter];
        [sinaLabel setFont:[UIFont systemFontOfSize:14]];
        [sinaLabel setText:@"新浪微博"];
        [actionSheet addSubview:sinaLabel];
        
        UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tencentButton setFrame:CGRectMake(238, 60, 60, 60)];
        [tencentButton setImage:[UIImage imageNamed:@"ic_share_qq"] forState:UIControlStateNormal];
        [tencentButton setTag:kButtonTag_Tencent];
        [tencentButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:tencentButton];
        
        UILabel *tencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(238, 123, 60, 16)];
        [tencentLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [tencentLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [tencentLabel setTextColor:[UIColor whiteColor]];
        }
        [tencentLabel setTextAlignment:NSTextAlignmentCenter];
        [tencentLabel setFont:[UIFont systemFontOfSize:14]];
        [tencentLabel setText:@"QQ"];
        [actionSheet addSubview:tencentLabel];
        
        UIButton *shortMsgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shortMsgButton setFrame:CGRectMake(22, 170, 60, 60)];
        [shortMsgButton setImage:[UIImage imageNamed:@"ic_share_messages"] forState:UIControlStateNormal];
        [shortMsgButton setTag:kButtonTag_Message];
        [shortMsgButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:shortMsgButton];
        
        UILabel *shortMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 233, 60, 16)];
        [shortMsgLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [shortMsgLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [shortMsgLabel setTextColor:[UIColor whiteColor]];
        }
        [shortMsgLabel setTextAlignment:NSTextAlignmentCenter];
        [shortMsgLabel setFont:[UIFont systemFontOfSize:14]];
        [shortMsgLabel setText:@"短信"];
        [actionSheet addSubview:shortMsgLabel];
        
        UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mailButton setFrame:CGRectMake(94, 170, 60, 60)];
        [mailButton setImage:[UIImage imageNamed:@"ic_share_mail"] forState:UIControlStateNormal];
        [mailButton setTag:kButtonTag_Mail];
        [mailButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:mailButton];
        
        UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 233, 60, 16)];
        [mailLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [mailLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [mailLabel setTextColor:[UIColor whiteColor]];
        }
        [mailLabel setTextAlignment:NSTextAlignmentCenter];
        [mailLabel setFont:[UIFont systemFontOfSize:14]];
        [mailLabel setText:@"邮件"];
        [actionSheet addSubview:mailLabel];
        
        UIButton *tdCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tdCodeButton setFrame:CGRectMake(166, 170, 60, 60)];
        [tdCodeButton setImage:[UIImage imageNamed:@"ic_share_dcode"] forState:UIControlStateNormal];
        [tdCodeButton setTag:kButtonTag_tdCode];
        [tdCodeButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:tdCodeButton];
        
        UILabel *tdCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(166, 233, 60, 16)];
        [tdCodeLabel setBackgroundColor:[UIColor clearColor]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [tdCodeLabel setTextColor:[UIColor darkGrayColor]];
        } else {
            [tdCodeLabel setTextColor:[UIColor whiteColor]];
        }
        [tdCodeLabel setTextAlignment:NSTextAlignmentCenter];
        [tdCodeLabel setFont:[UIFont systemFontOfSize:14]];
        [tdCodeLabel setText:@"二维码"];
        [actionSheet addSubview:tdCodeLabel];
        
        return actionSheet;
    } else {
        CGFloat widthSpace = (screenWidth-240-14-14-8-8)/3;
        
        UIAlertController *searchActionSheet = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [searchActionSheet.view setTintColor:[UIColor colorWithRed:204/255.0 green:31/255.0 blue:36/255.0 alpha:1.0]];
        [searchActionSheet.view.layer setMasksToBounds:YES];
        [searchActionSheet.view.layer setCornerRadius:4];
        [searchActionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]];
        
        UIView *actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-16, 240)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenWidth-16, 21)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setText:@"邀请方式"];
        [actionSheet addSubview:titleLabel];
        
        UIButton *wechatSessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatSessionButton setFrame:CGRectMake(14, 60, 60, 60)];
        [wechatSessionButton setImage:[UIImage imageNamed:@"ic_share_weix"] forState:UIControlStateNormal];
        [wechatSessionButton setTag:kButtonTag_WechatSession];
        [wechatSessionButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatSessionButton];
        
        UILabel *wechatSessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 123, 60, 16)];
        [wechatSessionLabel setBackgroundColor:[UIColor clearColor]];
        [wechatSessionLabel setTextColor:[UIColor darkGrayColor]];
        [wechatSessionLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatSessionLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatSessionLabel setText:@"微信好友"];
        [actionSheet addSubview:wechatSessionLabel];
        
        UIButton *wechatTimelineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatTimelineButton setFrame:CGRectMake(14+60+widthSpace, 60, 60, 60)];
        [wechatTimelineButton setImage:[UIImage imageNamed:@"ic_share_pyq"] forState:UIControlStateNormal];
        [wechatTimelineButton setTag:kButtonTag_WechatTimeline];
        [wechatTimelineButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:wechatTimelineButton];
        
        UILabel *wechatTimelineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14+60+widthSpace, 123, 60, 16)];
        [wechatTimelineLabel setBackgroundColor:[UIColor clearColor]];
        [wechatTimelineLabel setTextColor:[UIColor darkGrayColor]];
        [wechatTimelineLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatTimelineLabel setFont:[UIFont systemFontOfSize:14]];
        [wechatTimelineLabel setText:@"朋友圈"];
        [actionSheet addSubview:wechatTimelineLabel];
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sinaButton setFrame:CGRectMake(14+60*2+widthSpace*2, 60, 60, 60)];
        [sinaButton setImage:[UIImage imageNamed:@"ic_share_weibo"] forState:UIControlStateNormal];
        [sinaButton setTag:kButtonTag_Sina];
        [sinaButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:sinaButton];
        
        UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(14+60*2+widthSpace*2, 123, 60, 16)];
        [sinaLabel setBackgroundColor:[UIColor clearColor]];
        [sinaLabel setTextColor:[UIColor darkGrayColor]];
        [sinaLabel setTextAlignment:NSTextAlignmentCenter];
        [sinaLabel setFont:[UIFont systemFontOfSize:14]];
        [sinaLabel setText:@"新浪微博"];
        [actionSheet addSubview:sinaLabel];
        
        UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tencentButton setFrame:CGRectMake(14+60*3+widthSpace*3, 60, 60, 60)];
        [tencentButton setImage:[UIImage imageNamed:@"ic_share_qq"] forState:UIControlStateNormal];
        [tencentButton setTag:kButtonTag_Tencent];
        [tencentButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:tencentButton];
        
        UILabel *tencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14+60*3+widthSpace*3, 123, 60, 16)];
        [tencentLabel setBackgroundColor:[UIColor clearColor]];
        [tencentLabel setTextColor:[UIColor darkGrayColor]];
        [tencentLabel setTextAlignment:NSTextAlignmentCenter];
        [tencentLabel setFont:[UIFont systemFontOfSize:14]];
        [tencentLabel setText:@"QQ"];
        [actionSheet addSubview:tencentLabel];
        
        UIButton *shortMsgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shortMsgButton setFrame:CGRectMake(14, 170, 60, 60)];
        [shortMsgButton setImage:[UIImage imageNamed:@"ic_share_messages"] forState:UIControlStateNormal];
        [shortMsgButton setTag:kButtonTag_Message];
        [shortMsgButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:shortMsgButton];
        
        UILabel *shortMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 233, 60, 16)];
        [shortMsgLabel setBackgroundColor:[UIColor clearColor]];
        [shortMsgLabel setTextColor:[UIColor darkGrayColor]];
        [shortMsgLabel setTextAlignment:NSTextAlignmentCenter];
        [shortMsgLabel setFont:[UIFont systemFontOfSize:14]];
        [shortMsgLabel setText:@"短信"];
        [actionSheet addSubview:shortMsgLabel];
        
        UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mailButton setFrame:CGRectMake(14+60+widthSpace, 170, 60, 60)];
        [mailButton setImage:[UIImage imageNamed:@"ic_share_mail"] forState:UIControlStateNormal];
        [mailButton setTag:kButtonTag_Mail];
        [mailButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:mailButton];
        
        UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(14+60+widthSpace, 233, 60, 16)];
        [mailLabel setBackgroundColor:[UIColor clearColor]];
        [mailLabel setTextColor:[UIColor darkGrayColor]];
        [mailLabel setTextAlignment:NSTextAlignmentCenter];
        [mailLabel setFont:[UIFont systemFontOfSize:14]];
        [mailLabel setText:@"邮件"];
        [actionSheet addSubview:mailLabel];
        
        UIButton *tdCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tdCodeButton setFrame:CGRectMake(14+60*2+widthSpace*2, 170, 60, 60)];
        [tdCodeButton setImage:[UIImage imageNamed:@"ic_share_dcode"] forState:UIControlStateNormal];
        [tdCodeButton setTag:kButtonTag_tdCode];
        [tdCodeButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [actionSheet addSubview:tdCodeButton];
        
        UILabel *tdCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14+60*2+widthSpace*2, 233, 60, 16)];
        [tdCodeLabel setBackgroundColor:[UIColor clearColor]];
        [tdCodeLabel setTextColor:[UIColor darkGrayColor]];
        [tdCodeLabel setTextAlignment:NSTextAlignmentCenter];
        [tdCodeLabel setFont:[UIFont systemFontOfSize:14]];
        [tdCodeLabel setText:@"二维码"];
        [actionSheet addSubview:tdCodeLabel];
        
        [searchActionSheet.view addSubview:actionSheet];
        
        self.alertViewCtrl = searchActionSheet;
        
        return searchActionSheet;
    }
}

+ (void)handleOpenUrl:(NSURL *)url sourceApp:(NSString *)sourceApplication
{
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
//        [[[CWShare shareObject] sinaShare] handleOpenURL:url];
        [WeiboSDK handleOpenURL:url delegate:[[CWShare shareObject] sinaShare]];
    } else if ([sourceApplication isEqualToString:@"com.tencent.mqq"] || [sourceApplication isEqualToString:@"com.apple.mobilesafari"]) {
        [QQApiInterface handleOpenURL:url delegate:[[CWShare shareObject] tencentShare]];
        [TencentOAuth HandleOpenURL:url];
    } else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        [WXApi handleOpenURL:url delegate:[[CWShare shareObject] wechatShare]];
    }
}

#pragma mark - UIControl Event Method

- (IBAction)shareButtonAction:(UIButton *)sender
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.alertViewCtrl dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = (UIActionSheet *)sender.superview;
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    if (sender.tag == kButtonTag_Sina) {
        [delegate shareMenuDidSelect:CWShareTypeSina];
    } else if (sender.tag == kButtonTag_WechatSession) {
        [delegate shareMenuDidSelect:CWShareTypeWechatSession];
    } else if (sender.tag == kButtonTag_WechatTimeline) {
        [delegate shareMenuDidSelect:CWShareTypeWechatTimeline];
    } else if (sender.tag == kButtonTag_Tencent) {
        [delegate shareMenuDidSelect:CWShareTypeQQ];
    } else if (sender.tag == kButtonTag_Message) {
        [delegate shareMenuDidSelect:CWShareTypeMessage];
    } else if (sender.tag == kButtonTag_Mail) {
        [delegate shareMenuDidSelect:CWShareTypeMail];
    } else if (sender.tag == kButtonTag_tdCode) {
        [delegate shareMenuDidSelect:CWShareTypeDtCode];
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
    [delegate loginFailForShareType:CWShareLoginTypeSina];
}

- (void)sinaShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareLoginTypeSina withData:userInfo];
}

#pragma mark - Tencent Authorize Delegate Method

- (void)tencentShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareLoginTypeTencent];
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

- (void)wechatTimelineShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage  withWebUrl:(NSString *)theUrl
{
    [cwShare.wechatShare timelineShareWithTitle:theTitle withContent:theContent withImage:theImage withWebUrl:theUrl];
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
