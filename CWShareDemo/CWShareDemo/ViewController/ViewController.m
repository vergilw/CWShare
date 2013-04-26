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

- (void)dealloc
{
    [super dealloc];
}

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
    [[CWShare shareObject] clearTencentAuthorizeInfo];
}

- (IBAction)tencentShareToQQZone:(id)sender
{
    [[CWShare shareObject] setDelegate:self];
    [[CWShare shareObject] setParentViewController:self];
    [[CWShare shareObject] tencentShareToQQZoneWithDescription:[NSString stringWithFormat:@"%d share description", arc4random()] withTitle:[NSString stringWithFormat:@"%d share title", arc4random()] Content:[NSString stringWithFormat:@"%d it's a debug test from my app, you can ignore this message.", arc4random()] withSynchronizeWeibo:NO];
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

#pragma mark - CWShare Delegate

- (void)loginFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪授权失败");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"新浪授权失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯授权失败");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"腾讯授权失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)loginFinishForShareType:(CWShareType)shareType withData:(NSDictionary *)userInfo
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪授权成功");
        NSLog(@"%@", userInfo);
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"新浪授权成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯授权成功");
        NSLog(@"%@", userInfo);
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"腾讯授权成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)shareContentFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享内容失败");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"新浪分享内容失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享内容失败");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"腾讯分享内容失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)shareContentFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享内容成功");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"新浪分享内容成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享内容成功");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"腾讯分享内容成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)shareContentAndImageFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享图片失败");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"新浪分享图片失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享图片失败");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"腾讯分享图片失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)shareContentAndImageFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享图片成功");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"新浪分享图片成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享图片成功");
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"腾讯分享图片成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

@end
