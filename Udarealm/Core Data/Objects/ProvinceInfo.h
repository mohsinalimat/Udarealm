//
//  ProvinceInfo.h
//  Udarealm
//
//  Created by 熊国锋 on 2016/8/31.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Realm/Realm.h>
#import "CityInfo.h"


@interface ProvinceInfo : RLMObject

@property NSString      *province;
@property float         usage;

- (instancetype)initWithProvince:(NSString *)province;

@end
