//
//  NSUserDefaults+Udar.h
//  Udar
//
//  Created by 熊国锋 on 2016/8/29.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Udar)

+ (NSDate *)lastInitDate;
+ (void)saveLastInitDate:(NSDate *)date;

@end
