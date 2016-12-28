//
//  CommPros.h
//  YuCloud
//
//  Created by 熊国锋 on 15/8/25.
//  Copyright (c) 2015年 VIROYAL-ELEC. All rights reserved.
//

#ifndef __YuCloud__CommPros__
#define __YuCloud__CommPros__

#import <UIKit/UIKit.h>
#include <stdio.h>
#import "CocoaLumberjack.h"

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define kYuCloudViewControllerBackgroundColor       UIColorFromHex(0xeff3f4)
#define kYuCloudButtonBackgroundColor               UIColorFromHex(0x29b4cd)
#define kYuCloudTextColorLightWhite                 UIColorFromHex(0xb0b0b0)
#define kYuCloudTextFieldTextColor                  UIColorFromHex(0xa6a6a6)
#define kYuCloudRoutePolylineColor                  UIColorFromHex(0x54aaaa)
#define kYuCloudBarTintColor                        UIColorFromHex(0x26b8d1)
#define kYuCloudChatBlueColor                       UIColorFromHex(0x26b8d1)

#define kYuCloudBatteryTintColor                    UIColorFromHex(0x00c751)
#define kYuCloudBatteryBackColor                    UIColorFromHex(0x979797)


#if YUCLOUD_DEV_MODE
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#endif //YUCLOUD_DEV_MODE

#define PROGRESS_DELAY_HIDE 2

#define YUCLOUD_VALIDATE_STRING(string) (string && [string isKindOfClass:[NSString class]])?string:nil
#define YUCLOUD_VALIDATE_NUMBER(number) (number && [number isKindOfClass:[NSNumber class]])?number:nil

#define YUCLOUD_VALIDATE_STRING_WITH_DEFAULT(string, default) (string && [string isKindOfClass:[NSString class]])?string:default
#define YUCLOUD_VALIDATE_NUMBER_WITH_DEFAULT(number, default) (number && [number isKindOfClass:[NSNumber class]])?number:default

#define YUCLOUD_STATUS_HEIGHT                           [[CommPros sharedClient] GetStatusBarHeight]
#define YUCLOUD_NAVIGATION_HEIGHT                       [[CommPros sharedClient] GetNavigationBarHeight]
#define YUCLOUD_SYSTEM_FONT_WITH_SIZE(size)             [[CommPros sharedClient] SystemFontWithSize:size]
#define YUCLOUD_MD5_OF_THE_STRING(string)               [[CommPros sharedClient] md5OfString:string]
#define YUCLOUD_STRING_FOR_TIME_INTERVAL(interval)      [[CommPros sharedClient] stringForTimeInterval:interval]
#define YUCLOUD_INTERFACE_MASTER_KEY                    [[CommPros sharedClient] masterKeyOfYuCloudInterface]

#define YUCLOUD_STRING_PLEASE_WAIT                      NSLocalizedString(@"Please wait", nil)
#define YUCLOUD_STRING_SUCCESS                          NSLocalizedString(@"Success", nil)
#define YUCLOUD_STRING_FAILED                           NSLocalizedString(@"Failed", nil)
#define YUCLOUD_STRING_CANCEL                           NSLocalizedString(@"Cancel", nil)
#define YUCLOUD_STRING_DONE                             NSLocalizedString(@"Done", nil)
#define YUCLOUD_STRING_SAVE                             NSLocalizedString(@"Save", nil)
#define YUCLOUD_STRING_OK                               NSLocalizedString(@"OK", nil)

#define YUCLOUD_IMAGE_SUCCESS                           [UIImage imageNamed:@"icon_common_finished"]
#define YUCLOUD_IMAGE_FAILED                            [UIImage imageNamed:@"icon_common_failed"]

#define YUCLOUD_SANDBOX_APPLICATION_DIRECTORY           [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

#define WEAK(var, name)             __weak __typeof(var) name = var
#define STRONG(var, name)         __strong __typeof(var) name = var

typedef void (^CommonBlock)(BOOL success, NSDictionary * _Nullable info);


typedef NS_ENUM(NSInteger, FontSize)
{
    FontSizeXXXL,
    FontSizeXXL,
    FontSizeXL,
    FontSizeLarge,
    FontSizeNormal,
    FontSizeSmall,
    FontSizeXS,
    FontSizeXXS,
    
    //add new items before this item
    FontSizeCount
};

typedef NS_ENUM(NSInteger, UIDeviceResolution)
{
    UIDeviceResolution_iPhoneStandard,      // iPhone 1,3,3GS Standard Display      (320x480px)
    UIDeviceResolution_iPhoneRetina4,       // iPhone 4,4S Retina Display 3.5"      (640x960px)
    UIDeviceResolution_iPhoneRetina5,       // iPhone 5,5s,se Retina Display 4"     (640x1136px)
    UIDeviceResolution_iPhoneRetina6,       // iPhone 6 Retina Display 4.7"         (750x1134px)
    UIDeviceResolution_iPhoneRetina6p,      // iPhone 6p,6sp Retina Display 5.5"    (1242x2208px)
    
    UIDeviceResolution_iPadStandard,        // iPad 1,2,mini Standard Display       (1024x768px)
    UIDeviceResolution_iPadRetina,          // iPad 3 Retina Display                (2048x1536px)
    
    UIDeviceResolution_Unknown
};

@interface CommPros : NSObject

+ (instancetype)sharedClient;

@property (atomic, assign, readonly) UIDeviceResolution resolution;
@property (atomic, assign, readonly) CGSize             resSize;
@property (nonatomic, copy)          NSString           *resString;

- (CGFloat)GetStatusBarHeight;
- (CGFloat)GetNavigationBarHeight;

- (nullable UIFont *)SystemFontWithSize:(FontSize)size;
- (NSString *)md5OfData:(NSData *)data;
- (nullable NSString *)md5OfString:(NSString *)string;
- (NSTimeInterval)startTimeOfDate:(NSDate *)date;
- (NSTimeInterval)endTimeOfDate:(NSDate *)date;

- (NSString *)stringForTimeInterval:(NSTimeInterval)interval;
- (NSString *)welcomeStringForDate:(nullable NSDate *)date;


- (NSString *)osPlatform;
- (NSString *)osModel;
- (NSString *)osVersion;
- (NSString *)appVersion;

@end

NS_ASSUME_NONNULL_END

#endif /* defined(__YuCloud__CommPros__) */
