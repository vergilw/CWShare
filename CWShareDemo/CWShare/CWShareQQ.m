//
//  CWShareTencent.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-9.
//
//

#import "CWShareQQ.h"
#import "CWShareStorage.h"
#import "CWShareConfig.h"
#import "CWShareTools.h"

@interface CWShareQQ ()

@end

@implementation CWShareQQ

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

- (void)shareToQQZoneWithTitle:(NSString *)theTitle withDescription:(NSString *)theDesc withImage:(UIImage *)theImage targetUrl:(NSString *)theUrl
{
    self.shareTencentType = CWShareTypeQQZone;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:theUrl] title:theTitle description:theDesc previewImageData:UIImageJPEGRepresentation(theImage, 1.0)];
    SendMessageToQQReq *msgReq = [SendMessageToQQReq reqWithContent:newsObj];
    [QQApiInterface SendReqToQZone:msgReq];
}

- (void)shareToWeiBoWithContent:(NSString *)theContent
{
    self.shareTencentType = CWShareTypeTencent;
    
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
                NSLog(@"tencentWeiBo shareContent errcode:%@,error:%@", [responseObject objectForKey:@"errcode"], [responseObject objectForKey:@"msg"]);
                [weakSelf.delegate tencentShareContentFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencentWeiBo shareContent %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareContentFail];
        }];
    };
    
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareContentFail];
    };
    
    if ([self isAuthorizeExpired]) {
        if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
            [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装QQ" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            authorizeFailBlock();
            [self setAuthorizeFinishBlock:nil];
            [self setAuthorizeFailBlock:nil];
        }
        
    } else {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)shareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    self.shareTencentType = CWShareTypeTencent;
    
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
                NSLog(@"tencentWeiBo shareContentAndImage errcode:%@,error:%@", [responseObject objectForKey:@"errcode"], [responseObject objectForKey:@"msg"]);
                [weakSelf.delegate tencentShareContentAndImageFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencentWeiBo shareContentAndImage %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareContentAndImageFail];
        }];
    };
    
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareContentAndImageFail];
    };
    
    if ([self isAuthorizeExpired]) {
        if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
            [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装QQ" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            authorizeFailBlock();
            [self setAuthorizeFinishBlock:nil];
            [self setAuthorizeFailBlock:nil];
        }
    } else {
        authorizeFinishBlock();
        [self setAuthorizeFinishBlock:nil];
        [self setAuthorizeFailBlock:nil];
    }
}

- (void)shareToQQWithContent:(NSString *)theContent
{
    self.shareTencentType = CWShareTypeQQ;
    
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:theContent];
        SendMessageToQQReq *msgReq = [SendMessageToQQReq reqWithContent:txtObj];
        [QQApiInterface sendReq:msgReq];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装QQ" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [delegate tencentShareContentFail];
    }
}

- (void)shareToQQWithImage:(UIImage *)theImage
{
    self.shareTencentType = CWShareTypeQQ;
    
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(theImage, 1.0) previewImageData:nil title:nil description:nil];
        SendMessageToQQReq *msgReq = [SendMessageToQQReq reqWithContent:imgObj];
        [QQApiInterface sendReq:msgReq];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装QQ" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [delegate tencentShareContentFail];
    }
}

- (void)shareToQQWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withTargetUrl:(NSString *)theUrl
{
    self.shareTencentType = CWShareTypeQQ;
    
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:theUrl] title:theTitle description:theContent previewImageData:UIImageJPEGRepresentation(theImage, 1.0)];
        SendMessageToQQReq *msgReq = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface sendReq:msgReq];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装QQ" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [delegate tencentShareContentFail];
    }
}

#pragma mark - Authorize Method

- (void)startAuthorize
{
    __weak typeof(self) weakSelf = self;
    self.authorizeFinishBlock = ^(void) {
        weakSelf.tencentRequest = [AFHTTPRequestOperationManager manager];
        weakSelf.tencentRequest.responseSerializer.acceptableContentTypes = [weakSelf.tencentRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [weakSelf.tencentRequest POST:@"https://graph.qq.com/user/get_user_info" parameters:@{@"oauth_consumer_key":TENCENT_APP_KEY, @"access_token":weakSelf.tencentAccessToken, @"openid":weakSelf.tencentOpenID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"ret"] integerValue] == 0) {
                [weakSelf.delegate tencentShareAuthorizeFinish:responseObject];
            } else {
                if ([[responseObject objectForKey:@"errcode"] integerValue] == 36) {
                    [CWShareStorage clearTencentStoreInfo];
                    weakSelf.tencentAccessToken = [CWShareStorage getTencentAccessToken];
                    weakSelf.tencentTokenExpireDate = [CWShareStorage getTencentExpiredDate];
                    weakSelf.tencentOpenID = [CWShareStorage getTencentUserID];
                }
                NSLog(@"tencent login errcode:%@,error:%@", [responseObject objectForKey:@"errcode"], [responseObject objectForKey:@"msg"]);
                [weakSelf.delegate tencentShareAuthorizeFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"tencent login %@", [error localizedDescription]);
            [weakSelf.delegate tencentShareAuthorizeFail];
        }];
    };
    
    self.authorizeFailBlock = ^(void) {
        [weakSelf.delegate tencentShareAuthorizeFail];
    };
    
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        [tencentOAuth authorize:[NSArray arrayWithObjects:@"get_simple_userinfo",@"add_share",@"add_t",@"add_pic_t",@"get_fanslist", nil] inSafari:NO];
    } else {
        NSLog(@"tencent authorize 没有安装QQ");
        [delegate tencentShareAuthorizeFail];
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

- (void)clearAuthorizeInfo
{
    [CWShareStorage clearTencentStoreInfo];
    [self setTencentAccessToken:nil];
    [self setTencentTokenExpireDate:nil];
    [self setTencentOpenID:nil];
    
    [tencentOAuth logout:self];
}

#pragma mark - CWShareQQAuthorize Delegate

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

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

#pragma mark - QQ App Delegate

- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            if ([sendResp.result isEqualToString:@"0"]) {
                [delegate tencentShareContentFinish];
            } else {
                NSLog(@"%@", sendResp.errorDescription);
                [delegate tencentShareContentFail];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)onReq:(QQBaseReq *)req
{
    
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

@end
