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

@protocol CWShareDelegate <NSObject>

@optional
- (void)sinaAuthorizeFail;

@end

@interface CWShare : NSObject {
    CWShareSina *sinaShare;
    CWShareTencent *tencentShare;
    id<CWShareDelegate> delegate;
}

@property (nonatomic, strong) CWShareSina *sinaShare;
@property (nonatomic, strong) CWShareTencent *tencentShare;
@property (weak) id<CWShareDelegate> delegate;


- (void)startSinaAuthorize;
- (void)sinaShareWithContent:(NSString *)theContent;
- (void)sinaShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;


- (void)startTencentAuthorize;
- (void)tencentShareWithContent:(NSString *)theContent;
- (void)tencentShareWithContent:(NSString *)theContent withImage:(UIImage *)theImage;

@end
