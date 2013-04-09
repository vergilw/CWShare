//
//  CWShareSinaAuthorize.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-9-18.
//
//

#import "CWShareSinaAuthorize.h"
#import "CWShareConfig.h"
#import "SBJson.h"

@interface CWShareSinaAuthorize ()

@end

@implementation CWShareSinaAuthorize

@synthesize webView,authorizeRequest,delegate,activityIndicator;

- (void)dealloc
{
    [self setWebView:nil];
    [authorizeRequest clearDelegatesAndCancel];
    [self setAuthorizeRequest:nil];
    [self setActivityIndicator:nil];
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
    NSString *requestURL = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&display=mobile&scope=follow_app_official_microblog,friendships_groups_read", SINA_APP_KEY, SINA_REDIRECT_URL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    [self.view addSubview:webView];
    
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityIndicator setFrame:CGRectMake(150, 198, 20, 20)];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:SINA_REDIRECT_URL]) {
        NSArray *redirectURL = [[[request URL] absoluteString] componentsSeparatedByString:@"="];
        NSString *requestURL = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token"];
        self.authorizeRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        [authorizeRequest setPostValue:SINA_APP_KEY forKey:@"client_id"];
        [authorizeRequest setPostValue:SINA_APP_SECRET forKey:@"client_secret"];
        [authorizeRequest setPostValue:@"authorization_code" forKey:@"grant_type"];
        [authorizeRequest setPostValue:[redirectURL objectAtIndex:1] forKey:@"code"];
        [authorizeRequest setPostValue:SINA_REDIRECT_URL forKey:@"redirect_uri"];
        [authorizeRequest setDelegate:self];
        [authorizeRequest startAsynchronous];
        
        return NO;
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
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *data = [parser objectWithString:responseString error:&error];
    if (error != nil) {
        [delegate sinaAuthorizeFail];
        return;
    }
    if ([[data objectForKey:@"error"] length] == 0) {
        [delegate sinaAuthorizeFinish:[data objectForKey:@"access_token"] withExpireTime:[data objectForKey:@"expires_in"] withUID:[data objectForKey:@"uid"]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [delegate sinaAuthorizeFail];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [delegate sinaAuthorizeFail];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
