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

@synthesize tencentAccessToken,tencentExpireDate,tencentOpenID,delegate,tencentRequest;

- (void)dealloc
{
    [self setTencentAccessToken:nil];
    [self setTencentExpireDate:nil];
    [self setTencentOpenID:nil];
    [tencentRequest clearDelegatesAndCancel];
    [self setTencentRequest:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.tencentAccessToken = [CWShareStorage getTencentAccessToken];
        self.tencentExpireDate = [CWShareStorage getTencentExpiredDate];
        self.tencentOpenID = [CWShareStorage getTencentUserID];
    }
    return self;
}

#pragma mark - Share Method

- (void)shareWithContent:(NSString *)theContent
{
    if ([self isAuthorizeExpired]) {
        NSLog(@"授权Token过期，需要重新授权");
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
        NSLog(@"授权Token过期，需要重新授权");
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
        [tencentRequest setDidFailSelector:@selector(shareContentFail:)];
        [tencentRequest setDelegate:self];
        [tencentRequest startAsynchronous];
    }
}

#pragma mark - Authorize Method


- (void)startAuthorize
{
    if (delegate == nil) {
        NSLog(@"tencent没有设置代理");
    } else {
        if ([delegate isKindOfClass:[UIViewController class]]) {
            CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
            [tencentAuthorize setDelegate:self];
            [[(UIViewController *)delegate navigationController] pushViewController:tencentAuthorize animated:YES];
            [tencentAuthorize release];
        } else {
            NSLog(@"CWShare代理应该属于UIViewController");
        }
    }
}

- (BOOL)isAuthorizeExpired
{
    if ([tencentExpireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - CWShareSinaAuthorize Delegate

- (void)tencentAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withOpenID:(NSString *)theOpenID withUserInfo:(NSDictionary *)userInfo
{
    self.tencentAccessToken = accessToken;
    self.tencentExpireDate = [NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]];
    self.tencentOpenID = theOpenID;
    [delegate tencentShareAuthorizeFinish];
}

- (void)tencentAuthorizeFail
{
    [delegate tencentShareAuthorizeFail];
}

#pragma mark - ASIHttpRequest Share Content Delegate

- (void)shareContentFail:(ASIFormDataRequest *)request
{
    NSLog(@"%@", [[request error] localizedDescription]);
}

- (void)shareContentFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data objectForKey:@"ret"] integerValue] == 0) {
        
    } else {
        NSLog(@"errcode:%@,error:%@", [data objectForKey:@"errcode"], [data objectForKey:@"msg"]);
    }
}

- (void)shareContentAndImageFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        return;
    }
    if ([[data objectForKey:@"ret"] integerValue] == 0) {
        
    } else {
        NSLog(@"errcode:%@,error:%@", [data objectForKey:@"errcode"], [data objectForKey:@"msg"]);
    }
}

@end
