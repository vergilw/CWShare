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
#define CW_TENCENT_REFRESH_TOKEN @"CWShareTencentRefreshToken"
#define CW_TENCENT_REFRESH_TOKEN_EXPIRED_DATE @"CWShareTencentRefreshTokenExpiredDate"

@implementation CWShareStorage

+ (void)clearSinaStoreInfo
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls removeObjectForKey:CW_SINA_ACCESS_TOKEN];
    [userDefauls removeObjectForKey:CW_SINA_EXPIRED_DATE];
    [userDefauls removeObjectForKey:CW_SINA_USER_ID];
}

+ (NSString *)getSinaAccessToken
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_SINA_ACCESS_TOKEN];
}

+ (void)setSinaAccessToken:(NSString *)theAccessToken
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:theAccessToken forKey:CW_SINA_ACCESS_TOKEN];
}

+ (NSDate *)getSinaExpiredDate
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_SINA_EXPIRED_DATE];
}

+ (void)setSinaExpiredDate:(NSDate *)theDate
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:theDate forKey:CW_SINA_EXPIRED_DATE];
}

+ (NSString *)getSinaUserID
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_SINA_USER_ID];
}

+ (void)setSinaUserID:(NSString *)userID
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:userID forKey:CW_SINA_USER_ID];
}

+ (void)clearTencentStoreInfo
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst removeObjectForKey:CW_TENCENT_ACCESS_TOKEN];
    [userDefaulst removeObjectForKey:CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE];
    [userDefaulst removeObjectForKey:CW_TENCENT_USER_ID];
    [userDefaulst removeObjectForKey:CW_TENCENT_REFRESH_TOKEN];
    [userDefaulst removeObjectForKey:CW_TENCENT_REFRESH_TOKEN_EXPIRED_DATE];
}

+ (NSString *)getTencentAccessToken
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_TENCENT_ACCESS_TOKEN];
}

+ (void)setTencentAccessToken:(NSString *)theAccessToken
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:theAccessToken forKey:CW_TENCENT_ACCESS_TOKEN];
}

+ (NSDate *)getTencentExpiredDate
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE];
}

+ (void)setTencentExpiredDate:(NSDate *)theDate
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:theDate forKey:CW_TENCENT_ACCESS_TOKEN_EXPIRED_DATE];
}

+ (NSString *)getTencentUserID
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_TENCENT_USER_ID];
}

+ (void)setTencentUserID:(NSString *)userID
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:userID forKey:CW_TENCENT_USER_ID];
}

+ (NSString *)getTencentRefreshToken
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_TENCENT_REFRESH_TOKEN];
}

+ (void)setTencentRefreshToken:(NSString *)refreshToken
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:refreshToken forKey:CW_TENCENT_REFRESH_TOKEN];
}

+ (NSDate *)getTencentRefreshTokenExpireDate
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    return [userDefauls objectForKey:CW_TENCENT_REFRESH_TOKEN_EXPIRED_DATE];
}

+ (void)setTencentRefreshTokenExpireDate:(NSDate *)expireDate
{
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    [userDefauls setObject:expireDate forKey:CW_TENCENT_REFRESH_TOKEN_EXPIRED_DATE];
}

@end
