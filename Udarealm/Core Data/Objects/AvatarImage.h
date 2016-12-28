//
//  AvatarImage.h
//  Udar
//
//  Created by 熊国锋 on 16/6/21.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarImage : RLMObject

@property NSString  *imageKey;
@property NSData    *imageData;

- (instancetype)initWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
