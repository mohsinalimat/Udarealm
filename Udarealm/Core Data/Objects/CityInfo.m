//
//  CityInfo.m
//  Udarealm
//
//  Created by 熊国锋 on 2016/8/31.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo

+ (NSString *)primaryKey {
    return @"city";
}

- (instancetype)initWithCity:(NSString *)city {
    if (self = [super init]) {
        self.city = city;
    }
    
    return self;
}

@end
