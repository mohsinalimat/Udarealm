//
//  AFPlainTextResponseSerializer.m
//  YuCloud
//
//  Created by 熊国锋 on 15/10/7.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import "AFPlainTextResponseSerializer.h"

@implementation AFPlainTextResponseSerializer

static NSError * AFErrorWithUnderlyingError(NSError *error, NSError *underlyingError)
{
    if (!error)
    {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id responseObject = nil;
    NSError *serializationError = nil;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (responseString && ![responseString isEqualToString:@" "])
    {
        data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data)
        {
            if ([data length] > 0)
            {
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
            }
            else
            {
                return nil;
            }
        }
        else
        {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Data failed decoding as a UTF-8 string", @"AFNetworking", nil),
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", @"AFNetworking", nil), responseString]
                                       };
            
            serializationError = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
        }
    }
    
    if (error)
    {
        *error = AFErrorWithUnderlyingError(serializationError, *error);
    }
    
    return responseObject;
}

@end


