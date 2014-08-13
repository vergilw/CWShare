//
//  ViewController.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-17.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - IBAction Event Method

- (IBAction)sinaLoginAction:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] startSinaAuthorizeLogin];
}

- (IBAction)sinaLogoutAction:(id)sender
{
    NSLog(@"新浪退出成功");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪退出成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [[CWShare shareObject] clearSinaAuthorizeInfo];
}

- (IBAction)sinaShareContent:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] sinaShareWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
}

- (IBAction)sinaShareContentAndImage:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [[CWShare shareObject] sinaShareWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()] withImage:uploadImage];
}

- (IBAction)tencentLoginAction:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] startTencentAuthorizeLogin];
}

- (IBAction)tencentLogoutAction:(id)sender
{
    NSLog(@"QQ退出成功");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QQ退出成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [[CWShare shareObject] clearTencentAuthorizeInfo];
}

- (IBAction)tencentShareToQQZone:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] tencentShareToQQZoneWithTitle:[NSString stringWithFormat:@"%d share title", arc4random()] withDescription:[NSString stringWithFormat:@"%d share description", arc4random()] withImage:uploadImage targetUrl:@"http://www.11186.com"];
}

- (IBAction)tencentShareContentToWeiBo:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] tencentShareToWeiBoWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
}

- (IBAction)tencentShareContentAndImageToWeiBo:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [[CWShare shareObject] tencentShareToWeiBoWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()] withImage:uploadImage];
}

- (IBAction)tencentShareContentToQQ:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] tencentShareToQQWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
}

- (IBAction)tencentShareImageToQQ:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [[CWShare shareObject] tencentShareToQQWithImage:uploadImage];
}

- (IBAction)tencentShareNewsToQQ:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] tencentShareToQQWithTitle:[NSString stringWithFormat:@"%d share title", arc4random()] withContent:[NSString stringWithFormat:@"%d share description", arc4random()] withImage:uploadImage withTargetUrl:@"http://www.11186.com"];
    
}

- (IBAction)wechatShareContentToSession:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] wechatSessionShareWithTitle:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
}

- (IBAction)wechatShareImageToSession:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] wechatSessionShareWithTitle:[NSString stringWithFormat:@"%d share title", arc4random()] withContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()] withImage:uploadImage withWebUrl:@"www.11186.com"];
}

- (IBAction)wechatShareContentToTimeline:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] wechatTimelineShareWithTitle:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
}

- (IBAction)wechatShareImageToTimeline:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] wechatTimelineShareWithTitle:[NSString stringWithFormat:@"%d share title", arc4random()] withContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()] withImage:uploadImage withWebUrl:@"www.11186.com"];
}

- (IBAction)shareMenuAction:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] showShareMenu];
}

#pragma mark - CWShare Delegate

- (void)loginFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪授权失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪授权失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"QQ授权失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QQ授权失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)loginFinishForShareType:(CWShareType)shareType withData:(NSDictionary *)userInfo
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪授权成功");
        NSLog(@"%@", userInfo);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪授权成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"QQ授权成功");
        NSLog(@"%@", userInfo);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QQ授权成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪微博分享失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪微博分享失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯微博分享失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"腾讯微博分享失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeQQ) {
        NSLog(@"腾讯QQ分享失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"腾讯QQ分享失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeQQZone) {
        NSLog(@"腾讯QQ空间分享失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"腾讯QQ空间分享失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType==CWShareTypeWechatSession || shareType==CWShareTypeWechatTimeline) {
        NSLog(@"微信分享失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪微博分享成功");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪微博分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯微博分享成功");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"腾讯微博分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeQQ) {
        NSLog(@"腾讯QQ分享成功");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"腾讯QQ分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType == CWShareTypeQQZone) {
        NSLog(@"腾讯QQ空间分享成功");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"腾讯QQ空间分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else if (shareType==CWShareTypeWechatSession || shareType==CWShareTypeWechatTimeline) {
        NSLog(@"微信分享成功");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareMenuDidSelect:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        [[CWShare shareObject] setParentViewController:self];
        [[CWShare shareObject] sinaShareWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
    } else if (shareType == CWShareTypeWechatSession) {
        [[CWShare shareObject] wechatSessionShareWithTitle:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
    } else if (shareType == CWShareTypeWechatTimeline) {
        [[CWShare shareObject] wechatTimelineShareWithTitle:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
    } else if (shareType == CWShareTypeTencent) {
        [[CWShare shareObject] setParentViewController:self];
        [[CWShare shareObject] tencentShareToWeiBoWithContent:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()]];
    } else if (shareType == CWShareTypeMessage) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageCompose = [[MFMessageComposeViewController alloc] init];
            [messageCompose setMessageComposeDelegate:self];
            [messageCompose setRecipients:[NSArray arrayWithObject:@"10086"]];
            [messageCompose setSubject:@"My Subject"];
            [messageCompose setBody:@"Hello there"];
            [self presentViewController:messageCompose animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的设备不支持短信" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    } else if (shareType == CWShareTypeMail) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
            [mailCompose setMailComposeDelegate:self];
            [mailCompose setToRecipients:[NSArray arrayWithObject:@"sina@sina.com"]];
            [mailCompose setSubject:@"My Subject"];
            [mailCompose setMessageBody:@"Hello there." isHTML:NO];
            [self presentViewController:mailCompose animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的设备不支持邮件" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark - MFMessageComposeViewController Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MessageComposeResultSent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultCancelled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (result == MFMailComposeResultSent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
