//
//  AvatarCache.m
//  Udar
//
//  Created by 熊国锋 on 16/6/23.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "AvatarCache.h"

@interface AvatarCache () < NSCacheDelegate >

@end

@implementation AvatarCache

+ (instancetype)cache {
    static AvatarCache *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AvatarCache alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init {
    if (self = [super init]) {
        self.totalCostLimit = 100;
        self.delegate = self;
    }
    
    return self;
}

@end
