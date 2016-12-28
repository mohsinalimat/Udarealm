//
//  CityInfo.h
//  Udarealm
//
//  Created by 熊国锋 on 2016/8/31.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Realm/Realm.h>
#import "ContactInfo.h"

RLM_ARRAY_TYPE(ContactInfo)

@interface CityInfo : RLMObject

@property NSString                  *city;
@property NSString                  *province;
@property float                     usage;

- (instancetype)initWithCity:(NSString *)city;

@end
