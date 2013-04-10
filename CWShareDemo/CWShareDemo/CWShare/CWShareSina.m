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

@synthesize sinaAccessToken,sinaExpireDate,sinaUID,delegate,sinaGetRequest,
sinaPostRequest,parentViewController,authorizeBlock;

#pragma mark - Memory Management Method

- (void)dealloc
{
    [self setSinaAccessToken:nil];
    [self setSinaExpireDate:nil];
    [self setSinaUID:nil];
    [sinaGetRequest clearDelegatesAndCancel];
    [self setSinaGetRequest:nil];
    [sinaPostRequest clearDelegatesAndCancel];
    [self setSinaPostRequest:nil];
    [self setAuthorizeBlock:nil];
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
    self.authorizeBlock = ^(void) {
        self.sinaPostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/2/statuses/update.json"]];
        [sinaPostRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaPostRequest setPostValue:theContent forKey:@"status"];
        [sinaPostRequest setDidFinishSelector:@selector(shareContentFinish:)];
        [sinaPostRequest setDidFailSelector:@selector(shareContentFail:)];
        [sinaPostRequest setDelegate:self];
        [sinaPostRequest startAsynchronous];
    };
    
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
            [sinaAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
            [sinaAuthorize release];
        }
    } else {
        authorizeBlock();
        [self setAuthorizeBlock:nil];
    }
}

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    self.authorizeBlock = ^(void) {
        self.sinaPostRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
        [sinaPostRequest setPostFormat:ASIMultipartFormDataPostFormat];
        [sinaPostRequest setPostValue:sinaAccessToken forKey:@"access_token"];
        [sinaPostRequest setPostValue:theContent forKey:@"status"];
        [sinaPostRequest setData:UIImageJPEGRepresentation(theImage, 1) forKey:@"pic"];
        [sinaPostRequest setDidFinishSelector:@selector(shareContentAndImageFinish:)];
        [sinaPostRequest setDidFailSelector:@selector(shareContentAndImageFail:)];
        [sinaPostRequest setDelegate:self];
        [sinaPostRequest startAsynchronous];
    };
    
    if ([self isAuthorizeExpired]) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            
            CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
            [sinaAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
            [sinaAuthorize release];
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
            self.sinaGetRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@", sinaUID, sinaAccessToken]]];
            [sinaGetRequest setDidFinishSelector:@selector(authorizeFinish:)];
            [sinaGetRequest setDidFailSelector:@selector(authorizeFail:)];
            [sinaGetRequest setDelegate:self];
            [sinaGetRequest startAsynchronous];
        };
        
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
    
    if (authorizeBlock) {
        authorizeBlock();
        [self setAuthorizeBlock:nil];
    }
}

- (void)sinaAuthorizeFail
{
    NSLog(@"sina authorize 没有网络连接");
    [delegate sinaShareAuthorizeFail];
}

#pragma mark - ASIHttpRequest Share Content Delegate

- (void)authorizeFail:(ASIFormDataRequest *)request
{
    NSLog(@"sina authorize get user info 没有网络连接");
    [delegate sinaShareAuthorizeFail];
}

- (void)authorizeFinish:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        NSLog(@"sina authorize get user info 返回Json格式错误");
        [delegate sinaShareAuthorizeFail];
        return;
    }
    if ([[data objectForKey:@"error"] length] == 0) {
        [delegate sinaShareAuthorizeFinish:data];
    } else {
        if ([[data objectForKey:@"error_code"] integerValue] == 21332) {
            [CWShareStorage clearTencentStoreInfo];
            self.sinaAccessToken = [CWShareStorage getSinaAccessToken];
            self.sinaExpireDate = [CWShareStorage getSinaExpiredDate];
            self.sinaUID = [CWShareStorage getSinaUserID];
        }
        NSLog(@"sina authorize get user info error_code:%@,error:%@", [data objectForKey:@"error_code"], [data objectForKey:@"error"]);
        [delegate sinaShareContentFail];
    }
}

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
