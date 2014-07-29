//
//  CWShareStorage.m
//  CWShareDemo
//
//  Created by Wang Jun on 12-8-18.
//
//

#import "CWShareStorage.h"

#define CW_SINA_ACCESS_TOKEN @"CWShareSinaAccessToken"
#define CW_SINA_EXPIRED_DATE @"CWShareSinaExpiredDate"
#define CW_SINA_USER_ID @"CWShareSinaUserID"

#define CW_TENCENT_ACCESS_TOKEN @"CWShareTencentAccessToken"
#define CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE @"CWShareTencentAccessTokenExpiredDate"
#define CW_TENCENT_USER_ID @"CWShareTencentUserID"

@implementation CWShareStorage

+ (void)clearSinaStoreInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:CW_SINA_ACCESS_TOKEN];
    [userDefaults removeObjectForKey:CW_SINA_EXPIRED_DATE];
    [userDefaults removeObjectForKey:CW_SINA_USER_ID];
    [userDefaults synchronize];
}

+ (NSString *)getSinaAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:CW_SINA_ACCESS_TOKEN];
}

+ (void)setSinaAccessToken:(NSString *)theAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theAccessToken forKey:CW_SINA_ACCESS_TOKEN];
    [userDefaults synchronize];
}

+ (NSDate *)getSinaExpiredDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:CW_SINA_EXPIRED_DATE];
}

+ (void)setSinaExpiredDate:(NSDate *)theDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theDate forKey:CW_SINA_EXPIRED_DATE];
    [userDefaults synchronize];
}

+ (NSString *)getSinaUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:CW_SINA_USER_ID];
}

+ (void)setSinaUserID:(NSString *)userID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userID forKey:CW_SINA_USER_ID];
    [userDefaults synchronize];
}

+ (void)clearTencentStoreInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:CW_TENCENT_ACCESS_TOKEN];
    [userDefaults removeObjectForKey:CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE];
    [userDefaults removeObjectForKey:CW_TENCENT_USER_ID];
    [userDefaults synchronize];
}

+ (NSString *)getTencentAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:CW_TENCENT_ACCESS_TOKEN];
}

+ (void)setTencentAccessToken:(NSString *)theAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theAccessToken forKey:CW_TENCENT_ACCESS_TOKEN];
    [userDefaults synchronize];
}

+ (NSDate *)getTencentExpiredDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE];
}

+ (void)setTencentExpiredDate:(NSDate *)theDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theDate forKey:CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE];
    [userDefaults synchronize];
}

+ (NSString *)getTencentUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:CW_TENCENT_USER_ID];
}

+ (void)setTencentUserID:(NSString *)userID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userID forKey:CW_TENCENT_USER_ID];
    [userDefaults synchronize];
}

@end
