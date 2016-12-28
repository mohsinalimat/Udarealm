//
//  AFPlainTextResponseSerializer.h
//  YuCloud
//
//  Created by 熊国锋 on 15/10/7.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface AFPlainTextResponseSerializer : AFHTTPResponseSerializer

@property (readwrite, nonatomic, copy) NSArray *responseSerializers;

@end

