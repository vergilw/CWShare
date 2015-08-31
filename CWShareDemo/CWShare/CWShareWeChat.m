//
//  CWShareWeChat.m
//  CWShareDemo
//
//  Created by Wang Jun on 14-3-26.
//
//

#import "CWShareWeChat.h"
#import "CWShare.h"
#import "CWShareStorage.h"

@implementation CWShareWeChat

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startAuthorize
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;

        [WXApi sendReq:req];
    }
}

- (void)clearAuthorizeInfo
{
    [CWShareStorage clearWechatStoreInfo];
    [self setWechatAccessToken:nil];
    [self setWechatTokenExpireDate:nil];
    [self setWechatOpenID:nil];
}

- (void)sessionShareWithTitle:(NSString *)theTitle
{
    self.shareWechatType = CWShareTypeWechatSession;
    
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        [req setBText:YES];
        [req setText:theTitle];
        [req setScene:WXSceneSession];
        
        [WXApi sendReq:req];
    }
}

- (void)sessionShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl
{
    self.shareWechatType = CWShareTypeWechatSession;
    
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setTitle:theTitle];
        [message setDescription:theContent];
        [message setThumbImage:theImage];
        
        WXWebpageObject *webPage = [WXWebpageObject object];
        [webPage setWebpageUrl:theUrl];
        [message setMediaObject:webPage];
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        [req setBText:NO];
        [req setMessage:message];
        [req setScene:WXSceneSession];
        
        [WXApi sendReq:req];
    }
}

- (void)timelineShareWithTitle:(NSString *)theTitle
{
    self.shareWechatType = CWShareTypeWechatTimeline;
    
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        [req setBText:YES];
        [req setText:theTitle];
        [req setScene:WXSceneTimeline];
        
        [WXApi sendReq:req];
    }
}

- (void)timelineShareWithTitle:(NSString *)theTitle withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl
{
    self.shareWechatType = CWShareTypeWechatTimeline;
    
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您没有安装微信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setTitle:theTitle];
//        [message setDescription:theContent];
        [message setThumbImage:theImage];
        
        WXWebpageObject *webPage = [WXWebpageObject object];
        [webPage setWebpageUrl:theUrl];
        [message setMediaObject:webPage];
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        [req setBText:NO];
        [req setMessage:message];
        [req setScene:WXSceneTimeline];
        
        [WXApi sendReq:req];
    }
}

#pragma mark - WeChat Delegate

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            [self.delegate wechatShareFinish];
        } else {
            [self.delegate wechatShareFail];
        }
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        if (authResp.code != nil) {
            self.wechatRequest = [AFHTTPRequestOperationManager manager];
            self.wechatRequest.responseSerializer.acceptableContentTypes = [self.wechatRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            [self.wechatRequest POST:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:@{@"appid":WeChatAppID, @"secret":WechatAppSecret, @"code":authResp.code, @"grant_type":@"authorization_code"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.wechatAccessToken = [responseObject objectForKey:@"access_token"];
                self.wechatTokenExpireDate = [NSDate dateWithTimeIntervalSinceNow:[[responseObject objectForKey:@"expires_in"] doubleValue]];
                self.wechatOpenID = [responseObject objectForKey:@"openid"];
                
                self.wechatInfoRequest = [AFHTTPRequestOperationManager manager];
                self.wechatInfoRequest.responseSerializer.acceptableContentTypes = [self.wechatRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
                [self.wechatInfoRequest POST:@"https://api.weixin.qq.com/sns/userinfo" parameters:@{@"access_token":self.wechatAccessToken, @"openid":self.wechatOpenID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [self.delegate wechatShareAuthorizeFinish:responseObject];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"wechat get user info %@", [error localizedDescription]);
                    [self.delegate wechatShareAuthorizeFail];
                }];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"wechat login %@", [error localizedDescription]);
                [self.delegate wechatShareAuthorizeFail];
            }];
        } else {
            [self.delegate wechatShareAuthorizeFail];
        }
        
    } else if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *payResp = (PayResp *)resp;
        if (payResp.errCode == WXSuccess) {
            NSLog(@"wechat pay success %@", payResp.returnKey);
        }
    }
}

@end
