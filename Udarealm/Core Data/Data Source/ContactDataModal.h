//
//  ContactDataModal.h
//  Doubi
//
//  Created by 熊国锋 on 16/4/27.
//  Copyright © 2016年 Nanjing Viroyal. All rights reserved.
//

#import "BaseDataModal.h"
#import "ContactInfo.h"
#import "AvatarImage.h"
#import <Contacts/Contacts.h>



NS_ASSUME_NONNULL_BEGIN


@interface ContactDataModal : BaseDataModal

+ (instancetype)sharedClient;

- (void)initContacts;
- (nullable UIImage *)imageWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
