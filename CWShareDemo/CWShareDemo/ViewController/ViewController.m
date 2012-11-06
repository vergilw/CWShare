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

@synthesize sinaShare,tencentShare;

- (void)dealloc
{
    [self setSinaShare:nil];
    [self setTencentShare:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
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
    self.sinaShare = [[[CWShareSina alloc] init] autorelease];
    [sinaShare setDelegate:self];
    [sinaShare startAuthorize];
}

- (IBAction)sinaShareContent:(id)sender
{
    [sinaShare shareWithContent:@"it's a debug test from my app, you can ignore this message."];
}

- (IBAction)sinaShareContentAndImage:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [sinaShare shareWithContent:@"it's a debug test from my app, you can ignore this message." withImage:uploadImage];
}

- (IBAction)tencentAuthorizeAction:(id)sender
{
    self.tencentShare = [[[CWShareTencent alloc] init] autorelease];
    [tencentShare setDelegate:self];
    [tencentShare startAuthorize];
}

- (IBAction)tencentShareContent:(id)sender
{
    [tencentShare shareWithContent:@"it's a debug test from my app, you can ignore this message."];
}

- (IBAction)tencentShareContentAndImage:(id)sender
{
    UIImage *uploadImage = [UIImage imageNamed:@"blackArrow@2x.png"];
    [tencentShare shareWithContent:@"it's a debug test from my app, you can ignore this message." withImage:uploadImage];
}

#pragma mark - CWShareSina Delegate

- (void)sinaShareAuthorizeFinish
{
    
}

- (void)sinaShareAuthorizeFail
{
    
}

#pragma mark - CWShareTencent Delegate

- (void)tencentShareAuthorizeFinish
{
    
}

- (void)tencentShareAuthorizeFail
{
    
}

@end
