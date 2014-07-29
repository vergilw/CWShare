//
//  CWShareTencent.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import "CWShareTencent.h"
#import "CWShareStorage.h"
#import "CWShareConfig.h"
#import "CWShareTools.h"
#import <TencentOpenAPI/QQApi.h>

@implementation CWShareTencent

@synthesize tencentAccessToken,tencentTokenExpireDate,
tencentOpenID,delegate,tencentRequest,
parentViewController,authorizeFinishBlock,
authorizeFailBlock,tencentOAuth;

- (id)init
{
    self = [super init];
    if (self) {
        self.tencentAccessToken = [CWShareStorage getTencentAccessToken];
        self.tencentTokenExpireDate = [CWShareStorage getTencentExpiredDate];
        self.tencentOpenID = [CWShareStorage getTencentUserID];
        
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:TENCENT_APP_KEY andDelegate:self];
    }
    return self;
}

#pragma mark - Share Method

- (void)shareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent contentUrl:(NSString *)contentUrl withSynchronizeWeibo:(BOOL)theBool
{
    /*
     TCAddShareDic *params = [TCAddShareDic dictionary];
     params.paramTitle = @"腾讯内部addShare接口测试";
     params.paramComment = @"风云乔帮主";
     params.paramSummary =  @"乔布斯被认为是计算机与娱乐业界的标志性人物，同时人们也把他视作麦金塔计算机、iPod、iTunes、iPad、iPhone等知名数字产品的缔造者，这些风靡全球亿万人的电子产品，深刻地改变了现代通讯、娱乐乃至生活的方式。";
     params.paramImages = @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
     params.paramUrl = @"http://www.qq.com";
     
     if(![_tencentOAuth addShareWithParams:params]){
     [self showInvalidTokenOrOpenIDMessage];
     }
     */
    NSString *synFlag = nil;
    if (theBool) {
        synFlag = @"0";
    } else {
        synFlag = @"1";
    }
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.tencentRequest = [AFHTTPRequestOperationManager manager];
        weakSelf.tencentRequest.responseSerializer.acceptableContentTypes = [weakSelf.tencentRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [weakSelf.tencentRequest POST:@"https://graph.qq.com/share/add_share" parameters:@{@"oauth_consumer_key":TENCENT_APP_KEY, @"access_token":weakSelf.tencentAccessToken, @"openid":weakSelf.tencentOpenID, @"comment":theDesc, @"title":theTitle, @"summary":theContent, @"url":contentUrl, @"fromurl":QQZONE_DISPLAY_APP_URL, @"site":QQZONE_DISPLAY_NAME, @"nswb":synFlag} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"ret"] integerValue] == 0) {
                [weakSelf.delegate tencentShareContentFinish];
            } else {
                if ([[responseObject objectForKey:@"errcode"] integerValue] == 36) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.tencentAccessToken = [CWShareStorage getTencentAccessToken];
                    weakSelf.tencentTokenExpireDate = [CWShareStorage getTencentExpiredDate];
                    weakSelf.tencentOpenID = [CWShareStorage getTencentUserID];
                }
                NSLog(@"tencent shareContent error code:%@,error info:%@", [responseObject objectForKey:@"errcode"], [responseObject objectForKey:@"msg"]);
                [weakSelf.delegate tencentShareContentFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencent shareToQQZone %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareContentFail];
        }];
    };
    
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareContentFail];
    };
    
    if ([self isAuthorizeExpired]) {
        if ([QQApi isQQInstalled] && [QQApi isQQSupportApi]) {
            [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
        } else {
            if (parentViewController == nil) {
                NSLog(@"CWShare没有设置parentViewController");
            } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
                NSLog(@"CWShare代理应该属于UIViewController");
            } else {
                CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
                [tencentAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
            }
        }
        
    } else {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)shareToWeiBoWithContent:(NSString *)theContent
{
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.tencentRequest = [AFHTTPRequestOperationManager manager];
        weakSelf.tencentRequest.responseSerializer.acceptableContentTypes = [weakSelf.tencentRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
        [weakSelf.tencentRequest POST:@"https://graph.qq.com/t/add_t" parameters:@{@"oauth_consumer_key":TENCENT_APP_KEY, @"access_token":weakSelf.tencentAccessToken, @"openid":weakSelf.tencentOpenID, @"content":theContent} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"ret"] integerValue] == 0) {
                [weakSelf.delegate tencentShareContentFinish];
            } else {
                if ([[responseObject objectForKey:@"errcode"] integerValue] == 36) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.tencentAccessToken = [CWShareStorage getTencentAccessToken];
                    weakSelf.tencentTokenExpireDate = [CWShareStorage getTencentExpiredDate];
                    weakSelf.tencentOpenID = [CWShareStorage getTencentUserID];
                }
                NSLog(@"tencent shareContent errcode:%@,error:%@", [responseObject objectForKey:@"errcode"], [responseObject objectForKey:@"msg"]);
                [weakSelf.delegate tencentShareContentFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencent shareContent %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareContentFail];
        }];
    };
    
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareContentFail];
    };
    
    if ([self isAuthorizeExpired]) {
        if ([QQApi isQQInstalled] && [QQApi isQQSupportApi]) {
            [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
        } else {
            if (parentViewController == nil) {
                NSLog(@"CWShare没有设置parentViewController");
            } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
                NSLog(@"CWShare代理应该属于UIViewController");
            } else {
                CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
                [tencentAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
            }
        }
        
    } else {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.tencentRequest = [AFHTTPRequestOperationManager manager];
        weakSelf.tencentRequest.responseSerializer.acceptableContentTypes = [weakSelf.tencentRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-javascript"];
        [weakSelf.tencentRequest POST:@"https://graph.qq.com/t/add_pic_t" parameters:@{@"oauth_consumer_key":TENCENT_APP_KEY, @"access_token":weakSelf.tencentAccessToken, @"openid":weakSelf.tencentOpenID, @"content":theContent} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFormData:UIImageJPEGRepresentation(theImage, 1) name:@"pic"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"ret"] integerValue] == 0) {
                [weakSelf.delegate tencentShareContentAndImageFinish];
            } else {
                if ([[responseObject objectForKey:@"errcode"] integerValue] == 36) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.tencentAccessToken = [CWShareStorage getTencentAccessToken];
                    weakSelf.tencentTokenExpireDate = [CWShareStorage getTencentExpiredDate];
                    weakSelf.tencentOpenID = [CWShareStorage getTencentUserID];
                }
                NSLog(@"tencent shareContentAndImage errcode:%@,error:%@", [responseObject objectForKey:@"errcode"], [responseObject objectForKey:@"msg"]);
                [weakSelf.delegate tencentShareContentAndImageFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencent shareContentAndImage %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareContentAndImageFail];
        }];
    };
    
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareContentAndImageFail];
    };
    
    if ([self isAuthorizeExpired]) {
        if ([QQApi isQQInstalled] && [QQApi isQQSupportApi]) {
            [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
        } else {
            if (parentViewController == nil) {
                NSLog(@"CWShare没有设置parentViewController");
            } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
                NSLog(@"CWShare代理应该属于UIViewController");
            } else {
                CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
                [tencentAuthorize setDelegate:self];
                [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
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
        weakSelf.tencentRequest = [AFHTTPRequestOperationManager manager];
        weakSelf.tencentRequest.responseSerializer.acceptableContentTypes = [weakSelf.tencentRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [weakSelf.tencentRequest POST:@"https://openmobile.qq.com/user/get_simple_userinfo" parameters:@{@"oauth_consumer_key":TENCENT_APP_KEY, @"access_token":weakSelf.tencentAccessToken, @"openid":weakSelf.tencentOpenID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"ret"] integerValue] == 0) {
                [weakSelf.delegate tencentShareAuthorizeFinish:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencent shareContent get user info %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareAuthorizeFail];
        }];
    };

    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareAuthorizeFail];
    };
    
    if ([QQApi isQQInstalled] && [QQApi isQQSupportApi]) {
        [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
    } else {
        if (parentViewController == nil) {
            NSLog(@"CWShare没有设置parentViewController");
        } else if (![parentViewController isKindOfClass:[UIViewController class]]) {
            NSLog(@"CWShare代理应该属于UIViewController");
        } else {
            CWShareTencentAuthorize *tencentAuthorize = [[CWShareTencentAuthorize alloc] init];
            [tencentAuthorize setDelegate:self];
            [parentViewController.navigationController pushViewController:tencentAuthorize animated:YES];
        }
    }
}

- (BOOL)isAuthorizeExpired
{
    if ([tencentTokenExpireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - CWShareSinaAuthorize Delegate

- (void)tencentAuthorizeFinish:(NSString *)accessToken withExpireTime:(NSString *)expireTime withOpenID:(NSString *)theOpenID
{
    self.tencentAccessToken = accessToken;
    self.tencentTokenExpireDate = [NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]];
    self.tencentOpenID = theOpenID;

    [CWShareStorage setTencentAccessToken:tencentAccessToken];
    [CWShareStorage setTencentExpiredDate:tencentTokenExpireDate];
    [CWShareStorage setTencentUserID:tencentOpenID];

    if (authorizeFinishBlock) {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)tencentAuthorizeFail
{
    if (authorizeFailBlock) {
        authorizeFailBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    } else {
        NSLog(@"tencent authorize 没有网络连接");
        [delegate tencentShareAuthorizeFail];
    }
}

#pragma mark - Tencent Login Delegate

- (void)tencentDidLogin
{
    NSString *expireIn = [NSString stringWithFormat:@"%f", [tencentOAuth.expirationDate timeIntervalSince1970]];
    [self tencentAuthorizeFinish:tencentOAuth.accessToken withExpireTime:expireIn withOpenID:tencentOAuth.openId];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self tencentAuthorizeFail];
}

- (void)tencentDidNotNetWork
{
    [self tencentAuthorizeFail];
}

@end
