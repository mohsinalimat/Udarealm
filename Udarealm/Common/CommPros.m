//
//  CommPros.m
//  YuCloud
//
//  Created by 熊国锋 on 15/8/25.
//  Copyright (c) 2015年 VIROYAL-ELEC. All rights reserved.
//

#include "CommPros.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

@interface CommPros()


@end

@implementation CommPros
@synthesize resolution = _resolution;

+ (instancetype)sharedClient
{
    static CommPros *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CommPros alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init
{
    if (self = [super init]) {
        _resolution = UIDeviceResolution_Unknown;
    }
    
    return self;
}

- (CGFloat) GetStatusBarHeight
{
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    return rect.size.height;
}

- (CGFloat)GetNavigationBarHeight
{
    return 44.0;
}

- (UIFont *)SystemFontWithSize:(FontSize)size
{
    switch (size)
    {
        case FontSizeXXXL:
            return [UIFont systemFontOfSize:26.0];
        case FontSizeXXL:
            return [UIFont systemFontOfSize:24.0];
        case FontSizeXL:
            return [UIFont systemFontOfSize:22.0];
        case FontSizeLarge:
            return [UIFont systemFontOfSize:20.0];
        case FontSizeNormal:
            return [UIFont systemFontOfSize:18.0];
        case FontSizeSmall:
            return [UIFont systemFontOfSize:16.0];
        case FontSizeXS:
            return [UIFont systemFontOfSize:14.0];
        case FontSizeXXS:
            return [UIFont systemFontOfSize:12.0];
        case FontSizeCount:
            break;
            
    }
    return nil;
}

- (NSString *)md5OfData:(NSData *)data
{
    NSRange range = NSMakeRange(0, MIN(1024, [data length]));
    NSData *partData = [data subdataWithRange:range];
    NSString *string = [partData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [self md5OfString:string];
}

- (NSString *)md5OfString:(NSString *)string
{
    if(string == nil || [string length] == 0)
    {
        return nil;
    }
    
    const char *str = [string UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *MD5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [MD5 uppercaseString];
}

- (NSString *)stringForTimeInterval:(NSTimeInterval)interval
{
    NSInteger hours = interval / (60 * 60);
    NSInteger days = hours / 24;
    NSInteger years = days / 365;
    
    if(interval < 60 * 3)
    {
        //3分钟以内，视为刚刚
        return NSLocalizedString(@"Right now", nil);
    }
    else if(interval < 60 * 15)
    {
        //3-15分钟内
        return NSLocalizedString(@"3 minutes ago", nil);
    }
    else if(interval < 60 * 30)
    {
        //15-30分钟
        return NSLocalizedString(@"15 minutes ago", nil);
    }
    else if(interval < 60 * 60)
    {
        //30分钟-1小时
        return NSLocalizedString(@"30 minutes ago", nil);
    }
    else if(hours < 24)
    {
        //一天内
        return [NSString stringWithFormat:@"%ld %@", (long)hours, NSLocalizedString(@"hours ago", nil)];
    }
    else if(days < 365)
    {
        return [NSString stringWithFormat:@"%ld %@", (long)days, NSLocalizedString(@"days ago", nil)];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld %@", (long)years, NSLocalizedString(@"years ago", nil)];
    }
    
    DDLogError(@"stringForTimeInterval error interval: %f years: %ld days: %ld hours: %ld", interval, (long)years, (long)days, (long)hours);
    return @"";
}

- (NSTimeInterval)startTimeOfDate:(NSDate *)date
{
    NSDateComponents *coms = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:coms];
    
    return [newDate timeIntervalSince1970];
}

- (NSTimeInterval)endTimeOfDate:(NSDate *)date
{
    NSDateComponents *coms = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    [coms setValue:23 forComponent:NSCalendarUnitHour];
    [coms setValue:59 forComponent:NSCalendarUnitMinute];
    [coms setValue:59 forComponent:NSCalendarUnitSecond];
    
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:coms];
    
    return [newDate timeIntervalSince1970];
}

- (NSString *)welcomeStringForDate:(NSDate *)date
{
    if(date == nil)
    {
        date = [NSDate date];
    }
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = comp.hour;
    if(hour >= 6 && hour < 9)
    {
        //早上好
        return NSLocalizedString(@"Good morning", nil);
    }
    else if(hour < 12)
    {
        //上午好
        return NSLocalizedString(@"Good morning2", nil);
    }
    else if(hour < 14)
    {
        //中午好
        return NSLocalizedString(@"Good afternoon", nil);
    }
    else if(hour < 18)
    {
        //下午好
        return NSLocalizedString(@"Good afternoon2", nil);
    }
    else
    {
        //晚上好
        return NSLocalizedString(@"Good evening", nil);
    }
    
    return @"";
}

- (NSString *)osPlatform
{
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)osModel
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)osVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)appVersion
{
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    return [info objectForKey:@"CFBundleShortVersionString"];
}

- (UIDeviceResolution)resolution
{
    if(_resolution == UIDeviceResolution_Unknown) {
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (scale == 2.0f) {
                if (pixelHeight == 960.0f) {
                    _resolution = UIDeviceResolution_iPhoneRetina4;
                }
                else if (pixelHeight == 1136.0f) {
                    _resolution = UIDeviceResolution_iPhoneRetina5;
                }
                else if (pixelHeight == 1334.0f) {
                    _resolution = UIDeviceResolution_iPhoneRetina6;
                }
            } else if (scale == 1.0f) {
                if (pixelHeight == pixelHeight == 480.0f) {
                    _resolution = UIDeviceResolution_iPhoneStandard;
                }
            }
            else if (scale == 3.0f) {
                if (pixelHeight == 2208.0f) {
                    _resolution = UIDeviceResolution_iPhoneRetina6p;
                }
            }
        }
        else {
            if (scale == 2.0f && pixelHeight == 2048.0f) {
                _resolution = UIDeviceResolution_iPadRetina;
            } else if (scale == 1.0f && pixelHeight == 1024.0f) {
                _resolution = UIDeviceResolution_iPadStandard;
            }
        }
    }
    
    return _resolution;
}

- (CGSize)resSize
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    
    return CGSizeMake(mainScreen.bounds.size.width * scale, mainScreen.bounds.size.height * scale);
}

- (NSString *)resString
{
    CGSize size = [self resSize];
    return [NSString stringWithFormat:@"%ldx%ld", (long)size.width, (long)size.height];
}

@end

