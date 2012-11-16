//
//  CWShareTencentAuthorize.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-10.
//
//

#import "CWShareTencentAuthorize.h"
#import "CWShareConfig.h"
#import "SBJson.h"
#import "CWShareTools.h"

@interface CWShareTencentAuthorize ()

@end

@implementation CWShareTencentAuthorize

@synthesize webView,authorizeRequest,delegate,accessToken,
refreshToken,expiredTime,openID;

- (void)dealloc
{
    [self setWebView:nil];
    [authorizeRequest clearDelegatesAndCancel];
    [self setAuthorizeRequest:nil];
    [self setAccessToken:nil];
    [self setRefreshToken:nil];
    [self setExpiredTime:nil];
    [self setOpenID:nil];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease];
    [webView setDelegate:self];
    NSString *requestURL = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=%@&response_type=token&redirect_uri=%@&wap=2", TENCENT_APP_KEY, TENCENT_REDIRECT_URL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        if ([[[request URL] absoluteString] hasPrefix:TENCENT_REDIRECT_URL]) {
            NSArray *redirectURL = [[[request URL] absoluteString] componentsSeparatedByString:@"#"];
            redirectURL = [[redirectURL objectAtIndex:1] componentsSeparatedByString:@"&"];
            
            self.accessToken = [[[redirectURL objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
            self.expiredTime = [[[redirectURL objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
            self.openID = [[[redirectURL objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1];
            self.refreshToken = [[[redirectURL objectAtIndex:4] componentsSeparatedByString:@"="] objectAtIndex:1];
            
            [self.navigationController popViewControllerAnimated:YES];
            [delegate tencentAuthorizeFinish:accessToken withExpireTime:expiredTime withOpenID:openID withRefreshToken:refreshToken];
            return NO;
        }
    }
    return YES;
}

@end
