//
//  AvatarImage.m
//  Udar
//
//  Created by 熊国锋 on 16/6/21.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "AvatarImage.h"

@implementation AvatarImage

+ (NSString *)entityName {
    return @"AvatarImage";
}

+ (NSString *)primaryKey {
    return @"imageKey";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{};
}

- (instancetype)initWithKey:(NSString *)key {
    if (self = [super init]) {
        self.imageKey = key;
    }
    
    return self;
}

@end
