//
//  CWShareTencentAuthorize.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-10-10.
//
//

#import "CWShareTencentAuthorize.h"
#import "CWShareConfig.h"
#import "CWShareTools.h"

@interface CWShareTencentAuthorize ()

@property (assign) BOOL needRestoreNav;

@end

@implementation CWShareTencentAuthorize

@synthesize webView,authorizeRequest,delegate,activityIndicator,
accessToken,refreshToken,expiredTime,openID,needRestoreNav;

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
    [titleLabel setText:@"腾讯QQ授权"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLabel];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
    [webView setDelegate:self];
    NSString *requestURL = [NSString stringWithFormat:@"https://openmobile.qq.com/oauth2.0/m_authorize?client_id=%@&response_type=token&redirect_uri=%@&scope=get_simple_userinfo,add_share,add_t,add_pic_t,get_fanslist", TENCENT_APP_KEY, TENCENT_REDIRECT_URL];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIControl Event

- (IBAction)backBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
            
            __weak typeof(self) weakSelf = self;
            
            self.authorizeRequest = [AFHTTPRequestOperationManager manager];
            [self.authorizeRequest POST:@"https://graph.z.qq.com/moc2/me" parameters:@{@"access_token":accessToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {

                weakSelf.openID = [[responseObject componentsSeparatedByString:@"&"] objectAtIndex:1];
                weakSelf.openID = [[openID componentsSeparatedByString:@"="] objectAtIndex:1];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                [weakSelf.delegate tencentAuthorizeFinish:accessToken withExpireTime:expiredTime withOpenID:openID];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf.delegate tencentAuthorizeFail];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
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

@end
