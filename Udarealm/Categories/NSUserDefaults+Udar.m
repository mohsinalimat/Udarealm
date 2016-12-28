//
//  NSUserDefaults+Udar.m
//  Udar
//
//  Created by 熊国锋 on 2016/8/29.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "NSUserDefaults+Udar.h"

@implementation NSUserDefaults (Udar)

+ (NSUserDefaults *)userDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:@"Udar"];
}

+ (NSDate *)lastInitDate {
    return [[NSUserDefaults userDefaults] objectForKey:@"lastInitDate"];
}

+ (void)saveLastInitDate:(NSDate *)date {
    [[NSUserDefaults userDefaults] setObject:date forKey:@"lastInitDate"];
}

@end
