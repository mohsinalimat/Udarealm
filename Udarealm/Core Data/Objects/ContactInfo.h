//
//  ContactInfo.h
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class CityInfo;

NS_ASSUME_NONNULL_BEGIN

@interface ContactInfo : RLMObject

@property NSString      *contact_id;
@property NSString      *number_id;
@property NSString      *name;
@property NSString      *number;
@property NSInteger     thumbnailImageSize;
@property NSString      *thumbnailImageID;

@property NSString      *province;
@property NSString      *city;

@property NSInteger     state;
@property float         usage;
@property NSInteger     refCount;


- (instancetype)initWithNumberId:(NSString *)number_id;

@end

NS_ASSUME_NONNULL_END

