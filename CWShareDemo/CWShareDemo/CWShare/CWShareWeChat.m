//
//  CWShareWeChat.m
//  CWShareDemo
//
//  Created by Wang Jun on 14-3-26.
//
//

#import "CWShareWeChat.h"
#import "CWShare.h"

@implementation CWShareWeChat

- (void)sessionShareWithTitle:(NSString *)theTitle
{
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

- (void)timelineShareWithTitle:(NSString *)theTitle withContent:(NSString *)theContent withImage:(UIImage *)theImage withWebUrl:(NSString *)theUrl
{
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
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0) {
            if (self.cwShareWechatType == 0) {
                [[[CWShare shareObject] delegate] shareContentFinishForShareType:CWShareTypeWechatSession];
            } else if (self.cwShareWechatType == 1) {
                [[[CWShare shareObject] delegate] shareContentAndImageFinishForShareType:CWShareTypeWechatSession];
            } else if (self.cwShareWechatType == 2) {
                [[[CWShare shareObject] delegate] shareContentFinishForShareType:CWShareTypeWechatTimeline];
            } else if (self.cwShareWechatType == 3) {
                [[[CWShare shareObject] delegate] shareContentAndImageFinishForShareType:CWShareTypeWechatTimeline];
            }
        } else {
            if (self.cwShareWechatType == 0) {
                [[[CWShare shareObject] delegate] shareContentFailForShareType:CWShareTypeWechatSession];
            } else if (self.cwShareWechatType == 1) {
                [[[CWShare shareObject] delegate] shareContentAndImageFailForShareType:CWShareTypeWechatSession];
            } else if (self.cwShareWechatType == 2) {
                [[[CWShare shareObject] delegate] shareContentFailForShareType:CWShareTypeWechatTimeline];
            } else if (self.cwShareWechatType == 3) {
                [[[CWShare shareObject] delegate] shareContentAndImageFailForShareType:CWShareTypeWechatTimeline];
            }
        }
        
    }
}

@end
