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

@synthesize webView,authorizeRequest,delegate,activityIndicator,
accessToken,refreshToken,expiredTime,openID;

- (void)dealloc
{
    [self setWebView:nil];
    [authorizeRequest clearDelegatesAndCancel];
    [self setAuthorizeRequest:nil];
    [self setActivityIndicator:nil];
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
	
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)] autorelease];
    [webView setDelegate:self];
    NSString *requestURL = [NSString stringWithFormat:@"https://openmobile.qq.com/oauth2.0/m_authorize?client_id=%@&response_type=token&redirect_uri=%@&scope=get_simple_userinfo,add_share,add_t,add_pic_t,get_fanslist", TENCENT_APP_KEY, TENCENT_REDIRECT_URL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    [self.view addSubview:webView];
    
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityIndicator setFrame:CGRectMake(150, self.view.frame.size.height/2-20, 20, 20)];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
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
//            self.openID = [[[redirectURL objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1];
//            self.refreshToken = [[[redirectURL objectAtIndex:4] componentsSeparatedByString:@"="] objectAtIndex:1];
            
            self.authorizeRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://graph.z.qq.com/moc2/me"]];
            [authorizeRequest setPostValue:accessToken forKey:@"access_token"];
            [authorizeRequest setDelegate:self];
            [authorizeRequest startAsynchronous];
            
//            [self.navigationController popViewControllerAnimated:YES];
//            [delegate tencentAuthorizeFinish:accessToken withExpireTime:expiredTime withOpenID:openID withRefreshToken:refreshToken];
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

#pragma mark - ASIHttpRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    self.openID = [[responseString componentsSeparatedByString:@"&"] objectAtIndex:1];
    self.openID = [[openID componentsSeparatedByString:@"="] objectAtIndex:1];
    [delegate tencentAuthorizeFinish:accessToken withExpireTime:expiredTime withOpenID:openID];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [delegate tencentAuthorizeFail];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
