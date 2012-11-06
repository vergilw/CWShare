//
//  CWShareSina.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShareSina.h"
#import "CWShareStorage.h"
#import "SBJson.h"

@implementation CWShareSina

@synthesize sinaAccessToken,sinaExpireDate,sinaUID,delegate,sinaRequest;

#pragma mark - Memory Management Method

- (void)dealloc
{
    [self setSinaAccessToken:nil];
    [self setSinaExpireDate:nil];
    [self setSinaUID:nil];
    [sinaRequest clearDelegatesAndCancel];
    [self setSinaRequest:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sinaAccessToken = [CWShareStorage getSinaAccessToken];
        self.sinaExpireDate = [CWShareStorage getSinaExpiredDate];
        self.sinaUID = [CWShareStorage getSinaUserID];
    }
    return self;
}

#pragma mark - Share Method

- (void)shareWithContent:(NSString *)theContent
{
    if ([self isAuthorizeExpired]) {
        NSLog(@"sina授权Token过期，需要重新授权");
    } else {
        self.sinaRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"]];
        [sinaRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaRequest setPostValue:theContent forKey:@"status"];
        [sinaRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [sinaRequest setDidFailSelector:@selector(shareContentFail:)];
        [sinaRequest setDelegate:self];
        [sinaRequest startAsynchronous];
    }
}

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    if ([self isAuthorizeExpired]) {
        NSLog(@"sina授权Token过期，需要重新授权");
    } else {
        self.sinaRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
        [sinaRequest setPostFormat:ASIMultipartFormDataPostFormat];
        [sinaRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaRequest setPostValue:theContent forKey:@"status"];
        [sinaRequest setData:UIImageJPEGRepresentation(theImage, 1) forKey:@"pic"];
        [sinaRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [sinaRequest setDidFailSelector:@selector(shareContentFail:)];
        [sinaRequest setDelegate:self];
        [sinaRequest startAsynchronous];
    }
}

#pragma mark - Authorize Method


- (void)startAuthorize
{
    if ([delegate isKindOfClass:[UIViewController class]]) {
        CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
        [sinaAuthorize setDelegate:self];
        [[(UIViewController *)delegate navigationController] pushViewController:sinaAuthorize animated:YES];
        [sinaAuthorize release];
    } else {
        NSLog(@"CWShare代理应该属于UIViewController");
    }
}

- (BOOL)isAuthorizeExpired
{
    if ([sinaExpireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - CWShareSinaAuthorize Delegate

- (void)sinaAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withUID:(NSString *)theUID
{
    self.sinaAccessToken = accessToken;
    self.sinaExpireDate = [NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]];
    self.sinaUID = theUID;
    [delegate sinaShareAuthorizeFinish];
}

- (void)sinaAuthorizeFail
{
    [delegate sinaShareAuthorizeFail];
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
    if ([[data objectForKey:@"error"] length] == 0) {
        
    } else {
        NSLog(@"error_code:%@,error:%@", [data objectForKey:@"error_code"], [data objectForKey:@"error"]);
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
    if ([[data objectForKey:@"error"] length] == 0) {
        
    } else {
        NSLog(@"error_code:%@,error:%@", [data objectForKey:@"error_code"], [data objectForKey:@"error"]);
    }
}

@end
