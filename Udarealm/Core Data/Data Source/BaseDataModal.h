//
//  BaseDataModal.h
//  YuCloud
//
//  Created by 熊国锋 on 16/3/24.
//  Copyright © 2016年 VIROYAL-ELEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectProcessor.h"


NS_ASSUME_NONNULL_BEGIN

@class BaseDataModal;

@protocol BaseDataModalDelegate <NSObject>

@optional

- (void)dataModal:(BaseDataModal *)modal willChangeContentForKey:(nullable NSString *)key;
- (void)dataModal:(BaseDataModal *)modal didChangeContentForKey:(nullable NSString *)key;

@optional

- (void)modelDataUpdated:(BOOL)inserted;

@end

@interface BaseDataModal : NSObject < ObjectProcessDelegate >

@property (nonatomic, weak)             id <BaseDataModalDelegate>      delegate;

@property (readonly, nonatomic, strong) NSOperationQueue                *operationQueue;

- (ObjectProcessor *)newProcessor;
- (NSOperation *)addObject:(id)data;
- (NSOperation *)addObject:(id)data block:(nullable CommonBlock)block;

- (void)editObject:(id)data;
- (void)clearData:(id)data;
- (void)clearUnread:(id)data;

- (void)receiveMemoryWarning;

@end

NS_ASSUME_NONNULL_END
