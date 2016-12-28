//
//  ContactParser.h
//  cards
//
//  Created by 熊国锋 on 16/5/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactDataModal.h"
#import "ParseInfo.h"
#import "ProvinceInfo.h"
#import "CityInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface ParseData : NSObject

@property (nonatomic, copy) NSString    *city;
@property (nonatomic, copy) NSString    *cityCode;
@property (nonatomic, copy) NSString    *mobileCode;
@property (nonatomic, copy) NSString    *opName;
@property (nonatomic, copy) NSString    *province;
@property (nonatomic, copy) NSString    *zipCode;

- (instancetype)initWithInfo:(ParseInfo *)info;

@end

@interface ContactParser : BaseDataModal

@property (atomic, assign)  BOOL                        busy;

+ (instancetype)sharedClient;

- (void)startParse;

@end

NS_ASSUME_NONNULL_END
