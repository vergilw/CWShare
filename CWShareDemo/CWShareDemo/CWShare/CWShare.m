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

- (void)tencentShareWithContent:(NSString *)theContent
{
    [tencentShare shareWithContent:theContent];
}

- (void)tencentShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    [tencentShare shareWithContent:theContent withImage:theImage];
}

#pragma mark - CWShare Sina Authorize Delegate Method

- (void)sinaShareAuthorizeFail
{
    [delegate authorizeFailForShareType:CWShareTypeSina];
}

- (void)sinaShareAuthorizeFinish
{
    [delegate authorizeFinishForShareType:CWShareTypeSina];
}

#pragma mark - CWShare Tencent Authorize Delegate Method

- (void)tencentShareAuthorizeFail
{
    [delegate authorizeFailForShareType:CWShareTypeTencent];
}

- (void)tencentShareAuthorizeFinish
{
    [delegate authorizeFinishForShareType:CWShareTypeTencent];
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
