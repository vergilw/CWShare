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

#define CW_TENCENT_ACCESS_TOKEN @"CWShareTencentAccessTOken"
#define CW_TENCENT_EXPIRED_DATE @"CWShareTencentExpiredDate"
#define CW_TENCENT_USER_ID @"CWShareTencentUserID"

@implementation CWShareStorage

+ (void)clearSinaStoreInfo
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst removeObjectForKey:CW_SINA_ACCESS_TOKEN];
    [userDefaulst removeObjectForKey:CW_SINA_EXPIRED_DATE];
    [userDefaulst removeObjectForKey:CW_SINA_USER_ID];
}

+ (NSString *)getSinaAccessToken
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    return [userDefaulst objectForKey:CW_SINA_ACCESS_TOKEN];
}

+ (void)setSinaAccessToken:(NSString *)theAccessToken
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst setObject:theAccessToken forKey:CW_SINA_ACCESS_TOKEN];
}

+ (NSDate *)getSinaExpiredDate
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    return [userDefaulst objectForKey:CW_SINA_EXPIRED_DATE];
}

+ (void)setSinaExpiredDate:(NSDate *)theDate
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst setObject:theDate forKey:CW_SINA_EXPIRED_DATE];
}

+ (NSString *)getSinaUserID
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    return [userDefaulst objectForKey:CW_SINA_USER_ID];
}

+ (void)setSinaUserID:(NSString *)userID
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst setObject:userID forKey:CW_SINA_USER_ID];
}

+ (void)clearTencentStoreInfo
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst removeObjectForKey:CW_TENCENT_ACCESS_TOKEN];
    [userDefaulst removeObjectForKey:CW_TENCENT_EXPIRED_DATE];
    [userDefaulst removeObjectForKey:CW_TENCENT_USER_ID];
}

+ (NSString *)getTencentAccessToken
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    return [userDefaulst objectForKey:CW_TENCENT_ACCESS_TOKEN];
}

+ (void)setTencentAccessToken:(NSString *)theAccessToken
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst setObject:theAccessToken forKey:CW_TENCENT_ACCESS_TOKEN];
}

+ (NSDate *)getTencentExpiredDate
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    return [userDefaulst objectForKey:CW_TENCENT_EXPIRED_DATE];
}

+ (void)setTencentExpiredDate:(NSDate *)theDate
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst setObject:theDate forKey:CW_TENCENT_EXPIRED_DATE];
}

+ (NSString *)getTencentUserID
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    return [userDefaulst objectForKey:CW_TENCENT_USER_ID];
}

+ (void)setTencentUserID:(NSString *)userID
{
    NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
    [userDefaulst setObject:userID forKey:CW_TENCENT_USER_ID];
}

@end
