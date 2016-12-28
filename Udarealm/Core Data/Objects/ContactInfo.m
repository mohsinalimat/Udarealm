//
//  ContactInfo.m
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo

+ (NSString *)entityName {
    return @"ContactInfo";
}

+ (NSString *)primaryKey {
    return @"number_id";
}

- (instancetype)initWithNumberId:(NSString *)number_id {
    if (self = [super init]) {
        self.number_id = number_id;
    }
    
    return self;
}

@end
