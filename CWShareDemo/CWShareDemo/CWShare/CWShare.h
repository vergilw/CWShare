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

//开始新浪微博授权
- (void)startSinaAuthorize;
//分享内容到新浪微博
- (void)sinaShareWithContent:(NSString *)theContent;
//分享内容和图片到新浪微博
- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

//开始腾讯QQ授权
- (void)startTencentAuthorize;
//分享内容到腾讯微博
- (void)tencentShareToWeiBoWithContent:(NSString *)theContent;
//分享内容和图片到腾讯微博
- (void)tencentShareToWeiBoWithContent:(NSString *)theContent withImage:(UIImage *)theImage;
//分享内容到QQ空间(QQ空间的分享属于网页资源，所以需要传的参数比较多)
- (void)tencentShareToQQZoneWithDescription:(NSString *)theDesc withTitle:(NSString *)theTitle Content:(NSString *)theContent withSynchronizeWeibo:(BOOL)theBool;

@end
