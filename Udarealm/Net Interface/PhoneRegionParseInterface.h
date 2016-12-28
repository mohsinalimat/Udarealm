//
//  PhoneRegionParseInterface.h
//  cards
//
//  Created by 熊国锋 on 16/5/24.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CommPros.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneRegionParseInterface : AFHTTPSessionManager

+ (instancetype)sharedClient;


@end

NS_ASSUME_NONNULL_END
