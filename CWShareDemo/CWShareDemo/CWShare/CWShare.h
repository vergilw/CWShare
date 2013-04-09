//
//  CWShare.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>
#import "CWShareSina.h"
#import "CWShareTencent.h"
#import "CWShareDelegate.h"

@interface CWShare : NSObject <CWShareSinaDelegate,CWShareTencentDelegate> {
    CWShareSina *sinaShare;
    CWShareTencent *tencentShare;
    id<CWShareDelegate> delegate;
    UIViewController *parentViewController;
}

@property (nonatomic, strong) CWShareSina *sinaShare;
@property (nonatomic, strong) CWShareTencent *tencentShare;
@property (weak) id<CWShareDelegate> delegate;
@property (weak) UIViewController *parentViewController;

- (void)startSinaAuthorize;
- (void)sinaShareWithContent:(NSString *)theContent;
- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;


- (void)startTencentAuthorize;

- (void)tencentShareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent withSynchronizeWeibo:(BOOL)theBool;

- (void)tencentShareToWeiBoWithContent:(NSString *)theContent;

- (void)tencentShareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

@end
