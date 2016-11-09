//
//  CWShareWeChatDelegate.h
//  ClassInfo
//
//  Created by Wang Jun on 11/10/14.
//  Copyright (c) 2014 Vergil.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CWShareWeChatDelegate <NSObject>

@optional
- (void)wechatShareAuthorizeFinish:(NSDictionary *)userInfo;
- (void)wechatShareAuthorizeFail;

- (void)wechatShareFinish;
- (void)wechatShareFail;

@end
