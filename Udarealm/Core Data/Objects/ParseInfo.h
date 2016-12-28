//
//  ParseInfo.h
//  Udar
//
//  Created by 熊国锋 on 16/6/21.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>


NS_ASSUME_NONNULL_BEGIN

@interface ParseInfo : RLMObject

@property NSString *city;
@property NSString *cityCode;
@property NSString *mobileCode;
@property NSString *opName;
@property NSString *province;
@property NSString *zipCode;

- (instancetype)initWithMobileCode:(NSString *)mobileCode;

@end

NS_ASSUME_NONNULL_END

