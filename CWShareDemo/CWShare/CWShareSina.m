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
#import "WeiboSDK.h"
#import "WeiboUser.h"

@implementation CWShareSina

@synthesize sinaAccessToken,sinaTokenExpireDate,sinaUID,delegate,sinaGetRequest,
sinaPostRequest,parentViewController,authorizeFinishBlock,
authorizeFailBlock;

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
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SINA_REDIRECT_URL;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    [message setText:theContent];
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:self.sinaAccessToken];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    [WeiboSDK sendRequest:request];
}

- (void)shareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SINA_REDIRECT_URL;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    [message setText:theContent];
    
    WBImageObject *imageObject = [WBImageObject object];
    [imageObject setImageData:UIImageJPEGRepresentation(theImage, 1.0)];
    [message setImageObject:imageObject];
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:self.sinaAccessToken];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    [WeiboSDK sendRequest:request];
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
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINA_REDIRECT_URL;
    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (BOOL)isAuthorizeExpired
{
    if ([sinaTokenExpireDate compare:[NSDate date]] == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
}

- (void)clearAuthorizeInfo
{
    [CWShareStorage clearSinaStoreInfo];
    [self setSinaAccessToken:nil];
    [self setSinaTokenExpireDate:nil];
    [self setSinaUID:nil];
    
    [WeiboSDK logOutWithToken:self.sinaAccessToken delegate:self withTag:nil];
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

#pragma mark - WeiboSDK Delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (response.statusCode == 0) {
            [self.delegate sinaShareContentFinish];
        } else {
            [self.delegate sinaShareContentFail];
        }

    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == 0) {
            /*
            [WBHttpRequest requestForUserProfile:[(WBAuthorizeResponse *)response userID] withAccessToken:[(WBAuthorizeResponse *)response accessToken] andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                
                WeiboUser *weiboUser = result;
                [self sinaAuthorizeFinish:[(WBAuthorizeResponse *)response accessToken] withExpireTime:[[NSNumber numberWithDouble:[[(WBAuthorizeResponse *)response expirationDate] timeIntervalSince1970]] stringValue] withUID:[(WBAuthorizeResponse *)response userID]];
                
            }];
             */
            [self sinaAuthorizeFinish:[(WBAuthorizeResponse *)response accessToken] withExpireTime:[[NSNumber numberWithDouble:[[(WBAuthorizeResponse *)response expirationDate] timeIntervalSince1970]] stringValue] withUID:[(WBAuthorizeResponse *)response userID]];
        } else {
            [self sinaAuthorizeFail];
        }
        
        
    } else if ([response isKindOfClass:WBPaymentResponse.class]) {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];

    }
}

@end
