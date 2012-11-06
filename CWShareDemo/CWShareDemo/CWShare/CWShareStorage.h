//
//  CWShareStorage.h
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import <Foundation/Foundation.h>

@interface CWShareStorage : NSObject

+ (void)clearSinaStoreInfo;

+ (NSString *)getSinaAccessToken;
+ (void)setSinaAccessToken:(NSString *)theAccessToken;

+ (NSDate *)getSinaExpiredDate;
+ (void)setSinaExpiredDate:(NSDate *)theDate;

+ (NSString *)getSinaUserID;
+ (void)setSinaUserID:(NSString *)userID;

+ (void)clearTencentStoreInfo;

+ (NSString *)getTencentAccessToken;
+ (void)setTencentAccessToken:(NSString *)theAccessToken;

+ (NSDate *)getTencentExpiredDate;
+ (void)setTencentExpiredDate:(NSDate *)theDate;

+ (NSString *)getTencentUserID;
+ (void)setTencentUserID:(NSString *)userID;

@end
