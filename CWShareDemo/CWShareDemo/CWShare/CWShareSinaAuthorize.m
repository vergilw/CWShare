//
//  CWShareSinaAuthorize.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-9-18.
//
//

#import "CWShareSinaAuthorize.h"
#import "CWShareConfig.h"

@interface CWShareSinaAuthorize ()

@property (assign) BOOL needRestoreNav;

@end

@implementation CWShareSinaAuthorize

@synthesize webView,authorizeRequest,delegate,activityIndicator,needRestoreNav;

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
    
    if (self.navigationController.navigationBarHidden == YES) {
        needRestoreNav = YES;
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backItemIcon"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 17)];
    [backButton addTarget:self action:@selector(backBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"新浪微博授权"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLabel];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
    [webView setDelegate:self];
    NSString *requestURL = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&display=mobile&scope=follow_app_official_microblog,friendships_groups_read", SINA_APP_KEY, SINA_REDIRECT_URL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
    [self.view addSubview:webView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:CGRectMake(150, self.view.frame.size.height/2-20, 20, 20)];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (needRestoreNav == YES) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIControl Event

- (IBAction)backBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:SINA_REDIRECT_URL]) {
        NSArray *redirectURL = [[[request URL] absoluteString] componentsSeparatedByString:@"="];
        NSString *requestURL = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token"];
        
        __weak typeof(self) weakSelf = self;
        self.authorizeRequest = [AFHTTPRequestOperationManager manager];
        self.authorizeRequest.responseSerializer.acceptableContentTypes = [self.authorizeRequest.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [authorizeRequest POST:requestURL parameters:@{@"client_id":SINA_APP_KEY, @"client_secret":SINA_APP_SECRET, @"grant_type":@"authorization_code", @"code":[redirectURL objectAtIndex:1], @"redirect_uri":SINA_REDIRECT_URL} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"error"] length] == 0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                [weakSelf.delegate sinaAuthorizeFinish:[responseObject objectForKey:@"access_token"] withExpireTime:[responseObject objectForKey:@"expires_in"] withUID:[responseObject objectForKey:@"uid"]];
            } else {
                [weakSelf.delegate sinaAuthorizeFail];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"新浪请求用户信息错误 %@", [error localizedDescription]);
            [weakSelf.delegate sinaAuthorizeFail];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

@end
