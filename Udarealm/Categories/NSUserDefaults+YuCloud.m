//
//  NSUserDefaults+YuCloud.m
//  YuCloud
//
//  Created by 熊国锋 on 15/11/30.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import "NSUserDefaults+YuCloud.h"

NSString * const kDefaultKeyForAds                      = @"ads";
NSString * const kDefaultKeyForEula                     = @"eula";
NSString * const kDefaultKeyForAppIps                   = @"app_ips";
NSString * const kDefaultKeyForFileIps                  = @"file_ips";
NSString * const kDefaultKeyForCopyright                = @"copyright";
NSString * const kDefaultKeyForSmsPhones                = @"smsPhones";
NSString * const kDefaultKeyForHelp                     = @"help";
NSString * const kDefaultKeyForHotline                  = @"hotline";

NSString * const kDefaultKeyForSplash                   = @"splash";
NSString * const kDefaultKeyForAccountType              = @"accountType";
NSString * const kDefaultKeyForOpenId                   = @"openid";
NSString * const kDefaultKeyForAccessToken              = @"accessToken";
NSString * const kDefaultKeyForRefreshToken             = @"refreshToken";
NSString * const kDefaultKeyForExpirationDate           = @"expirationDate";
NSString * const kDefaultKeyForNickName                 = @"nickName";
NSString * const kDefaultKeyForAvatarName               = @"avatarName";
NSString * const kDefaultKeyForThirdAccounts            = @"thirdAccounts";
NSString * const kDefaultKeyForChatUserid               = @"chatUserid";

NSString * const kDefaultKeyForTempNumber               = @"tempNumber";
NSString * const kDefaultKeyForBanner                   = @"bannerData";
NSString * const kDefaultKeyForContactIdentifier        = @"contactIdentifier";
NSString * const kDefaultKeyForChatStyle                = @"chatStyle";
NSString * const kDefaultKeyForScanQrHint               = @"scanQrHint";
NSString * const kDefaultKeyForQrImage                  = @"QRImage";
NSString * const kDefaultKeyForMonitorHint              = @"monitorHint";
NSString * const kDefaultKeyForRecordHint               = @"recordHint";
NSString * const kDefaultKeyForDBVersion                = @"databaseVersion";
NSString * const kDefaultKeyForServerAddress            = @"serverAddress";
NSString * const kDefaultKeyForfileIp                   = @"fileIp";
NSString * const kDefaultKeyForDeviceModels             = @"deviceModels";
NSString * const kDefaultKeyForiTunesVersionCheck       = @"iTunesVersionCheck";
NSString * const kDefaultKeyForSearchOptionsCheck       = @"searchOptionsCheck";

NSString * const kDefaultKeyForUserid    = @"id";
NSString *const kDefaultKeyForPush_id    = @"push_id";
NSString *const kDefaultKeyForPush_token = @"push_token";
NSString *const kDefaultKeyForStatus     = @"status";
NSString *const kDefaultKeyForToken      = @"token";
NSString *const kDefaultKeyForBirthday   = @"bithday";
NSString *const kDefaultKeyForBlood_type = @"blood_type";
NSString *const kDefaultKeyForFace_url   = @"face_url";
NSString *const kDefaultKeyForHas_child  = @"has_child";
NSString *const kDefaultKeyForIs_marry   = @"is_marry";
NSString *const kDefaultKeyForLocate     = @"locate";
NSString *const kDefaultKeyForNick_name  = @"nick_name";
NSString *const kDefaultKeyForPhone      = @"phone";
NSString *const kDefaultKeyForSex        = @"sex";
NSString *const kDefaultKeyForSignature  = @"signature";

@implementation NSUserDefaults (YuCloud)



+ (NSUserDefaults *)YuCloudDefaults
{
#ifdef DOUBI_IN_DEV_MODE
    NSString *userDefaultsName = @"DoubiDev";
#else
    NSString *userDefaultsName = @"Doubi";
#endif //DOUBI_IN_DEV_MODE
    return [[NSUserDefaults alloc] initWithSuiteName:userDefaultsName];
}

/*
 *  主接口相关
 */

+ (NSArray *)appAds
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForAds];
}

+ (void)saveAppAds:(NSArray *)ads
{
    [[NSUserDefaults YuCloudDefaults] setObject:ads forKey:kDefaultKeyForAds];
}

+ (NSString *)appEula
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForEula];
}

+ (void)saveAppEula:(NSString *)eula
{
    [[NSUserDefaults YuCloudDefaults] setObject:eula forKey:kDefaultKeyForEula];
}

+ (NSArray *)appIps
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForAppIps];
}

+ (void)saveAppIps:(NSArray *)ips
{
    [[NSUserDefaults YuCloudDefaults] setObject:ips forKey:kDefaultKeyForAppIps];
}

+ (NSArray *)fileIps
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForFileIps];
}

+ (void)saveFileIps:(NSArray *)ips
{
    return[[NSUserDefaults YuCloudDefaults] setObject:ips forKey:kDefaultKeyForFileIps];
}

+ (NSString *)appCopyright
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForCopyright];
}

+ (void)saveAppCopyright:(NSString *)copyright
{
    [[NSUserDefaults YuCloudDefaults] setObject:copyright forKey:kDefaultKeyForCopyright];
}

+ (NSArray *)appSmsReceivePhones
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForSmsPhones];
}

+ (void)saveAppSmsReceivePhones:(NSArray *)phones
{
    [[NSUserDefaults YuCloudDefaults] setObject:phones forKey:kDefaultKeyForSmsPhones];
}

+ (NSString *)appHelp
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForHelp];
}

+ (void)saveAppHelp:(NSString *)help
{
    [[NSUserDefaults YuCloudDefaults] setObject:help forKey:kDefaultKeyForHelp];
}

+ (NSString *)appHotline
{
    return @"025-84159009";
//    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForHotline];
}

+ (void)saveAppHotline:(NSString *)hotline
{
    [[NSUserDefaults YuCloudDefaults] setObject:hotline forKey:kDefaultKeyForHotline];
}


/*
 *  用户账户相关
 */
+ (NSString *)splashKeySetting
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForSplash];
}

+ (void)saveSplashKey:(NSString *)splash
{
    [[NSUserDefaults YuCloudDefaults] setObject:splash forKey:kDefaultKeyForSplash];
}

+ (NSNumber *)loginid
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForUserid];
}

+ (void)saveLoginid:(NSNumber *)loginid
{
    [[NSUserDefaults YuCloudDefaults] setObject:loginid forKey:kDefaultKeyForUserid];
}

+ (NSString *)openId
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForOpenId];
}

+ (void)saveOpenId:(NSString *)openid
{
    [[NSUserDefaults YuCloudDefaults] setObject:openid forKey:kDefaultKeyForOpenId];
}

+ (NSString *)accessToken
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForAccessToken];
}

+ (void)saveAccessToken:(NSString *)access_token
{
    [[NSUserDefaults YuCloudDefaults] setObject:access_token forKey:kDefaultKeyForAccessToken];
}

+ (NSString *)refreshToken
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForRefreshToken];
}

+ (void)saveRefreshToken:(NSString *)refresh_token
{
    [[NSUserDefaults YuCloudDefaults] setObject:refresh_token forKey:kDefaultKeyForRefreshToken];
}

+ (NSDate *)expirationDate
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForExpirationDate];
}

+ (void)saveExpirationDate:(NSDate *)date
{
    [[NSUserDefaults YuCloudDefaults] setObject:date forKey:kDefaultKeyForExpirationDate];
}


+ (NSString *)nickName
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForNickName];
}

+ (void)saveNickName:(NSString *)nickName
{
    [[NSUserDefaults YuCloudDefaults] setObject:nickName forKey:kDefaultKeyForNickName];
}

+ (NSString *)avatarName
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForAvatarName];
}

+ (void)saveAvatarName:(NSString *)name
{
    [[NSUserDefaults YuCloudDefaults] setObject:name forKey:kDefaultKeyForAvatarName];
}

+ (NSArray *)thirdAccounts
{
    return [[[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForThirdAccounts] mutableCopy];
}

+ (void)saveThirdAccounts:(NSArray *)thirdAccounts
{
    [[NSUserDefaults YuCloudDefaults] setObject:thirdAccounts forKey:kDefaultKeyForThirdAccounts];
}

+ (NSString *)chatUserid
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForChatUserid];
}

+ (void)saveChatUserid:(NSString *)chatUserid
{
    [[NSUserDefaults YuCloudDefaults] setObject:chatUserid forKey:kDefaultKeyForChatUserid];
}


+ (NSString *)push_id {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForPush_id];
}
+ (void)savePush_id:(NSString *)push_id {
    [[NSUserDefaults YuCloudDefaults] setObject:push_id forKey:kDefaultKeyForPush_id];
}

+ (NSString *)push_token {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForPush_token];
}
+ (void)savePush_token:(NSString *)push_token {
    [[NSUserDefaults YuCloudDefaults] setObject:push_token forKey:kDefaultKeyForPush_token];
}

+ (NSNumber *)status {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForStatus];
}
+ (void)saveStatus:(NSNumber *)status {
    [[NSUserDefaults YuCloudDefaults] setObject:status forKey:kDefaultKeyForStatus];
}

+ (NSString *)token {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForToken];
}
+ (void)saveToken:(NSString *)token {
    [[NSUserDefaults YuCloudDefaults] setObject:token forKey:kDefaultKeyForToken];
}

+ (NSString *)birthDay {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForBirthday];
}
+ (void)savebirthDay:(NSString *)birthday {
    [[NSUserDefaults YuCloudDefaults] setObject:birthday forKey:kDefaultKeyForBirthday];
}

+ (NSString *)blood_type {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForBlood_type];
}
+ (void)saveBlood_type:(NSString *)bool_type {
    [[NSUserDefaults YuCloudDefaults] setObject:bool_type forKey:kDefaultKeyForBlood_type];
}

+ (NSString *)face_url {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForFace_url];
}
+ (void)saveFace_url:(NSString *)face_url {
    [[NSUserDefaults YuCloudDefaults] setObject:face_url forKey:kDefaultKeyForFace_url];
}

+ (NSNumber *)has_child {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForHas_child];
}
+ (void)saveHas_child:(NSNumber *)has_child {
    [[NSUserDefaults YuCloudDefaults] setObject:has_child forKey:kDefaultKeyForHas_child];
}

+ (NSNumber *)is_marry {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForIs_marry];
}
+ (void)saveIs_marry:(NSNumber *)is_marry {
    [[NSUserDefaults YuCloudDefaults] setObject:is_marry forKey:kDefaultKeyForIs_marry];
}

+ (NSString *)locate {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForLocate];
}
+ (void)saveLocate:(NSString *)locate {
    [[NSUserDefaults YuCloudDefaults] setObject:locate forKey:kDefaultKeyForLocate];
}

+ (NSString *)nick_name {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForNick_name];
}
+ (void)saveNick_name:(NSString *)nick_name {
    [[NSUserDefaults YuCloudDefaults] setObject:nick_name forKey:kDefaultKeyForNick_name];
}

+ (NSString *)phone {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForPhone];
}
+ (void)savePhone:(NSString *)phone {
    [[NSUserDefaults YuCloudDefaults] setObject:phone forKey:kDefaultKeyForPhone];
}

+ (NSNumber *)sex {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForSex];
}
+ (void)saveSex:(NSNumber *)sex {
    [[NSUserDefaults YuCloudDefaults] setObject:sex forKey:kDefaultKeyForSex];
}

+ (NSString *)signature {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForSignature];
}
+ (void)saveSignature:(NSString *)signature {
    [[NSUserDefaults YuCloudDefaults] setObject:signature forKey:kDefaultKeyForSignature];
}





/*
 *  用户使用习惯相关
 */

+ (void)clearUserDefaults
{
    //清除缓存数据时，顺便清除相应设置项，需要清除的，加在下面这个数组里
    NSArray *keys = @[kDefaultKeyForQrImage];
    for (NSString *item in keys) {
        [[NSUserDefaults YuCloudDefaults] removeObjectForKey:item];
    }
    [[NSUserDefaults YuCloudDefaults] synchronize];
}

+ (NSArray *)bannerDataWithIdentifier:(NSString *)identifier {
    NSDictionary *dic = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForBanner];
    return [dic objectForKey:identifier];
}

+ (void)saveBannerData:(NSArray *)data identifier:(NSString *)identifier {
    NSMutableDictionary *dic;
    NSDictionary *defaults = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForBanner];
    if (defaults) {
        dic = [NSMutableDictionary dictionaryWithDictionary:defaults];
    }
    else {
        dic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    [dic setValue:data forKey:identifier];
    
    [[NSUserDefaults YuCloudDefaults] setObject:dic forKey:kDefaultKeyForBanner];
}

+ (NSString *)tempNumber
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForTempNumber];
}

+ (void)saveTempNumber:(NSString *)number
{
    [[NSUserDefaults YuCloudDefaults] setObject:number forKey:kDefaultKeyForTempNumber];
}

+ (NSString *)contactIdentifier
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForContactIdentifier];
}

+ (void)saveContactIdentifier:(NSString *)identifier
{
    [[NSUserDefaults YuCloudDefaults] setObject:identifier forKey:kDefaultKeyForContactIdentifier];
}

+ (BOOL)deviceChatAudioStyle
{
    NSNumber *number = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForChatStyle];
    if(number == nil)
    {
        return YES;
    }
    return [number boolValue];
}

+ (void)saveDeviceChatAudioStyle:(BOOL)style
{
    NSNumber *number = [NSNumber numberWithBool:style];
    [[NSUserDefaults YuCloudDefaults] setObject:number forKey:kDefaultKeyForChatStyle];
}

+ (BOOL)scanQrShowHintImage
{
    NSNumber *number = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForScanQrHint];
    if(number == nil)
    {
        return YES;
    }
    
    return [number boolValue];
}

+ (void)saveScanQrShowHintImage:(BOOL)show
{
    [[NSUserDefaults YuCloudDefaults] setObject:[NSNumber numberWithBool:show] forKey:kDefaultKeyForScanQrHint];
}

+ (BOOL)monitorShowHint
{
    NSNumber *number = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForMonitorHint];
    if(number == nil)
    {
        return YES;
    }
    
    return [number boolValue];
}

+ (void)saveMonitorShowHint:(BOOL)show
{
    [[NSUserDefaults YuCloudDefaults] setObject:[NSNumber numberWithBool:show] forKey:kDefaultKeyForMonitorHint];
}

+ (BOOL)recordShowHint
{
    NSNumber *number = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForRecordHint];
    if(number == nil)
    {
        return YES;
    }
    
    return [number boolValue];
}

+ (void)saveRecordShowHint:(BOOL)show
{
    [[NSUserDefaults YuCloudDefaults] setObject:[NSNumber numberWithBool:show] forKey:kDefaultKeyForRecordHint];
}

+ (NSString *)databaseVersionString
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForDBVersion];
}

+ (void)saveDatabaseVersionString:(NSString *)version
{
    [[NSUserDefaults YuCloudDefaults] setObject:version forKey:kDefaultKeyForDBVersion];
}

+ (NSString *)serverAddress
{
    NSString *string = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForServerAddress];
    if ([string length] == 0) {
        NSArray *ips = [NSUserDefaults appIps];
        if ([ips count]) {
            string = [ips firstObject];
        }
        else {
            string = @"http://192.168.1.5/";
//            DDLogError(@"%s null", __PRETTY_FUNCTION__);
        }
    }
    
    return string;
}

+ (void)saveServerAddress:(NSString *)address
{
    [[NSUserDefaults YuCloudDefaults] setObject:address forKey:kDefaultKeyForServerAddress];
}

+ (NSString *)fileip
{
    NSString *string = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForfileIp];
    if ([string length] == 0) {
        NSArray *ips = [NSUserDefaults fileIps];
        if ([ips count]) {
            return [ips firstObject];
        }
        else {
            return [NSUserDefaults serverAddress];
        }
    }
    
    return string;
}

+ (void)saveFileIp:(NSString *)ip
{
    
}

/*
 *  一些缓存的数据
 */

+ (NSString *)deviceQRCodeForSN:(NSString *)sn
{
    NSDictionary *qrImages = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForQrImage];
    return [qrImages objectForKey:sn];
}

+ (void)saveDeviceQRCode:(NSString *)code forSN:(NSString *)sn
{
    NSMutableDictionary *qrImages;
    NSDictionary *defaults = [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForQrImage];
    if (defaults) {
        qrImages = [NSMutableDictionary dictionaryWithDictionary:defaults];
    }
    else {
        qrImages = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    [qrImages setValue:code forKey:sn];
    
    [[NSUserDefaults YuCloudDefaults] setObject:qrImages forKey:kDefaultKeyForQrImage];
}

+ (NSArray *)deviceModels
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForDeviceModels];
}

+ (void)saveDeviceModels:(NSArray *)models
{
    [[NSUserDefaults YuCloudDefaults] setObject:models forKey:kDefaultKeyForDeviceModels];
}

+ (NSDate *)iTunesVersionCheckDate
{
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForiTunesVersionCheck];
}

+ (void)saveiTunesVersionCheckDate:(NSDate *)date
{
    [[NSUserDefaults YuCloudDefaults] setObject:date forKey:kDefaultKeyForiTunesVersionCheck];
}

+ (NSDate *)searchOptionsCheckDate {
    return [[NSUserDefaults YuCloudDefaults] objectForKey:kDefaultKeyForSearchOptionsCheck];
}

+ (void)saveSearchOptionsCheckDate:(NSDate *)date {
    [[NSUserDefaults YuCloudDefaults] setObject:date forKey:kDefaultKeyForSearchOptionsCheck];
}

#define LAST_LOCATION_COORDINATE_KEY    @"lastLocationKey"
+ (CLLocationCoordinate2D)lastLocationCoordinate {
    NSString *latKey = [NSString stringWithFormat:@"%@%@", LAST_LOCATION_COORDINATE_KEY, @"lat"];
    NSString *lonKey = [NSString stringWithFormat:@"%@%@", LAST_LOCATION_COORDINATE_KEY, @"lon"];
    double lat = [[NSUserDefaults YuCloudDefaults] doubleForKey:latKey];
    double lon = [[NSUserDefaults YuCloudDefaults] doubleForKey:lonKey];
    
    return CLLocationCoordinate2DMake(lat, lon);
}

+ (void)saveLastLocationCoordinate:(CLLocationCoordinate2D)location {
    NSString *latKey = [NSString stringWithFormat:@"%@%@", LAST_LOCATION_COORDINATE_KEY, @"lat"];
    NSString *lonKey = [NSString stringWithFormat:@"%@%@", LAST_LOCATION_COORDINATE_KEY, @"lon"];
    
    [[NSUserDefaults YuCloudDefaults] setDouble:location.latitude forKey:latKey];
    [[NSUserDefaults YuCloudDefaults] setDouble:location.longitude forKey:lonKey];
}

@end



