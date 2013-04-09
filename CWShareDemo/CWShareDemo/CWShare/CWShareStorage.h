//
//  CWShareStorage.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>

@interface CWShareStorage : NSObject

//新浪微博信息存储
+ (void)clearSinaStoreInfo;

+ (NSString *)getSinaAccessToken;
+ (void)setSinaAccessToken:(NSString *)theAccessToken;

+ (NSDate *)getSinaExpiredDate;
+ (void)setSinaExpiredDate:(NSDate *)theDate;

+ (NSString *)getSinaUserID;
+ (void)setSinaUserID:(NSString *)userID;



//腾讯QQ信息存储
+ (void)clearTencentStoreInfo;

+ (NSString *)getTencentAccessToken;
+ (void)setTencentAccessToken:(NSString *)theAccessToken;

+ (NSDate *)getTencentExpiredDate;
+ (void)setTencentExpiredDate:(NSDate *)theDate;

+ (NSString *)getTencentUserID;
+ (void)setTencentUserID:(NSString *)userID;

@end
