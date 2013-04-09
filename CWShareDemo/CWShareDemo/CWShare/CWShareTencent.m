//
//  CWShareTencent.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import "CWShareTencent.h"
#import "CWShareStorage.h"
#import "SBJson.h"
#import "CWShareConfig.h"
#import "CWShareTools.h"

@implementation CWShareTencent

@synthesize tencentAccessToken,tencentRefreshToken,tencentAccessTokenExpireDate,
tencentOpenID,tencentRefreshTokenExpireDate,delegate,tencentRequest,
parentViewController,shareContent,shareImage;

- (void)dealloc
{
    [self setTencentAccessToken:nil];
    [self setTencentRefreshToken:nil];
    [self setTencentAccessTokenExpireDate:nil];
    [self setTencentOpenID:nil];
    [self setTencentRefreshTokenExpireDate:nil];
    [tencentRequest clearDelegatesAndCancel];
    [self setTencentRequest:nil];
    [self setShareContent:nil];
    [self setShareImage:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.tencentAccessToken = [CWShareStorage getTencentAccessToken];
        self.tencentAccessTokenExpireDate = [CWShareStorage getTencentExpiredDate];
        self.tencentOpenID = [CWShareStorage getTencentUserID];
        self.tencentRefreshToken = [CWShareStorage getTencentRefreshToken];
        self.tencentRefreshTokenExpireDate = [CWShareStorage getTencentRefreshTokenExpireDate];
    }
    return self;
}

#pragma mark - Share Method

- (void)shareWithContent:(NSString *)theContent
{
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            tencentShareType = TencentShareContent;
            self.shareContent = theContent;
            
            if (tencentAccessTokenExpireDate == nil || [tencentRefreshTokenExpireDate compare:[NSDate date]] == NSOrderedAscending) {
                CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
                [tencentAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
                [tencentAuthorize release];
            } else {
                self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/oauth2/access_token"]];
                [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"client_id"];
                [tencentRequest setPostValue:@"refresh_token" forKey:@"grant_type"];
                [tencentRequest setPostValue:tencentAccessToken forKey:@"refresh_token"];
                [tencentRequest setDidFinishSelector:@selector(refreshTokenFinish:)];
                [tencentRequest setDidFailSelector:@selector(refreshTokenFail:)];
                [tencentRequest setDelegate:self];
                [tencentRequest startAsynchronous];
            }
        }
    } else {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://open.t.qq.com/api/t/add"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:@"2.a" forKey:@"oauth_version"];
        [tencentRequest setPostValue:[CWShareTools getClientIp] forKey:@"clientip"];
        [tencentRequest setPostValue:@"json" forKey:@"format"];
        [tencentRequest setPostValue:@"all" forKey:@"scope"];
        [tencentRequest setPostValue:theContent forKey:@"content"];
        [tencentRequest setPostValue:@"1" forKey:@"syncflag"];
        [tencentRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    }
}

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            tencentShareType = TencentShareContentAndImage;
            self.shareContent = theContent;
            self.shareImage = theImage;
            
            if (tencentAccessTokenExpireDate == nil || [tencentRefreshTokenExpireDate compare:[NSDate date]] == NSOrderedAscending) {
                CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
                [tencentAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
                [tencentAuthorize release];
            } else {
                self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/oauth2/access_token"]];
                [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"client_id"];
                [tencentRequest setPostValue:@"refresh_token" forKey:@"grant_type"];
                [tencentRequest setPostValue:tencentAccessToken forKey:@"refresh_token"];
                [tencentRequest setDidFinishSelector:@selector(refreshTokenFinish:)];
                [tencentRequest setDidFailSelector:@selector(refreshTokenFail:)];
                [tencentRequest setDelegate:self];
                [tencentRequest startAsynchronous];
            }
        }
    } else {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://open.t.qq.com/api/t/add_pic"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:@"2.a" forKey:@"oauth_version"];
        [tencentRequest setPostValue:[CWShareTools getClientIp] forKey:@"clientip"];
        [tencentRequest setPostValue:@"json" forKey:@"format"];
        [tencentRequest setPostValue:@"all" forKey:@"scope"];
        [tencentRequest setPostValue:theContent forKey:@"content"];
        [tencentRequest setData:UIImageJPEGRepresentation(theImage, 1) forKey:@"pic"];
        [tencentRequest setPostValue:@"1" forKey:@"syncflag"];
        [tencentRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentAndImageFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    }
}

#pragma mark - Authorize Method


- (void)startAuthorize
{
    if (parentViewController == nil) {
        NSLog(@"CWShare没有设置parentViewController");
    } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
        NSLog(@"CWShare代理应该属于UIViewController");
    } else {
        tencentShareType = TencentShareNone;
        
        CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
        [tencentAuthorize setDelegate:self];
        [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
        [tencentAuthorize release];
    }
}

- (BOOL)isAuthorizeExpired
{
    if ([tencentAccessTokenExpireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - CWShareSinaAuthorize Delegate

- (void)tencentAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withOpenID:(NSString *)theOpenID
{
    self.tencentAccessToken = accessToken;
    self.tencentAccessTokenExpireDate = [NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]];
    self.tencentOpenID = theOpenID;

    [CWShareStorage setTencentAccessToken:tencentAccessToken];
    [CWShareStorage setTencentExpiredDate:tencentAccessTokenExpireDate];
    [CWShareStorage setTencentUserID:tencentOpenID];
    
    if (tencentShareType == TencentShareNone) {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://openmobile.qq.com/user/get_simple_userinfo"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];

        [tencentRequest setDidFinishSelector:@selector(authorizeFinish:)];
        [tencentRequest setDidFailSelector:@selector(authorizeFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    } else if (tencentShareType == TencentShareContent) {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://open.t.qq.com/api/t/add"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:@"2.a" forKey:@"oauth_version"];
        [tencentRequest setPostValue:[CWShareTools getClientIp] forKey:@"clientip"];
        [tencentRequest setPostValue:@"json" forKey:@"format"];
        [tencentRequest setPostValue:@"all" forKey:@"scope"];
        [tencentRequest setPostValue:shareContent forKey:@"content"];
        [tencentRequest setPostValue:@"1" forKey:@"syncflag"];
        [tencentRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    } else if (tencentShareType == TencentShareContentAndImage) {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://open.t.qq.com/api/t/add_pic"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:@"2.a" forKey:@"oauth_version"];
        [tencentRequest setPostValue:[CWShareTools getClientIp] forKey:@"clientip"];
        [tencentRequest setPostValue:@"json" forKey:@"format"];
        [tencentRequest setPostValue:@"all" forKey:@"scope"];
        [tencentRequest setPostValue:shareContent forKey:@"content"];
        [tencentRequest setData:UIImageJPEGRepresentation(shareImage, 1) forKey:@"pic"];
        [tencentRequest setPostValue:@"1" forKey:@"syncflag"];
        [tencentRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentAndImageFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    }
}

- (void)tencentAuthorizeFail
{
    NSLog(@"tencent authorize 没有网络连接");
    [delegate tencentShareAuthorizeFail];
}

#pragma mark - ASIHttpRequest Share Content Delegate

- (void)authorizeFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        NSLog(@"tencent authorize get user info 返回Json格式错误");
        [delegate tencentShareContentFail];
        return;
    }
    if ([[data objectForKey:@"ret"] integerValue] == 0) {
        [delegate tencentShareAuthorizeFinish:data];
    }
}

- (void)authorizeFail:(ASIFormDataRequest *)request
{
    NSLog(@"tencent shareContent get user info 没有网络连接");
    [delegate tencentShareAuthorizeFail];
}

- (void)shareContentFail:(ASIFormDataRequest *)request
{
    NSLog(@"tencent shareContent 没有网络连接");
    [delegate tencentShareAuthorizeFail];
}

- (void)shareContentFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        NSLog(@"tencent shareContent 返回Json格式错误");
        [delegate tencentShareContentFail];
        return;
    }
    if ([[data objectForKey:@"ret"] integerValue] == 0) {
        [delegate tencentShareContentFinish];
    } else {
        if ([[data objectForKey:@"errcode"] integerValue] == 36) {
            [CWShareStorage clearTencentStoreInfo];
            self.tencentAccessToken = [CWShareStorage getTencentAccessToken];
            self.tencentAccessTokenExpireDate = [CWShareStorage getTencentExpiredDate];
            self.tencentOpenID = [CWShareStorage getTencentUserID];
            self.tencentRefreshToken = [CWShareStorage getTencentRefreshToken];
            self.tencentRefreshTokenExpireDate = [CWShareStorage getTencentRefreshTokenExpireDate];
        }
        NSLog(@"tencent shareContent errcode:%@,error:%@", [data objectForKey:@"errcode"], [data objectForKey:@"msg"]);
        [delegate tencentShareContentFail];
    }
}

- (void)shareContentAndImageFail:(ASIFormDataRequest *)request
{
    NSLog(@"tencent shareContentAndImage 没有网络连接");
    [delegate tencentShareContentAndImageFail];
}

- (void)shareContentAndImageFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        NSLog(@"tencent shareContentAndImage 返回Json格式错误");
        [delegate tencentShareContentAndImageFail];
        return;
    }
    if ([[data objectForKey:@"ret"] integerValue] == 0) {
        [delegate tencentShareContentAndImageFinish];
    } else {
        if ([[data objectForKey:@"errcode"] integerValue] == 36) {
            [CWShareStorage clearTencentStoreInfo];
            self.tencentAccessToken = [CWShareStorage getTencentAccessToken];
            self.tencentAccessTokenExpireDate = [CWShareStorage getTencentExpiredDate];
            self.tencentOpenID = [CWShareStorage getTencentUserID];
            self.tencentRefreshToken = [CWShareStorage getTencentRefreshToken];
            self.tencentRefreshTokenExpireDate = [CWShareStorage getTencentRefreshTokenExpireDate];
        }
        NSLog(@"tencent shareContentAndImage errcode:%@,error:%@", [data objectForKey:@"errcode"], [data objectForKey:@"msg"]);
        [delegate tencentShareContentAndImageFail];
    }
}

@end
