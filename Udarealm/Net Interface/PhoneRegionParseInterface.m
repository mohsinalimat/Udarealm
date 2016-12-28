//
//  PhoneRegionParseInterface.m
//  cards
//
//  Created by 熊国锋 on 16/5/24.
//  Copyright © 2016年 Bangwooo.inc. All rights reserved.
//

#import "PhoneRegionParseInterface.h"
#import "AFPlainTextResponseSerializer.h"


@implementation PhoneRegionParseInterface

+ (instancetype)sharedClient {
    static PhoneRegionParseInterface *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PhoneRegionParseInterface alloc] initWithBaseURL:[NSURL URLWithString:@"http://apicloud.mob.com/"]];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFPlainTextResponseSerializer serializer];
        [self.requestSerializer setTimeoutInterval:15];
        
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
    }
    
    return self;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(id)parameters
                              progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                               success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                               failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    if (parameters) {
        DDLogDebug(@"YuCloudInterface method: GET, url: %@, parameters: \n%@", [url absoluteString], parameters);
    }
    else {
        DDLogDebug(@"YuCloudInterface method: GET, url: %@, parameters: %@", [url absoluteString], parameters);
    }
    
    return [super GET:URLString
           parameters:parameters
             progress:downloadProgress
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  DDLogDebug(@"YuCloudInterface success url: %@, responseObject: %@", [url absoluteString], responseObject);
                  if (success) {
                      success(task, responseObject);
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  DDLogError(@"YuCloudInterface failure url: %@, error: %@", [url absoluteString], [error localizedDescription]);
                  if (failure) {
                      failure(task, error);
                  }
              }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(id)parameters
                               progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    if (parameters) {
        DDLogDebug(@"YuCloudInterface method: POST, url: %@, parameters: \n%@", [url absoluteString], parameters);
    }
    else {
        DDLogDebug(@"YuCloudInterface method: POST, url: %@, parameters: %@", [url absoluteString], parameters);
    }
    
    return [super POST:URLString
            parameters:parameters
              progress:uploadProgress
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   DDLogDebug(@"YuCloudInterface success url: %@, responseObject: %@", [url absoluteString], responseObject);
                   if (success) {
                       success(task, responseObject);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   DDLogError(@"YuCloudInterface failure url: %@, error: %@", [url absoluteString], [error localizedDescription]);
                   if (failure) {
                       failure(task, error);
                   }
               }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(id)parameters
              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                               progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    DDLogDebug(@"YuCloudInterface method: POST, url: %@, parameters: %@", [url absoluteString], parameters);
    
    return [super POST:URLString
            parameters:parameters constructingBodyWithBlock:block
              progress:uploadProgress
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   DDLogDebug(@"YuCloudInterface success url: %@, responseObject: %@", [url absoluteString], responseObject);
                   if (success) {
                       success(task, responseObject);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   DDLogError(@"YuCloudInterface failure url: %@, error: %@", [url absoluteString], [error localizedDescription]);
                   if (failure) {
                       failure(task, error);
                   }
               }];
}


@end
