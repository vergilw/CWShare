//
//  CWShare.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShare.h"

@implementation CWShare

@synthesize sinaShare,tencentShare,delegate;

- (void)dealloc
{
    [self setSinaShare:nil];
    [self setTencentShare:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sinaShare = [[[CWShareSina alloc] init] autorelease];
        self.tencentShare = [[[CWShareTencent alloc] init] autorelease];
    }
    return self;
}

#pragma mark - CWShare Sina Authorize

- (void)startSinaAuthorize
{
    [sinaShare startAuthorize];
}

- (void)sinaShareWithContent:(NSString *)theContent
{
    [sinaShare shareWithContent:theContent];
}

- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    [sinaShare shareWithContent:theContent withImage:theImage];
}

#pragma mark - CWShare Tencent Authorize

- (void)startTencentAuthorize
{
    [tencentShare startAuthorize];
}

- (void)tencentShareWithContent:(NSString *)theContent
{
    [tencentShare shareWithContent:theContent];
}

- (void)tencentShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage
{
    [tencentShare shareWithContent:theContent withImage:theImage];
}

@end
