//
//  ObjectProcessor.h
//  YuCloud
//
//  Created by 熊国锋 on 15/12/19.
//  Copyright © 2015年 VIROYAL-ELEC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *initContactData;
extern NSString *parseContactData;


@class ObjectProcessor;

@protocol ObjectProcessDelegate <NSObject>

- (void)processDidFinished:(ObjectProcessor *)processor;

@end

@interface ObjectProcessor : NSOperation


@property (nonatomic, weak)   id <ObjectProcessDelegate>        delegate;

@property (nonatomic, strong) NSMutableArray                    *insertDataInfo;
@property (nonatomic, strong) NSMutableArray                    *editDataInfo;
@property (nonatomic, strong) NSMutableArray                    *editMessageDataInfo;
@property (nonatomic, strong) NSMutableArray                    *clearDataInfo;
@property (nonatomic, strong) NSMutableArray                    *clearUnreadInfo;

@property (nonatomic, copy)   NSString  *identifier;



@end
