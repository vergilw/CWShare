//
//  CWShareSina.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShareSina.h"
#import "CWShareStorage.h"
#import "CWShareConfig.h"

@implementation CWShareSina

@synthesize sinaAccessToken,sinaTokenExpireDate,sinaUID,delegate,sinaGetRequest,
sinaPostRequest,parentViewController,authorizeFinishBlock,
authorizeFailBlock,isSSOAuth;

#pragma mark - Memory Management Method

- (id)init
{
    self = [super init];
    if (self) {
        self.sinaAccessToken = [CWShareStorage getSinaAccessToken];
        self.sinaTokenExpireDate = [CWShareStorage getSinaExpiredDate];
        self.sinaUID = [CWShareStorage getSinaUserID];
    }
    return self;
}

#pragma mark - Share Method

- (void)shareWithContent:(NSString *)theContent
{
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.sinaPostRequest = [AFHTTPRequestOperationManager manager];
        [weakSelf.sinaPostRequest POST:@"https://api.weibo.com/2/statuses/update.json" parameters:@{@"access_token":weakSelf.sinaAccessToken, @"status":theContent} success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if ([[responseObject objectForKey:@"error"] length] == 0) {
                [weakSelf.delegate sinaShareContentFinish];
            } else {
                if ([[responseObject objectForKey:@"error"] integerValue] == 21332) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.sinaAccessToken = [CWShareStorage getSinaAccessToken];
                    weakSelf.sinaTokenExpireDate = [CWShareStorage getSinaExpiredDate];
                    weakSelf.sinaUID = [CWShareStorage getSinaUserID];
                }
                [weakSelf.delegate sinaShareContentFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"sina shareContent 没有网络连接");
            [weakSelf.delegate sinaShareContentFail];
        }];
        
    };
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate sinaShareContentFail];
    };
    
    if ([self isAuthorizeExpired]) {
        //先尝试SSO授权
        NSString *ssoURL = [NSString stringWithFormat:@"sinaweibosso://login?redirect_uri=%@&callback_uri=sinaweibosso.%@://&client_id=%@", SINA_REDIRECT_URL, SINA_APP_KEY, SINA_APP_KEY];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            ssoURL = [NSString stringWithFormat:@"sinaweibohdsso://login?redirect_uri=%@&callback_uri=sinaweibosso.%@://&client_id=%@", SINA_REDIRECT_URL, SINA_APP_KEY, SINA_APP_KEY];
        }
        isSSOAuth = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ssoURL]];
        
        //SSO授权失败，再进行OAuth2.0直接授权
        if (!isSSOAuth) {
            if (parentViewController == nil) {
                NSLog(@"CWShare没有设置parentViewController");
            } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
                NSLog(@"CWShare代理应该属于UIViewController");
            } else {
                CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
                [sinaAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
            }
        }
    } else {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.sinaPostRequest = [AFHTTPRequestOperationManager manager];
        [weakSelf.sinaPostRequest POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:@{@"access_token":weakSelf.sinaAccessToken, @"status":theContent} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(theImage, 1) name:@"pic" fileName:@"pic.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"error"] length] == 0) {
                [weakSelf.delegate sinaShareContentAndImageFinish];
            } else {
                if ([[responseObject objectForKey:@"error_code"] integerValue] == 21332) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.sinaAccessToken = [CWShareStorage getSinaAccessToken];
                    weakSelf.sinaTokenExpireDate = [CWShareStorage getSinaExpiredDate];
                    weakSelf.sinaUID = [CWShareStorage getSinaUserID];
                }
                NSLog(@"sina shareContentAndImage error_code:%@,error:%@", [responseObject objectForKey:@"error_code"], [responseObject objectForKey:@"error"]);
                [weakSelf.delegate sinaShareContentAndImageFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"sina shareContentAndImage %@", [error localizedDescription]);
            [weakSelf.delegate sinaShareContentAndImageFail];
        }];
    };
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate sinaShareContentAndImageFail];
    };
    
    if ([self isAuthorizeExpired]) {
        //先尝试SSO授权
        NSString *ssoURL = [NSString stringWithFormat:@"sinaweibosso://login?redirect_uri=%@&callback_uri=sinaweibosso.%@://&client_id=%@", SINA_REDIRECT_URL, SINA_APP_KEY, SINA_APP_KEY];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            ssoURL = [NSString stringWithFormat:@"sinaweibohdsso://login?redirect_uri=%@&callback_uri=sinaweibosso.%@://&client_id=%@", SINA_REDIRECT_URL, SINA_APP_KEY, SINA_APP_KEY];
        }
        isSSOAuth = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ssoURL]];
        
        //SSO授权失败，再进行OAuth2.0直接授权
        if (!isSSOAuth) {
            if (parentViewController == nil) {
                NSLog(@"CWShare没有设置parentViewController");
            } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
                NSLog(@"CWShare代理应该属于UIViewController");
            } else {
                
                CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
                [sinaAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
            }
        }
        
    } else {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

#pragma mark - Authorize Method

- (void)startAuthorize
{
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.sinaGetRequest = [AFHTTPRequestOperationManager manager];
        [weakSelf.sinaGetRequest GET:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@", weakSelf.sinaUID, weakSelf.sinaAccessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"error"] length] == 0) {
                [weakSelf.delegate sinaShareAuthorizeFinish:responseObject];
            } else {
                if ([[responseObject objectForKey:@"error_code"] integerValue] == 21332) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.sinaAccessToken = [CWShareStorage getSinaAccessToken];
                    weakSelf.sinaTokenExpireDate = [CWShareStorage getSinaExpiredDate];
                    weakSelf.sinaUID = [CWShareStorage getSinaUserID];
                }
                NSLog(@"sina authorize get user info error_code:%@,error:%@", [responseObject objectForKey:@"error_code"], [responseObject objectForKey:@"error"]);
                [weakSelf.delegate sinaShareAuthorizeFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"sina authorize get user info 没有网络连接");
            [weakSelf.delegate sinaShareAuthorizeFail];
        }];
    };
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate sinaShareAuthorizeFail];
    };
    
    //先尝试SSO授权
    NSString *ssoURL = [NSString stringWithFormat:@"sinaweibosso://login?redirect_uri=%@&callback_uri=sinaweibosso.%@://&client_id=%@", SINA_REDIRECT_URL, SINA_APP_KEY, SINA_APP_KEY];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        ssoURL = [NSString stringWithFormat:@"sinaweibohdsso://login?redirect_uri=%@&callback_uri=sinaweibosso.%@://&client_id=%@", SINA_REDIRECT_URL, SINA_APP_KEY, SINA_APP_KEY];
    }
    isSSOAuth = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ssoURL]];
    
    //SSO授权失败，再进行OAuth2.0直接授权
    if (!isSSOAuth) {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
            [self setAuthorizeFinishBlock:nil];
            [self setAuthorizeFailBlock:nil];
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
            [self setAuthorizeFinishBlock:nil];
            [self setAuthorizeFailBlock:nil];
        } else {
            CWShareSinaAuthorize *sinaAuthorize = [[CWShareSinaAuthorize alloc] init];
            [sinaAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:sinaAuthorize animated:YES];
        }
    }
}

- (BOOL)isAuthorizeExpired
{
    if ([sinaTokenExpireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UIApplicationDeleagte Method

- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:[NSString stringWithFormat:@"sinaweibosso.%@://", SINA_APP_KEY]])
    {
        if (isSSOAuth) {
            isSSOAuth = NO;
            
            if ([self getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"]) {
                [self sinaAuthorizeFail];
            } else if ([self getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"]) {
                [self sinaAuthorizeFail];
            } else if ([self getParamValueFromUrl:urlString paramName:@"error_code"]) {
                [self sinaAuthorizeFail];
            } else {
                NSString *access_token = [self getParamValueFromUrl:urlString paramName:@"access_token"];
                NSString *expires_in = [self getParamValueFromUrl:urlString paramName:@"expires_in"];
//                NSString *remind_in = [self getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [self getParamValueFromUrl:urlString paramName:@"uid"];
//                NSString *refresh_token = [self getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
                [self sinaAuthorizeFinish:access_token withExpireTime:expires_in withUID:uid];
            }
        }
    }
    return YES;
}

- (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

#pragma mark - CWShareSinaAuthorize Delegate

- (void)sinaAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withUID:(NSString *)theUID
{
    self.sinaAccessToken = accessToken;
    self.sinaTokenExpireDate = [NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]];
    self.sinaUID = theUID;
    [CWShareStorage setSinaAccessToken:sinaAccessToken];
    [CWShareStorage setSinaExpiredDate:sinaTokenExpireDate];
    [CWShareStorage setSinaUserID:sinaUID];
    
    if (authorizeFinishBlock) {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)sinaAuthorizeFail
{
    if (authorizeFailBlock) {
        authorizeFailBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    } else {
        NSLog(@"sina authorize 没有网络连接");
        [delegate sinaShareAuthorizeFail];
    }
}

@end
