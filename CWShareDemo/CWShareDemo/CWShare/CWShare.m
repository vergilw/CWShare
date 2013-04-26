//
//  CWShare.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShare.h"
#import "CWShareStorage.h"

static CWShare *cwShare = nil;

@implementation CWShare

@synthesize sinaShare,tencentShare,delegate,parentViewController;

- (void)dealloc
{
    [self setSinaShare:nil];
    [self setTencentShare:nil];
    [super dealloc];
}

+ (id)shareObject
{
    if (!cwShare) {
        cwShare = [[CWShare alloc] init];
        cwShare.sinaShare = [[[CWShareSina alloc] init] autorelease];
        [cwShare.sinaShare setDelegate:cwShare];
        
        cwShare.tencentShare = [[[CWShareTencent alloc] init] autorelease];
        [cwShare.tencentShare setDelegate:cwShare];
    }
    return cwShare;
}

#pragma mark - CWShare Sina Operate Method

- (void)startSinaAuthorizeLogin
{
    [sinaShare startAuthorize];
}

- (void)sinaShareWithContent:(NSString *)theContent
{
    [sinaShare shareWithContent:theContent];
}

- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    [sinaShare shareWithContent:theContent withImage:theImage];
}

#pragma mark - CWShare Tencent Operate Method

- (void)startTencentAuthorizeLogin
{
    [tencentShare startAuthorize];
}

- (void)tencentShareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent withSynchronizeWeibo:(BOOL)theBool
{
    [tencentShare shareToQQZoneWithDescription:theDesc withTitle:theTitle Content:theContent withSynchronizeWeibo:theBool];
}

- (void)tencentShareToWeiBoWithContent:(NSString *)theContent
{
    [tencentShare shareToWeiBoWithContent:theContent];
}

- (void)tencentShareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    [tencentShare shareToWeiBoWithContent:theContent withImage:theImage];
}

#pragma mark - CWShare Management Authorize Info

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

#pragma mark - CWShare Sina Authorize Delegate Method

- (void)sinaShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareTypeSina];
}

- (void)sinaShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareTypeSina withData:userInfo];
}

#pragma mark - CWShare Tencent Authorize Delegate Method

- (void)tencentShareAuthorizeFail
{
    [delegate loginFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate loginFinishForShareType:CWShareTypeTencent withData:userInfo];
}

#pragma mark - CWShare Sina Share Delegate Method

- (void)sinaShareContentFail
{
    [delegate shareContentFailForShareType:CWShareTypeSina];
}

- (void)sinaShareContentFinish
{
    [delegate shareContentFinishForShareType:CWShareTypeSina];
}

- (void)sinaShareContentAndImageFail
{
    [delegate shareContentAndImageFailForShareType:CWShareTypeSina];
}

- (void)sinaShareContentAndImageFinish
{
    [delegate shareContentAndImageFinishForShareType:CWShareTypeSina];
}

#pragma mark - CWShare Tencent Share Delegate Method

- (void)tencentShareContentFail
{
    [delegate shareContentFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareContentFinish
{
    [delegate shareContentFinishForShareType:CWShareTypeTencent];
}

- (void)tencentShareContentAndImageFail
{
    [delegate shareContentAndImageFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareContentAndImageFinish
{
    [delegate shareContentAndImageFinishForShareType:CWShareTypeTencent];
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

- (void)applicationDidBecomeActive
{
    [sinaShare applicationDidBecomeActive];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [sinaShare handleOpenURL:url];
}

@end
