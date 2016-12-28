//
//  ParseInfo.m
//  Udar
//
//  Created by 熊国锋 on 16/6/21.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "ParseInfo.h"

@implementation ParseInfo

+ (NSString *)entityName {
    return @"ParseInfo";
}

+ (NSString *)primaryKey {
    return @"mobileCode";
}

- (instancetype)initWithMobileCode:(NSString *)mobileCode {
    if (self = [super init]) {
        self.mobileCode = mobileCode;
    }
    
    return self;
}

@end
