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

@synthesize tencentAccessToken,tencentAccessTokenExpireDate,
tencentOpenID,delegate,tencentRequest,
parentViewController,authorizeBlock;

- (void)dealloc
{
    [self setTencentAccessToken:nil];
    [self setTencentAccessTokenExpireDate:nil];
    [self setTencentOpenID:nil];
    [tencentRequest clearDelegatesAndCancel];
    [self setTencentRequest:nil];
    [self setAuthorizeBlock:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.tencentAccessToken = [CWShareStorage getTencentAccessToken];
        self.tencentAccessTokenExpireDate = [CWShareStorage getTencentExpiredDate];
        self.tencentOpenID = [CWShareStorage getTencentUserID];
    }
    return self;
}

#pragma mark - Share Method

- (void)shareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent withSynchronizeWeibo:(BOOL)theBool
{
    self.authorizeBlock = ^(void) {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://graph.qq.com/share/add_share"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:theDesc forKey:@"comment"];
        [tencentRequest setPostValue:theTitle forKey:@"title"];
        [tencentRequest setPostValue:theContent forKey:@"summary"];
        [tencentRequest setPostValue:QQZONE_DISPLAY_APP_URL forKey:@"url"];
        [tencentRequest setPostValue:QQZONE_DISPLAY_APP_URL forKey:@"fromurl"];
        [tencentRequest setPostValue:QQZONE_DISPLAY_NAME forKey:@"site"];
        if (theBool) {
            [tencentRequest setPostValue:@"0" forKey:@"nswb"];
        } else {
            [tencentRequest setPostValue:@"1" forKey:@"nswb"];
        }
        [tencentRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    };
    
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
            [tencentAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
            [tencentAuthorize release];
        }
    } else {
        authorizeBlock();
        [self setAuthorizeBlock:nil];
    }
}

- (void)shareToWeiBoWithContent:(NSString *)theContent
{
    self.authorizeBlock = ^(void) {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://graph.qq.com/t/add_t"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:theContent forKey:@"content"];
        [tencentRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    };
    
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
            [tencentAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
            [tencentAuthorize release];
        }
    } else {
        authorizeBlock();
        [self setAuthorizeBlock:nil];
    }
}

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    self.authorizeBlock = ^(void) {
        self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://graph.qq.com/t/add_pic_t"]];
        [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
        [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
        [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
        [tencentRequest setPostValue:theContent forKey:@"content"];
        [tencentRequest setData:UIImageJPEGRepresentation(theImage, 1) forKey:@"pic"];
        [tencentRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [tencentRequest setDidFailSelector:@selector(shareContentAndImageFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    };
    
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
            [tencentAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
            [tencentAuthorize release];
        }
    } else {
        authorizeBlock();
        [self setAuthorizeBlock:nil];
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
        self.authorizeBlock = ^(void) {
            self.tencentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://openmobile.qq.com/user/get_simple_userinfo"]];
            [tencentRequest setPostValue:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
            [tencentRequest setPostValue:tencentAccessToken forKey:@"access_token"];
            [tencentRequest setPostValue:tencentOpenID forKey:@"openid"];
            
            [tencentRequest setDidFinishSelector:@selector(authorizeFinish:)];
            [tencentRequest setDidFailSelector:@selector(authorizeFail:)];
            [tencentRequest setDelegate:self];
            [tencentRequest startAsynchronous];
        };
        
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

    if (authorizeBlock) {
        authorizeBlock();
        [self setAuthorizeBlock:nil];
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
        }
        NSLog(@"tencent shareContentAndImage errcode:%@,error:%@", [data objectForKey:@"errcode"], [data objectForKey:@"msg"]);
        [delegate tencentShareContentAndImageFail];
    }
}

@end
