//
//  NSUserDefaults+YuCloud.h
//  YuCloud
//
//  Created by 熊国锋 on 15/11/30.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSUserDefaults (YuCloud)

+ (NSUserDefaults *)YuCloudDefaults;

/*
 *  主接口相关
 */

+ (NSArray *)appAds;
+ (void)saveAppAds:(NSArray *)ads;

+ (NSString *)appEula;
+ (void)saveAppEula:(NSString *)eula;

+ (NSArray *)appIps;
+ (void)saveAppIps:(NSArray *)ips;

+ (NSArray *)fileIps;
+ (void)saveFileIps:(NSArray *)ips;

+ (NSString *)appCopyright;
+ (void)saveAppCopyright:(NSString *)copyright;

+ (NSArray *)appSmsReceivePhones;
+ (void)saveAppSmsReceivePhones:(NSArray *)phones;

+ (NSString *)appHelp;
+ (void)saveAppHelp:(NSString *)help;

+ (NSString *)appHotline;
+ (void)saveAppHotline:(NSString *)hotline;

/*
 *  用户账户相关
 */

+ (NSString *)splashKeySetting;
+ (void)saveSplashKey:(NSString *)splash;

+ (NSNumber *)loginid;
+ (void)saveLoginid:(NSNumber *)loginid;

+ (NSString *)token;
+ (void)saveToken:(NSString *)token;

+ (NSString *)openId;
+ (void)saveOpenId:(NSString *)openid;

+ (NSString *)accessToken;
+ (void)saveAccessToken:(NSString *)access_token;

+ (NSString *)refreshToken;
+ (void)saveRefreshToken:(NSString *)refresh_token;

+ (NSDate *)expirationDate;
+ (void)saveExpirationDate:(NSDate *)date;

+ (NSString *)nickName;
+ (void)saveNickName:(NSString *)nickName;

+ (NSString *)phone;
+ (void)savePhone:(NSString *)phone;

+ (NSString *)avatarName;
+ (void)saveAvatarName:(NSString *)name;

+ (NSArray *)thirdAccounts;
+ (void)saveThirdAccounts:(NSArray *)thirdAccounts;

+ (NSString *)chatUserid;
+ (void)saveChatUserid:(NSString *)chatUserid;




+ (NSString *)push_id;
+ (void)savePush_id:(NSString *)push_id;
+ (NSString *)push_token;
+ (void)savePush_token:(NSString *)push_token;
+ (NSNumber *)status;
+ (void)saveStatus:(NSNumber *)status;
+ (NSString *)birthDay;
+ (void)savebirthDay:(NSString *)birthday;
+ (NSString *)blood_type;
+ (void)saveBlood_type:(NSString *)bool_type;
+ (NSString *)face_url;
+ (void)saveFace_url:(NSString *)face_url;
+ (NSNumber *)has_child;
+ (void)saveHas_child:(NSNumber *)has_child;
+ (NSNumber *)is_marry;
+ (void)saveIs_marry:(NSNumber *)is_marry;
+ (NSString *)locate;
+ (void)saveLocate:(NSString *)locte;
+ (NSString *)nick_name;
+ (void)saveNick_name:(NSString *)nick_name;
+ (NSNumber *)sex;
+ (void)saveSex:(NSNumber *)sex;
+ (NSString *)signature;
+ (void)saveSignature:(NSString *)signature;

/*
 *  用户使用习惯相关
 */

+ (void)clearUserDefaults;

+ (NSArray *)bannerDataWithIdentifier:(NSString *)identifier;
+ (void)saveBannerData:(NSArray *)data identifier:(NSString *)identifier;

+ (NSString *)tempNumber;
+ (void)saveTempNumber:(NSString *)number;

+ (NSString *)contactIdentifier;
+ (void)saveContactIdentifier:(NSString *)identifier;

+ (BOOL)deviceChatAudioStyle;
+ (void)saveDeviceChatAudioStyle:(BOOL)style;

+ (BOOL)scanQrShowHintImage;
+ (void)saveScanQrShowHintImage:(BOOL)show;

+ (BOOL)monitorShowHint;
+ (void)saveMonitorShowHint:(BOOL)show;

+ (BOOL)recordShowHint;
+ (void)saveRecordShowHint:(BOOL)show;

+ (NSString *)databaseVersionString;
+ (void)saveDatabaseVersionString:(NSString *)version;

+ (NSString *)serverAddress;
+ (void)saveServerAddress:(NSString *)address;

+ (NSString *)fileip;
+ (void)saveFileIp:(NSString *)ip;

/*
 *  一些缓存的数据
 */

+ (NSString *)deviceQRCodeForSN:(NSString *)sn;
+ (void)saveDeviceQRCode:(NSString *)code forSN:(NSString *)sn;

+ (NSArray *)deviceModels;
+ (void)saveDeviceModels:(NSArray *)models;

+ (NSDate *)iTunesVersionCheckDate;
+ (void)saveiTunesVersionCheckDate:(NSDate *)date;

+ (NSDate *)searchOptionsCheckDate;
+ (void)saveSearchOptionsCheckDate:(NSDate *)date;

+ (CLLocationCoordinate2D)lastLocationCoordinate;
+ (void)saveLastLocationCoordinate:(CLLocationCoordinate2D)location;

@end


