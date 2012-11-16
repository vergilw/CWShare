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

@synthesize sinaAccessToken,sinaExpireDate,sinaUID,delegate,sinaRequest,
parentViewController,shareContent,shareImage;

#pragma mark - Memory Management Method

- (void)dealloc
{
    [self setSinaAccessToken:nil];
    [self setSinaExpireDate:nil];
    [self setSinaUID:nil];
    [sinaRequest clearDelegatesAndCancel];
    [self setSinaRequest:nil];
    [self setShareContent:nil];
    [self setShareImage:nil];
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
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            sinaShareType = SinaShareContent;
            self.shareContent = theContent;
            
            CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
            [sinaAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
            [sinaAuthorize release];
        }
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
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            sinaShareType = SinaShareContentAndImage;
            self.shareContent = theContent;
            self.shareImage = theImage;
            
            CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
            [sinaAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
            [sinaAuthorize release];
        }
    } else {
        self.sinaRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
        [sinaRequest setPostFormat:ASIMultipartFormDataPostFormat];
        [sinaRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaRequest setPostValue:theContent forKey:@"status"];
        [sinaRequest setData:UIImageJPEGRepresentation(theImage, 1) forKey:@"pic"];
        [sinaRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [sinaRequest setDidFailSelector:@selector(shareContentAndImageFail:)];
        [sinaRequest setDelegate:self];
        [sinaRequest startAsynchronous];
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
        sinaShareType = SinaShareNone;
        
        CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
        [sinaAuthorize setDelegate:self];
        [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
        [sinaAuthorize release];
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
    [CWShareStorage setSinaAccessToken:sinaAccessToken];
    [CWShareStorage setSinaExpiredDate:sinaExpireDate];
    [CWShareStorage setSinaUserID:sinaUID];
    
    if (sinaShareType == SinaShareNone) {
        [delegate sinaShareAuthorizeFinish];
    } else if (sinaShareType == SinaShareContent) {
        self.sinaRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"]];
        [sinaRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaRequest setPostValue:shareContent forKey:@"status"];
        [sinaRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [sinaRequest setDidFailSelector:@selector(shareContentFail:)];
        [sinaRequest setDelegate:self];
        [sinaRequest startAsynchronous];
    } else if (sinaShareType == SinaShareContentAndImage) {
        self.sinaRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
        [sinaRequest setPostFormat:ASIMultipartFormDataPostFormat];
        [sinaRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaRequest setPostValue:shareContent forKey:@"status"];
        [sinaRequest setData:UIImageJPEGRepresentation(shareImage, 1) forKey:@"pic"];
        [sinaRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [sinaRequest setDidFailSelector:@selector(shareContentAndImageFail:)];
        [sinaRequest setDelegate:self];
        [sinaRequest startAsynchronous];
    }
    
}

- (void)sinaAuthorizeFail
{
    NSLog(@"sina authorize 没有网络连接");
    [delegate sinaShareAuthorizeFail];
}

#pragma mark - ASIHttpRequest Share Content Delegate

- (void)shareContentFail:(ASIFormDataRequest *)request
{
    NSLog(@"sina shareContent 没有网络连接");
    [delegate sinaShareContentFail];
}

- (void)shareContentFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        NSLog(@"sina shareContent 返回Json格式错误");
        [delegate sinaShareContentFail];
        return;
    }
    if ([[data objectForKey:@"error"] length] == 0) {
        [delegate sinaShareContentFinish];
    } else {
        if ([[data objectForKey:@"error_code"] integerValue] == 21332) {
            [CWShareStorage clearTencentStoreInfo];
            self.sinaAccessToken = [CWShareStorage getSinaAccessToken];
            self.sinaExpireDate = [CWShareStorage getSinaExpiredDate];
            self.sinaUID = [CWShareStorage getSinaUserID];
        }
        NSLog(@"sina shareContent error_code:%@,error:%@", [data objectForKey:@"error_code"], [data objectForKey:@"error"]);
        [delegate sinaShareContentFail];
    }
}

- (void)shareContentAndImageFail:(ASIFormDataRequest *)request
{
    NSLog(@"sina shareContentAndImage 没有网络连接");
    [delegate sinaShareContentAndImageFail];
}

- (void)shareContentAndImageFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        NSLog(@"sina shareContentAndImage 返回Json格式错误");
        [delegate sinaShareContentAndImageFail];
        return;
    }
    if ([[data objectForKey:@"error"] length] == 0) {
        [delegate sinaShareContentAndImageFinish];
    } else {
        if ([[data objectForKey:@"error_code"] integerValue] == 21332) {
            [CWShareStorage clearTencentStoreInfo];
            self.sinaAccessToken = [CWShareStorage getSinaAccessToken];
            self.sinaExpireDate = [CWShareStorage getSinaExpiredDate];
            self.sinaUID = [CWShareStorage getSinaUserID];
        }
        NSLog(@"sina shareContentAndImage error_code:%@,error:%@", [data objectForKey:@"error_code"], [data objectForKey:@"error"]);
        [delegate sinaShareContentAndImageFail];
    }
}

@end
