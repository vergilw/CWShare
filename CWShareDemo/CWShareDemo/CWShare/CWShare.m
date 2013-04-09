//
//  CWShare.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShare.h"

@implementation CWShare

@synthesize sinaShare,tencentShare,delegate,parentViewController;

- (void)dealloc
{
    [self setSinaShare:nil];
    [self setTencentShare:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sinaShare = [[[CWShareSina alloc] init] autorelease];
        [sinaShare setDelegate:self];

        self.tencentShare = [[[CWShareTencent alloc] init] autorelease];
        [tencentShare setDelegate:self];
    }
    return self;
}

#pragma mark - CWShare Sina Operate Method

- (void)startSinaAuthorize
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

- (void)startTencentAuthorize
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

#pragma mark - CWShare Sina Authorize Delegate Method

- (void)sinaShareAuthorizeFail
{
    [delegate authorizeFailForShareType:CWShareTypeSina];
}

- (void)sinaShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate authorizeFinishForShareType:CWShareTypeSina withData:userInfo];
}

#pragma mark - CWShare Tencent Authorize Delegate Method

- (void)tencentShareAuthorizeFail
{
    [delegate authorizeFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareAuthorizeFinish:(NSDictionary *)userInfo
{
    [delegate authorizeFinishForShareType:CWShareTypeTencent withData:userInfo];
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

@end
