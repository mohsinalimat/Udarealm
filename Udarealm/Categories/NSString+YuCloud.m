//
//  NSString+YuCloud.m
//  Doubi
//
//  Created by 熊国锋 on 16/4/18.
//  Copyright © 2016年 Nanjing Viroyal. All rights reserved.
//

#import "NSString+YuCloud.h"

@implementation NSString (YuCloud)

- (NSString *)trimLeft {
    NSMutableString *string = [NSMutableString stringWithCapacity:10];
    [string setString:self];
    
    while (YES) {
        if (![string hasPrefix:@" "]) {
            break;
        }
        
        NSRange range;
        range.location = 0;
        range.length = 1;
        [string deleteCharactersInRange:range];
    }
    
    return string;
}

- (NSString *)trimRight {
    NSMutableString *string = [NSMutableString stringWithCapacity:10];
    [string setString:self];
    
    while (YES) {
        if (![string hasSuffix:@" "]) {
            break;
        }
        
        NSRange range;
        range.location = [string length] - 1;
        range.length = 1;
        [string deleteCharactersInRange:range];
    }
    
    return string;
}

- (NSString *)trimText {
    NSString *result = [self trimLeft];
    result = [result trimRight];
    
    return result;
}

@end
