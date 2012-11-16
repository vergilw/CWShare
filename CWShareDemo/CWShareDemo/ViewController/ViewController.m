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

@synthesize cwShare;

- (void)dealloc
{
    [self setCwShare:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.cwShare = [[[CWShare alloc] init] autorelease];
    [cwShare setDelegate:self];
    [cwShare setParentViewController:self];
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

- (IBAction)sinaAuthorizeAction:(id)sender
{
    [cwShare startSinaAuthorize];
}

- (IBAction)sinaShareContent:(id)sender
{
    [cwShare sinaShareWithContent:[NSString stringWithFormat:@"it's a debug test from my app, you can ignore this message. %d", arc4random()]];
}

- (IBAction)sinaShareContentAndImage:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [cwShare sinaShareWithContent:[NSString stringWithFormat:@"it's a debug test from my app, you can ignore this message. %d", arc4random()] withImage:uploadImage];
}

- (IBAction)tencentAuthorizeAction:(id)sender
{
    [cwShare startTencentAuthorize];
}

- (IBAction)tencentShareContent:(id)sender
{
    [cwShare tencentShareWithContent:[NSString stringWithFormat:@"it's a debug test from my app, you can ignore this message. %d", arc4random()]];
}

- (IBAction)tencentShareContentAndImage:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [cwShare tencentShareWithContent:[NSString stringWithFormat:@"it's a debug test from my app, you can ignore this message. %d", arc4random()] withImage:uploadImage];
}

#pragma mark - CWShare Delegate

- (void)authorizeFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪授权失败");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯授权失败");
    }
}

- (void)authorizeFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪授权成功");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯授权成功");
    }
}

- (void)shareContentFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享内容失败");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享内容失败");
    }
}

- (void)shareContentFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享内容成功");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享内容成功");
    }
}

- (void)shareContentAndImageFailForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享图片失败");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享图片失败");
    }
}

- (void)shareContentAndImageFinishForShareType:(CWShareType)shareType
{
    if (shareType == CWShareTypeSina) {
        NSLog(@"新浪分享图片成功");
    } else if (shareType == CWShareTypeTencent) {
        NSLog(@"腾讯分享图片成功");
    }
}

@end
