//
//  ProvinceInfo.m
//  Udarealm
//
//  Created by 熊国锋 on 2016/8/31.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ProvinceInfo.h"

@implementation ProvinceInfo

+ (NSString *)primaryKey {
    return @"province";
}

- (instancetype)initWithProvince:(NSString *)province {
    if (self = [super init]) {
        self.province = province;
    }
    
    return self;
}

@end
